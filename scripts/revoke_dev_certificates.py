#!/usr/bin/env python3
"""Revoke the "Apple Development" certificate(s) this CI run created.

Xcode's cloud-managed signing (-allowProvisioningUpdates) creates a fresh
"Apple Development" certificate in the Apple account on every run, since each
GitHub-hosted runner starts with an empty keychain. Left unrevoked, these pile
up until Apple refuses to issue more ("Your account has reached the maximum
number of certificates").

This script is meant to run as a best-effort cleanup step (if: always(),
continue-on-error: true) near the end of testflight.yml, after the archive/
export steps and before the .p8 key file is removed. It:

  1. Reads the "Apple Development" certificates present in the runner's
     keychain (all of them, since the runner starts empty and only Xcode
     writes there during this run) and collects their serial numbers.
  2. Mints a short-lived ES256 JWT for the App Store Connect API from the
     same .p8 key the archive/export steps already use.
  3. Lists DEVELOPMENT/IOS_DEVELOPMENT certificates on the account and keeps
     only the ones whose serial number matches what's in the keychain.
  4. Deletes (revokes) exactly those certificates. Nothing else is ever
     touched -- in particular, DISTRIBUTION certificates are excluded by the
     list filter and never considered.

It never raises a non-zero exit for expected failure modes (missing certs,
network errors, a 403 because the API key lacks the Admin role) so it can
never fail the job on its own; the workflow step also sets
continue-on-error: true as a second safety net.
"""
import base64
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request

API_BASE = "https://api.appstoreconnect.apple.com/v1"


def log(msg):
    print(f"[revoke-dev-cert] {msg}", flush=True)


def find_keychain_serials():
    """Serial numbers (as ints) of every 'Apple Development' certificate
    found in the runner's keychain."""
    try:
        out = subprocess.run(
            ["security", "find-certificate", "-a", "-c", "Apple Development", "-p"],
            check=True, capture_output=True, text=True,
        ).stdout
    except (subprocess.CalledProcessError, OSError) as e:
        log(f"could not list keychain certificates: {e}")
        return set()

    from cryptography import x509

    serials = set()
    for pem in re.findall(
        r"-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----", out, re.S
    ):
        try:
            cert = x509.load_pem_x509_certificate(pem.encode())
        except Exception as e:
            log(f"skipping unparsable keychain certificate: {e}")
            continue
        serials.add(cert.serial_number)
    return serials


def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode()


def make_jwt(key_id: str, issuer_id: str, p8_path: str) -> str:
    """ES256 App Store Connect API JWT, raw r||s signature per RFC 7518."""
    from cryptography.hazmat.primitives import hashes, serialization
    from cryptography.hazmat.primitives.asymmetric import ec, utils

    with open(p8_path, "rb") as f:
        private_key = serialization.load_pem_private_key(f.read(), password=None)

    header = {"alg": "ES256", "kid": key_id, "typ": "JWT"}
    now = int(time.time())
    payload = {
        "iss": issuer_id,
        "iat": now,
        "exp": now + 60 * 19,  # <= 20 minutes
        "aud": "appstoreconnect-v1",
    }
    signing_input = (
        f"{b64url(json.dumps(header, separators=(',', ':')).encode())}."
        f"{b64url(json.dumps(payload, separators=(',', ':')).encode())}"
    )

    der_signature = private_key.sign(signing_input.encode(), ec.ECDSA(hashes.SHA256()))
    r, s = utils.decode_dss_signature(der_signature)
    raw_signature = r.to_bytes(32, "big") + s.to_bytes(32, "big")

    return f"{signing_input}.{b64url(raw_signature)}"


def api_request(method, path, token, query=None):
    url = f"{API_BASE}{path}"
    if query:
        url += f"?{query}"
    req = urllib.request.Request(url, method=method)
    req.add_header("Authorization", f"Bearer {token}")
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            body = resp.read()
            return resp.status, (json.loads(body) if body else {})
    except urllib.error.HTTPError as e:
        body = e.read()
        try:
            parsed = json.loads(body) if body else {}
        except json.JSONDecodeError:
            parsed = {}
        return e.code, parsed
    except urllib.error.URLError as e:
        log(f"network error calling {method} {path}: {e}")
        return 0, {}


def list_development_certificates(token):
    """Returns (certs, status). status == 403 means the key lacks permission."""
    certs = []
    path = "/certificates"
    query = "filter[certificateType]=DEVELOPMENT,IOS_DEVELOPMENT&limit=200"
    while path:
        status, data = api_request("GET", path, token, query)
        if status == 403:
            return None, status
        if status != 200:
            log(f"unexpected status {status} listing certificates: {data}")
            return certs, status
        certs.extend(data.get("data", []))
        next_url = data.get("links", {}).get("next")
        if not next_url:
            break
        path = next_url[len(API_BASE):]
        query = None
        if "?" in path:
            path, query = path.split("?", 1)
    return certs, 200


def normalize_serial(serial_str):
    """Apple's API serialNumber is a hex string; case and leading zeros vary.
    Comparing as integers normalizes both."""
    try:
        return int(serial_str, 16)
    except (TypeError, ValueError):
        return None


def main():
    if len(sys.argv) != 2:
        log("usage: revoke_dev_certificates.py <path-to-AuthKey.p8>")
        return 0

    p8_path = sys.argv[1]
    key_id = os.environ.get("ASC_KEY_ID", "")
    issuer_id = os.environ.get("ASC_ISSUER_ID", "")

    if not key_id or not issuer_id:
        log("ASC_KEY_ID/ASC_ISSUER_ID not set, skipping certificate cleanup")
        return 0

    if not os.path.isfile(p8_path):
        log(f"no API key file at {p8_path}, skipping certificate cleanup")
        return 0

    keychain_serials = find_keychain_serials()
    if not keychain_serials:
        log("no 'Apple Development' certificates found in the keychain, nothing to revoke")
        return 0
    log(f"found {len(keychain_serials)} 'Apple Development' certificate(s) in the runner's keychain")

    try:
        token = make_jwt(key_id, issuer_id, p8_path)
    except Exception as e:
        log(f"could not generate an App Store Connect API token: {e}")
        return 0

    certs, status = list_development_certificates(token)
    if status == 403:
        log("WARNING: App Store Connect API returned 403 listing certificates. "
            "The API key needs the Admin role to manage certificates. Skipping cleanup.")
        return 0
    if not certs:
        log("could not list any development certificates from App Store Connect, skipping cleanup")
        return 0

    to_delete = []
    for cert in certs:
        serial = normalize_serial(cert.get("attributes", {}).get("serialNumber"))
        if serial is not None and serial in keychain_serials:
            to_delete.append((cert["id"], cert["attributes"].get("serialNumber")))

    if not to_delete:
        log("no App Store Connect certificate matched this run's keychain serials")
        return 0

    for cert_id, serial_str in to_delete:
        status, data = api_request("DELETE", f"/certificates/{cert_id}", token)
        if status == 403:
            log(f"WARNING: 403 revoking certificate id={cert_id} serial={serial_str}. "
                "The API key needs the Admin role to manage certificates.")
        elif status in (200, 204):
            log(f"revoked certificate id={cert_id} serial={serial_str}")
        else:
            log(f"failed to revoke certificate id={cert_id} serial={serial_str}: status={status} {data}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
