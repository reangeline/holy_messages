#!/usr/bin/env python3
"""Monta os catálogos do Exame a partir de conteúdo editorial + Bíblia real.

Divisão deliberada de responsabilidades:

- O texto bíblico NUNCA é digitado aqui. Vem por extração das edições em
  `fontes/catholic-bible-v2`: Matos Soares 1956 (pt-BR, domínio público) e
  Douay-Rheims (en). Se uma referência não existir na edição, o script para.
- O que é redação própria — título, por que aquele salmo, o fato do santo, o
  passo concreto — vive em `scripts/exam_relief_content/`, um módulo por bloco
  de estados.
- A referência MOSTRADA ao leitor é a numeração das edições atuais (hebraica),
  convertida aqui a partir da numeração da Vulgata usada pelas duas edições.
  Converter à mão 480 vezes seria errar; o script faz a conta.

Por que as duas edições precisam de referências separadas: elas dividem os
versículos de forma diferente. Vulg 130,2 em Matos Soares traz "como um menino
no regaço de sua mãe"; a mesma referência em Douay traz outro texto. E Vulg
28,11 simplesmente não existe em Douay. Por isso cada idioma declara o seu
`ref`, e o script confere os dois contra a sua própria edição.
"""

from __future__ import annotations

import importlib
import json
import pathlib
import pkgutil
import re
import sys
from collections import Counter, defaultdict

FONTES = pathlib.Path("/Users/reangeline/Documents/Missale-pesquisa/fontes/catholic-bible-v2")
SAIDA = pathlib.Path("/Users/reangeline/Documents/Missale-pesquisa/entregas/exame-revisado")
CONTENT_PKG = pathlib.Path(__file__).parent / "exam_relief_content"

EDICOES = {
    "pt": ("matos-soares.json", "Matos Soares 1956 (pt-BR, domínio público)"),
    "en": ("douay-rheims.json", "Douay-Rheims (domínio público)"),
}

# O espanhol não tem Saltério católico em domínio público num JSON estruturado:
# o único fac-símile disponível é OCR danificado. A base é um inventário curado
# à mão a partir do Tomo VII de Torres Amat (Paris, 1836), com página do
# fac-símile e a referência tal como está impressa — ver SOURCES_ES.md. Aqui o
# texto é copiado desse inventário pelo id da passagem; nunca traduzido do
# português nem do inglês.
ES_INVENTARIO = SAIDA / "torres_amat_1836_salmos.es.json"
CONTENT_PKG_ES = pathlib.Path(__file__).parent / "exam_relief_content_es"

ROMANOS = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}


def de_romano(texto: str) -> int:
    total = 0
    maior = 0
    for ch in reversed(texto.upper()):
        valor = ROMANOS[ch]
        total += valor if valor >= maior else -valor
        maior = max(maior, valor)
    return total

STATE_IDS = (
    "peace", "grateful", "joyful", "hopeful", "forgiven", "loved", "steadfast",
    "empty", "anxious", "guilty", "grief", "lonely", "angry", "dryness", "doubtful", "tired",
)

# Salmos cuja passagem Vulgata->hebraica envolve junção ou divisão (Vulg 9 cobre
# Heb 9+10; Vulg 113 cobre Heb 114+115; Vulg 114+115 formam Heb 116; Vulg
# 146+147 formam Heb 147). Nesses casos o versículo também desloca, e o mapa de
# capítulo sozinho mentiria — então eles ficam fora da seleção, por decisão
# editorial, e o script recusa quem tentar usá-los.
VULGATA_AMBIGUOS = {9, 113, 114, 115, 146, 147}


def hebraico(capitulo: int) -> int:
    """Capítulo na numeração das edições atuais, a partir da Vulgata."""
    if capitulo in VULGATA_AMBIGUOS:
        raise ValueError(
            f"Salmo {capitulo} da Vulgata tem passagem ambígua para a numeração atual; escolha outro"
        )
    if 1 <= capitulo <= 8 or 148 <= capitulo <= 150:
        return capitulo
    if 10 <= capitulo <= 112 or 116 <= capitulo <= 145:
        return capitulo + 1
    raise ValueError(f"Salmo fora de faixa: {capitulo}")


def carregar_biblia(lang: str) -> dict:
    arquivo, _ = EDICOES[lang]
    return json.loads((FONTES / arquivo).read_text())["verses"]


def texto(biblia: dict, lang: str, capitulo: int, versiculos: tuple[int, ...]) -> str:
    partes = []
    for v in versiculos:
        chave = f"PSA.{capitulo}.{v}"
        entrada = biblia.get(chave)
        if entrada is None:
            raise ValueError(
                f"{lang}: {chave} não existe na edição {EDICOES[lang][1]} — "
                "confira a referência nessa edição, não na outra"
            )
        partes.append(entrada["text"].strip())
    return " ".join(partes)


def rotulo(lang: str, capitulo: int, versiculos: tuple[int, ...]) -> str:
    cap = hebraico(capitulo)
    if len(versiculos) == 1:
        faixa = str(versiculos[0])
    else:
        faixa = f"{versiculos[0]}-{versiculos[-1]}"
    return f"Psalm {cap}:{faixa}" if lang == "en" else f"Salmo {cap}, {faixa}"


def carregar_blocos() -> dict[str, list[dict]]:
    sys.path.insert(0, str(CONTENT_PKG.parent))
    estados: dict[str, list[dict]] = defaultdict(list)
    nomes = sorted(m.name for m in pkgutil.iter_modules([str(CONTENT_PKG)])
                   if not m.name.startswith("_"))
    if not nomes:
        raise SystemExit(f"Nenhum bloco de conteúdo em {CONTENT_PKG}")
    for nome in nomes:
        modulo = importlib.import_module(f"exam_relief_content.{nome}")
        for estado, respostas in modulo.BLOCK.items():
            if estado not in STATE_IDS:
                raise ValueError(f"{nome}: estado desconhecido {estado!r}")
            estados[estado].extend(respostas)
        print(f"  bloco {nome}: {', '.join(sorted(modulo.BLOCK))}")
    return estados


def montar(lang: str, estados: dict[str, list[dict]]) -> list[dict]:
    biblia = carregar_biblia(lang)
    _, nome_edicao = EDICOES[lang]
    linhas = []
    for estado in STATE_IDS:
        for resposta in estados.get(estado, []):
            local = resposta[lang]
            capitulo, versiculos = local["ref"]
            versiculos = tuple(versiculos) if isinstance(versiculos, (list, tuple)) else (versiculos,)
            linhas.append({
                "stateId": estado,
                "title": local["title"],
                "psalmRef": rotulo(lang, capitulo, versiculos),
                "psalmText": texto(biblia, lang, capitulo, versiculos),
                "psalmWhy": local["psalmWhy"],
                "saintID": resposta["saintID"],
                "saintName": local["saintName"],
                "saintWhy": local["saintWhy"],
                "stepTitle": local["stepTitle"],
                "stepBody": local["stepBody"],
                "source": f"{nome_edicao}; Salmo {capitulo} na numeração da edição. {local['saintSource']}",
            })
    return linhas


def carregar_inventario_es() -> tuple[dict, dict]:
    dados = json.loads(ES_INVENTARIO.read_text())
    passagens = {p["id"]: p for p in dados["passages"]}
    return dados["source"], passagens


def montar_es(passagens: dict, fonte: dict) -> list[dict]:
    sys.path.insert(0, str(CONTENT_PKG_ES.parent))
    nomes = sorted(m.name for m in pkgutil.iter_modules([str(CONTENT_PKG_ES)])
                   if not m.name.startswith("_"))
    estados: dict[str, list[dict]] = defaultdict(list)
    for nome in nomes:
        modulo = importlib.import_module(f"exam_relief_content_es.{nome}")
        for estado, respostas in modulo.BLOCK.items():
            if estado not in STATE_IDS:
                raise ValueError(f"{nome}: estado desconhecido {estado!r}")
            estados[estado].extend(respostas)
        print(f"  bloco es {nome}: {', '.join(sorted(modulo.BLOCK))}")

    edicao = f"{fonte['translator']}, {fonte['volume']}, {fonte['publication']}"
    linhas = []
    for estado in STATE_IDS:
        for resposta in estados.get(estado, []):
            passagem = passagens.get(resposta["passage"])
            if passagem is None:
                raise ValueError(f"es/{estado}: passagem {resposta['passage']!r} não está no inventário")
            if estado not in passagem["states"]:
                raise ValueError(
                    f"es/{estado}: a passagem {resposta['passage']} não foi curada para este estado "
                    f"(está em {', '.join(passagem['states'])}) — a pertinência pastoral é da curadoria, não minha"
                )
            capitulo_vulgata, faixa = ref_impressa(passagem["ref"])
            linhas.append({
                "stateId": estado,
                "title": resposta["title"],
                "psalmRef": f"Salmo {hebraico(capitulo_vulgata)}, {faixa}",
                "psalmText": passagem["text"],
                "psalmWhy": resposta["psalmWhy"],
                "saintID": resposta["saintID"],
                "saintName": resposta["saintName"],
                "saintWhy": resposta["saintWhy"],
                "stepTitle": "Un paso concreto",
                "stepBody": resposta["stepBody"],
                "source": (
                    f"{edicao}; impresso como {passagem['ref']}, fac-símile p. {passagem['pdfPage']}. "
                    f"{resposta.get('saintSource', 'Biografía: vatican.va (por confirmar).')}"
                ),
            })
    return linhas


def ref_impressa(ref: str) -> tuple[int, str]:
    """"Salmo XLV, 10–12" -> (45, "10-12"), na numeração impressa da edição."""
    m = re.match(r"Salmo ([IVXLCDM]+),\s*(\d+)(?:[\u2013-](\d+))?$", ref.strip())
    if not m:
        raise ValueError(f"referência impressa fora do padrão: {ref!r}")
    capitulo = de_romano(m.group(1))
    faixa = m.group(2) if not m.group(3) else f"{m.group(2)}-{m.group(3)}"
    return capitulo, faixa


def conferir(lang: str, linhas: list[dict]) -> list[str]:
    """As mesmas regras do importador, mais cedo: falha aqui é mais barata."""
    problemas = []
    por_estado = defaultdict(list)
    for linha in linhas:
        por_estado[linha["stateId"]].append(linha)
    for estado, grupo in sorted(por_estado.items()):
        for campo, nome in (("title", "título"), ("psalmWhy", "explicação"), ("stepBody", "passo")):
            repetidos = [v for v, n in Counter(l[campo].strip() for l in grupo).items() if n > 1]
            if repetidos:
                problemas.append(f"{lang}/{estado}: {nome} repetido ({len(repetidos)})")
        pares = Counter((l["psalmRef"], l["saintID"]) for l in grupo)
        if any(n > 1 for n in pares.values()):
            problemas.append(f"{lang}/{estado}: par salmo+santo repetido")
    return problemas


def main() -> None:
    print("Blocos de conteúdo:")
    estados = carregar_blocos()
    SAIDA.mkdir(parents=True, exist_ok=True)

    print("\nPor estado:")
    for estado in STATE_IDS:
        n = len(estados.get(estado, []))
        marca = "" if n == 15 else ("  <-- incompleto" if n else "  <-- vazio")
        print(f"  {estado:10} {n:2}{marca}")

    problemas_totais = []
    fonte_es, passagens_es = carregar_inventario_es()
    for lang in ("pt", "en", "es"):
        linhas = montar_es(passagens_es, fonte_es) if lang == "es" else montar(lang, estados)
        problemas = conferir(lang, linhas)
        problemas_totais += problemas
        destino = SAIDA / f"exam_relief_catalog.{lang}.json"
        destino.write_text(json.dumps(linhas, ensure_ascii=False, indent=2) + "\n")
        print(f"\n{lang}: {len(linhas)} registros -> {destino.name}")
        for p in problemas:
            print(f"   ! {p}")

    if problemas_totais:
        raise SystemExit("\nRevise os problemas acima antes de importar.")


if __name__ == "__main__":
    main()
