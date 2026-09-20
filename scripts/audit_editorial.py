#!/usr/bin/env python3
"""Lista registros de pesquisa que ainda exigem conferência editorial.

O relatório é deliberadamente produzido fora do app: `verificar: true` é uma
decisão sobre a fonte, não uma string que a pessoa usuária deva ver.
"""

from __future__ import annotations

import json
import pathlib
from collections import Counter


ENTREGAS = pathlib.Path("/Users/reangeline/Documents/Missale-pesquisa/entregas")
REPORT = ENTREGAS / "RELATORIO-REVISAO-EDITORIAL.md"


def label(record: dict) -> str:
    for key in ("id", "title", "name", "reference", "stateId", "trackId"):
        value = record.get(key)
        if isinstance(value, str) and value.strip():
            return f"`{key}`: {value.strip()}"
    return "sem identificador legível"


def source_label(record: dict) -> str:
    for key in ("fonte", "source", "lectionarySource", "textNote"):
        value = record.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    text_source = record.get("textSource")
    if isinstance(text_source, dict):
        edition = text_source.get("edition")
        if isinstance(edition, str) and edition.strip():
            return edition.strip()
    return "fonte não registrada"


def main() -> None:
    pending: dict[pathlib.Path, list[dict]] = {}
    unreadable: list[pathlib.Path] = []
    for path in sorted(ENTREGAS.rglob("*.json")):
        try:
            payload = json.loads(path.read_text())
        except (OSError, json.JSONDecodeError):
            unreadable.append(path)
            continue
        records = payload if isinstance(payload, list) else []
        matches = [record for record in records if isinstance(record, dict) and record.get("verificar") is True]
        if matches:
            pending[path] = matches

    lines = [
        "# Revisão editorial pendente",
        "",
        "Gerado por `scripts/audit_editorial.py`. Um registro marcado `verificar: true` não deve ser considerado pronto para publicação até a edição, a referência e a permissão aplicável terem sido conferidas.",
        "",
        f"**Total:** {sum(len(rows) for rows in pending.values())} registros em {len(pending)} arquivos.",
        "",
    ]
    by_collection: Counter[str] = Counter()
    by_language: Counter[str] = Counter()
    without_source = 0
    for path, records in pending.items():
        relative = path.relative_to(ENTREGAS)
        collection = relative.parts[0] if len(relative.parts) > 1 else path.stem
        by_collection[collection] += len(records)
        for record in records:
            language = record.get("lang")
            by_language[language if isinstance(language, str) else "sem idioma"] += 1
            if source_label(record) == "fonte não registrada":
                without_source += 1
    lines.extend([
        "## Resumo por coleção",
        "",
        *[f"- `{collection}`: {count}" for collection, count in sorted(by_collection.items())],
        "",
        "## Resumo por idioma",
        "",
        *[f"- `{language}`: {count}" for language, count in sorted(by_language.items())],
        "",
        f"**Registros sem fonte identificada no próprio JSON:** {without_source}.",
        "",
    ])
    for path, records in pending.items():
        lines.extend([f"## {path.relative_to(ENTREGAS)}", ""])
        for record in records:
            source = source_label(record)
            lines.append(f"- {label(record)} — {source}")
        lines.append("")

    if unreadable:
        lines.extend(["## Arquivos que não foram lidos", ""])
        lines.extend(f"- `{path.relative_to(ENTREGAS)}`" for path in unreadable)
        lines.append("")

    REPORT.write_text("\n".join(lines))
    print(f"Relatório escrito em {REPORT}: {sum(len(rows) for rows in pending.values())} pendências")


if __name__ == "__main__":
    main()
