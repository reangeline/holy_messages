#!/usr/bin/env python3
"""Importa um lote de santos do dia, revisado, para um arquivo Swift próprio.

Os lotes antigos vêm de ~/Projects/Missale/Missale-pesquisa por import_saint_art.py.
Um lote novo fica no repositório e gera o seu próprio arquivo, para que
reimportar um não apague o outro:

    python3 scripts/import_saints_batch.py \\
        --lote scripts/lotes/santos-segundo-lote \\
        --saida Sources/MockData/Generated/GeneratedSaintsSecondBatch.swift \\
        --sufixo SecondBatch

Cada registro precisa de fonte com URL, e os três idiomas precisam ter os mesmos
ids e as mesmas datas. `Saint` não guarda a fonte; ela vai como comentário ao
lado da ficha, para continuar consultável no código.
"""

from __future__ import annotations

import argparse
import json
import pathlib
import re
import sys

LANGUAGES = ("pt", "en", "es")
REQUIRED = ("id", "dateKey", "name", "role", "rank", "calendarNote", "why", "prayer", "fonte")


def swift(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def read(folder: pathlib.Path, language: str) -> list[dict]:
    path = folder / f"saints.{language}.json"
    payload = json.loads(path.read_text())
    if not isinstance(payload, list):
        raise ValueError(f"{path} deve conter uma lista")
    return payload


def validate(rows: list[dict], language: str) -> dict[str, str]:
    errors: list[str] = []
    dates: dict[str, str] = {}
    for number, row in enumerate(rows, start=1):
        missing = [key for key in REQUIRED if not isinstance(row.get(key), str) or not row[key].strip()]
        if missing:
            errors.append(f"{language}, registro {number}: campos vazios: {', '.join(missing)}")
        if not isinstance(row.get("bio"), list) or not row["bio"]:
            errors.append(f"{language}, registro {number}: sem parágrafos de biografia")
        if "http" not in row.get("fonte", ""):
            errors.append(f"{language}, registro {number}: fonte sem URL")
        if not re.fullmatch(r"\d\d-\d\d", row.get("dateKey", "")):
            errors.append(f"{language}, registro {number}: dateKey fora do formato MM-dd")
        if row.get("id") in dates:
            errors.append(f"{language}: id duplicado {row['id']}")
        dates[row.get("id", "")] = row.get("dateKey", "")
    if errors:
        raise ValueError("\n".join(errors))
    return dates


def render(language: str, rows: list[dict], suffix: str) -> str:
    out = [f"    static let {language}Saints{suffix}: [Saint] = [\n"]
    for row in rows:
        out += [
            f"        // Fonte: {row['fonte']}\n",
            "        .init(\n",
            f"            id: {swift(row['id'])},\n",
            f"            name: {swift(row['name'])},\n",
            f"            lifespan: {swift(row.get('lifespan', ''))},\n",
            f"            role: {swift(row['role'])},\n",
            f"            rank: {swift(row['rank'])},\n",
            f"            calendarNote: {swift(row['calendarNote'])},\n",
            f"            bioParagraphs: [{', '.join(swift(p) for p in row['bio'])}],\n",
            f"            whyItMattersToday: {swift(row['why'])},\n",
            f"            prayer: {swift(row['prayer'])}\n",
            "        ),\n",
        ]
    out.append("    ]\n\n")
    out.append(f"    static let {language}Calendar{suffix}: [SaintOfDay] = [\n")
    for row in rows:
        out.append(f"        SaintOfDay(dateKey: {swift(row['dateKey'])}, region: .general, "
                   f"saint: {language}Saints{suffix}.first {{ $0.id == {swift(row['id'])} }}!),\n")
    out.append("    ]\n\n")
    return "".join(out)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lote", type=pathlib.Path, required=True)
    parser.add_argument("--saida", type=pathlib.Path, required=True)
    parser.add_argument("--sufixo", required=True)
    args = parser.parse_args()
    catalogs = {language: read(args.lote, language) for language in LANGUAGES}
    canonical = validate(catalogs["pt"], "pt")
    for language in ("en", "es"):
        if validate(catalogs[language], language) != canonical:
            raise ValueError(f"{language}: ids ou datas diferem do lote português")
    output = [
        "// GERADO — não editar à mão.\n",
        f"// Origem: {args.lote}, importado por scripts/import_saints_batch.py.\n\n",
        "import Foundation\n\n",
        "extension MockSaints {\n",
    ]
    output += [render(language, catalogs[language], args.sufixo) for language in LANGUAGES]
    output.append("}\n")
    args.saida.write_text("".join(output))
    print(f"Importados: {len(canonical)} santos × 3 idiomas")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, FileNotFoundError, json.JSONDecodeError) as error:
        print(f"Santos não importados:\n{error}", file=sys.stderr)
        sys.exit(1)
