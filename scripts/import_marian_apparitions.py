#!/usr/bin/env python3
"""Importa aparições marianas já revisadas para o catálogo Swift.

As três edições linguísticas são fontes de conteúdo independentes. O
importador recusa qualquer registro ainda marcado `verificar: true`; assim o
app nunca apresenta uma fórmula canônica provisória como fato publicado.
"""

from __future__ import annotations

import json
import pathlib
import sys


ROOT = pathlib.Path("/Users/reangeline")
INPUT = ROOT / "Documents/Missale-pesquisa/entregas/aparicoes-marianas-primeiro-lote"
OUTPUT = ROOT / "Projects/holy_messages/Sources/MockData/Generated/GeneratedMarianApparitions.swift"
LANGUAGES = ("pt", "en", "es")
REQUIRED = ("id", "name", "place", "year", "visionaries", "summary", "recognition", "fonte")


def swift(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def read(language: str) -> list[dict]:
    path = INPUT / f"apparition_additions.{language}.json"
    try:
        payload = json.loads(path.read_text())
    except FileNotFoundError as error:
        raise ValueError(f"Falta o catálogo {path}") from error
    except json.JSONDecodeError as error:
        raise ValueError(f"JSON inválido em {path}: {error}") from error
    if not isinstance(payload, list):
        raise ValueError(f"{path} deve conter uma lista")
    return payload


def validate(rows: list[dict], language: str, expected_ids: set[str] | None) -> set[str]:
    errors: list[str] = []
    ids: set[str] = set()
    for number, row in enumerate(rows, start=1):
        if not isinstance(row, dict):
            errors.append(f"{language}, registro {number}: não é objeto")
            continue
        missing = [key for key in REQUIRED if not isinstance(row.get(key), str) or not row[key].strip()]
        if missing:
            errors.append(f"{language}, registro {number}: campos vazios: {', '.join(missing)}")
        if row.get("verificar") is True:
            errors.append(f"{language}, registro {number}: ainda marcado para revisão editorial")
        source = row.get("fonte", "")
        if isinstance(source, str) and not ("https://" in source or "http://" in source):
            errors.append(f"{language}, registro {number}: fonte sem URL")
        identifier = row.get("id")
        if isinstance(identifier, str):
            if identifier in ids:
                errors.append(f"{language}: id duplicado {identifier}")
            ids.add(identifier)
    if expected_ids is not None and ids != expected_ids:
        errors.append(f"{language}: ids diferem do catálogo português")
    if errors:
        raise ValueError("\n".join(errors))
    return ids


def render(language: str, rows: list[dict]) -> str:
    lines = [f"    static let {language}Apparitions: [MarianApparition] = [\n"]
    for row in rows:
        lines.extend([
            "        .init(\n",
            f"            id: {swift(row['id'])},\n",
            f"            name: {swift(row['name'])},\n",
            f"            place: {swift(row['place'])},\n",
            f"            year: {swift(row['year'])},\n",
            f"            visionaries: {swift(row['visionaries'])},\n",
            f"            summary: {swift(row['summary'])},\n",
            f"            ecclesialRecognition: {swift(row['recognition'])},\n",
            f"            source: {swift(row['fonte'])}\n",
            "        ),\n",
        ])
    lines.append("    ]\n\n")
    return "".join(lines)


def main() -> None:
    catalogs = {language: read(language) for language in LANGUAGES}
    canonical_ids = validate(catalogs["pt"], "pt", None)
    for language in ("en", "es"):
        validate(catalogs[language], language, canonical_ids)
    output = [
        "// GERADO — não editar à mão.\n",
        "// Origem: ~/Documents/Missale-pesquisa/entregas/aparicoes-marianas-primeiro-lote,\n",
        "// importado por scripts/import_marian_apparitions.py.\n\n",
        "import Foundation\n\n",
        "extension MockMarianApparitions {\n",
    ]
    for language in LANGUAGES:
        output.append(render(language, catalogs[language]))
    output.append("}\n")
    OUTPUT.write_text("".join(output))
    print("Importadas: 3 aparições × 3 idiomas")


if __name__ == "__main__":
    try:
        main()
    except ValueError as error:
        print(f"Aparições não importadas:\n{error}", file=sys.stderr)
        sys.exit(1)
