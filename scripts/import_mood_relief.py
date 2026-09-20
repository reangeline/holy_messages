#!/usr/bin/env python3
"""Importa o catálogo trilingue do Exame do dia após a revisão editorial.

O lote anterior em `exame-160-variacoes` é material de pesquisa, não entrada
deste importador: ele repete o mesmo motivo e passo dez vezes por estado. A
entrada aceita apenas catálogos completos em `exame-revisado`, com quinze
respostas próprias para cada um dos dezesseis estados e fonte identificada em
cada registro.
"""

from __future__ import annotations

import json
import pathlib
import re
import sys
from collections import Counter, defaultdict


ROOT = pathlib.Path("/Users/reangeline")
ENTREGAS = ROOT / "Documents/Missale-pesquisa/entregas/exame-revisado"
OUTPUT = ROOT / "Projects/holy_messages/Sources/MockData/Generated/GeneratedMoodRelief.swift"
LANGS = ("pt", "en", "es")
STATE_IDS = (
    "peace", "grateful", "joyful", "hopeful", "forgiven", "loved", "steadfast",
    "empty", "anxious", "guilty", "grief", "lonely", "angry", "dryness", "doubtful", "tired",
)
REQUIRED = (
    "stateId", "title", "psalmRef", "psalmText", "psalmWhy", "saintName",
    "saintWhy", "stepTitle", "stepBody", "source",
)
EXPECTED_PER_STATE = 15

HEADER = """// GERADO — não editar à mão.
// Origem: ~/Documents/Missale-pesquisa/entregas/exame-revisado, importado por
// scripts/import_mood_relief.py. Cada catálogo tem quinze respostas próprias
// por estado, com texto bíblico e fonte indicados no JSON de origem.
//

import Foundation

extension MockMood {
"""


def swift_string(value: str) -> str:
    value = value.replace("\\", "\\\\").replace('"', '\\"')
    value = value.replace("\n", "\\n").replace("\r", "")
    return f'"{value}"'


def read_catalog(language: str) -> list[dict]:
    path = ENTREGAS / f"exam_relief_catalog.{language}.json"
    if not path.exists():
        raise ValueError(f"Falta o catálogo revisado: {path}")
    try:
        rows = json.loads(path.read_text())
    except json.JSONDecodeError as error:
        raise ValueError(f"JSON inválido em {path}: {error}") from error
    if not isinstance(rows, list):
        raise ValueError(f"{path} deve conter uma lista de registros")
    return rows


def validate(rows: list[dict], language: str) -> None:
    by_state: dict[str, list[dict]] = defaultdict(list)
    errors: list[str] = []
    for position, row in enumerate(rows, start=1):
        if not isinstance(row, dict):
            errors.append(f"{language} registro {position}: não é objeto")
            continue
        absent = [key for key in REQUIRED if not isinstance(row.get(key), str) or not row[key].strip()]
        if absent:
            errors.append(f"{language} registro {position}: campos ausentes ou vazios: {', '.join(absent)}")
            continue
        state = row["stateId"]
        if state not in STATE_IDS:
            errors.append(f"{language} registro {position}: estado desconhecido {state!r}")
            continue
        by_state[state].append(row)

    for state in STATE_IDS:
        variants = by_state.get(state, [])
        if len(variants) != EXPECTED_PER_STATE:
            errors.append(
                f"{language}/{state}: esperadas {EXPECTED_PER_STATE} respostas, recebidas {len(variants)}"
            )
            continue
        for field, label in (("psalmWhy", "explicação"), ("stepBody", "passo concreto"), ("title", "título")):
            duplicates = [value for value, count in Counter(row[field].strip() for row in variants).items() if count > 1]
            if duplicates:
                errors.append(f"{language}/{state}: {label} repetido em {len(duplicates)} valor(es)")
        pairs = Counter((row["psalmWhy"].strip(), row["stepBody"].strip()) for row in variants)
        if any(count > 1 for count in pairs.values()):
            errors.append(f"{language}/{state}: há pares repetidos de explicação e passo")

    if errors:
        raise ValueError("\n".join(errors))


def render_catalog(language: str, rows: list[dict]) -> str:
    grouped: dict[str, list[dict]] = defaultdict(list)
    for row in rows:
        grouped[row["stateId"]].append(row)

    result = [f"    static let {language}ReviewedReliefByState: [String: [ReliefContent]] = [\n"]
    for state in STATE_IDS:
        result.append(f"        {swift_string(state)}: [\n")
        for row in grouped[state]:
            result.append(
                "            .init(\n"
                f"                title: {swift_string(row['title'])},\n"
                f"                psalmRef: {swift_string(row['psalmRef'])},\n"
                f"                psalmText: {swift_string(row['psalmText'])},\n"
                f"                psalmWhy: {swift_string(row['psalmWhy'])},\n"
                f"                saintName: {swift_string(row['saintName'])},\n"
                f"                saintWhy: {swift_string(row['saintWhy'])},\n"
                f"                stepTitle: {swift_string(row['stepTitle'])},\n"
                f"                stepBody: {swift_string(row['stepBody'])}\n"
                "            ),\n"
            )
        result.append("        ],\n")
    result.append("    ]\n\n")
    return "".join(result)


def main() -> None:
    catalogs = {language: read_catalog(language) for language in LANGS}
    for language, rows in catalogs.items():
        validate(rows, language)

    output = [HEADER]
    for language in LANGS:
        output.append(render_catalog(language, catalogs[language]))
    output.append("}\n")
    OUTPUT.write_text("".join(output))
    print(f"Importado: {', '.join(f'{lang}=240' for lang in LANGS)}")


if __name__ == "__main__":
    try:
        main()
    except ValueError as error:
        print(f"Exame não importado:\n{error}", file=sys.stderr)
        sys.exit(1)
