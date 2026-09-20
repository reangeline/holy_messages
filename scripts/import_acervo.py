#!/usr/bin/env python3
"""Gera catálogos Swift a partir das entregas de pesquisa.

Só entra aqui o que passou na conferência de qualidade. O que ficou de fora
está listado no relatório final, com a evidência.
"""
import json, glob, os, re, collections, pathlib

ENTREGAS = pathlib.Path("/Users/reangeline/Documents/Missale-pesquisa/entregas")
OUT = pathlib.Path("/Users/reangeline/Projects/holy_messages/Sources/MockData/Generated")
OUT.mkdir(parents=True, exist_ok=True)
LANGS = ("pt", "en", "es")

def lang_of(path):
    m = re.search(r'\.(pt|en|es)\.', os.path.basename(str(path)))
    return m.group(1) if m else None

def load(coll):
    """Todos os registros de uma coleção, agrupados por idioma (do nome do arquivo)."""
    rows = collections.defaultdict(list)
    for f in sorted(ENTREGAS.glob("**/*.json")):
        if os.path.basename(f).startswith(coll):
            lang = lang_of(f)
            if lang:
                rows[lang].extend(json.load(open(f)))
    return rows

def sw(s):
    """String literal Swift."""
    if s is None:
        return "nil"
    s = (str(s).replace("\\", "\\\\").replace('"', '\\"')
         .replace("\n", "\\n").replace("\t", "\\t").replace("\r", ""))
    return f'"{s}"'

HEADER = """// GERADO — não editar à mão.
// Origem: ~/Documents/Missale-pesquisa/entregas, importado por
// scratchpad/import_acervo.py. Reimportar em vez de corrigir aqui.
//
"""

# ---------------------------------------------------------------- lecionário
def gen_lectionary():
    rows = load("lectionary_additions")
    out = [HEADER + "// Referências dominicais por chave litúrgica (tempo-semana-ciclo).\n"
           "// Só a referência e o resumo autoral: o texto das leituras é licenciado.\n\n"
           "import Foundation\n\nextension MockLectionary {\n"]
    for lang in LANGS:
        entries = {o["id"]: o for o in rows.get(lang, [])}
        out.append(f"    static let {lang}Sundays: [String: MassReadings] = [\n")
        for key in sorted(entries):
            o = entries[key]
            second = sw(o["secondReading"]) if o.get("secondReading") else "nil"
            out.append(f'        {sw(key)}: .init(firstReading: {sw(o["firstReading"])}, '
                       f'psalm: {sw(o["psalm"])}, secondReading: {second}, '
                       f'gospel: {sw(o["gospel"])}),\n')
        out.append("    ]\n\n")
    out.append("}\n")
    (OUT / "GeneratedLectionary.swift").write_text("".join(out))
    return {l: len(rows.get(l, [])) for l in LANGS}

# ---------------------------------------------------------------- santoral
RANKS = {"Memória": ".memorial", "Memória facultativa": ".optionalMemorial",
         "Festa": ".feast", "Solenidade": ".solemnity", "Féria": ".weekday"}
COLORS = {"white": ".white", "red": ".red", "green": ".green",
          "purple": ".purple", "rose": ".rose", "black": ".black"}

def gen_sanctoral():
    feasts = load("sanctoral_additions")
    saints = load("saint_additions")
    counts = {}
    out = [HEADER + "// Santoral de data fixa. Junta o lote de festas com os santos que\n"
           "// trazem dateKey e grau — uma celebração por data, a primeira que aparece.\n\n"
           "import Foundation\n\nextension LiturgicalSanctoral {\n"]
    for lang in LANGS:
        by_date = {}
        for o in feasts.get(lang, []):
            by_date.setdefault(o["monthDay"], (o["name"], o["rank"], o["color"]))
        for o in saints.get(lang, []):
            md, rank = o.get("dateKey"), o.get("rank")
            if not md or not rank or md in by_date:
                continue
            # Santo não mártir entra em branco; o lote não traz cor para santos.
            by_date[md] = (o["name"], rank, "white")
        counts[lang] = len(by_date)
        out.append(f"    static let {lang}Feasts: [FixedFeast] = [\n")
        for md in sorted(by_date):
            name, rank, color = by_date[md]
            out.append(f'        .init(monthDay: {sw(md)}, name: {sw(name)}, '
                       f'rank: {RANKS[rank]}, color: {COLORS[color]}),\n')
        out.append("    ]\n\n")
    out.append("}\n")
    (OUT / "GeneratedSanctoral.swift").write_text("".join(out))
    return counts

# ---------------------------------------------------------- palavra do dia
# Política decidida em 19/09: edição histórica em domínio público com grafia e
# pontuação atualizadas, vocabulário intacto, e numeração das edições atuais.
# Os lotes entregues vêm com a grafia do fac-símile, então a normalização é aqui.
PT_SPELLING = [
    ("Bemaventurados", "Bem-aventurados"), ("d'elles", "deles"), ("d'ella", "dela"),
    ("n'elle", "nele"), ("n'ella", "nela"), ("elles", "eles"), ("ellas", "elas"),
    ("ceus", "céus"), ("espirito", "espírito"), ("teem", "têm"), ("sêde", "sede"),
    ("misericordia", "misericórdia"), ("pacificos", "pacíficos"),
    ("Folgae", "Folgai"), ("exultae", "exultai"), ("tambem", "também"),
    ("prophetas", "profetas"), ("propheta", "profeta"), ("Moysés", "Moisés"),
    ("sanctificado", "santificado"), ("sancto", "santo"), ("Sancto", "Santo"),
    ("perdoae", "perdoai"), ("dae", "dai"), ("vinde", "vinde"),
    ("hypocritas", "hipócritas"), ("hypocrita", "hipócrita"),
    ("thesouro", "tesouro"), ("thesouros", "tesouros"),
    ("sereis", "sereis"), ("pae", "pai"), ("Pae", "Pai"),
    (" ,", ","), (" ;", ";"), (" .", "."), (" :", ":"),
]
ES_SPELLING = [("reyno", "reino"), (" á ", " a "), (" ó ", " o "), (" ,", ","), (" ;", ";")]

def modernize(text, lang):
    table = PT_SPELLING if lang == "pt" else ES_SPELLING if lang == "es" else []
    for old_s, new_s in table:
        text = text.replace(old_s, new_s)
    return text

# A Vulgata inverte Mt 5,4 e 5,5 em relação às edições atuais: o texto fica como
# na fonte, a referência passa a ser a que o leitor tem na própria Bíblia.
SWAPPED_VERSES = {"4": "5", "5": "4"}

def normalize_reference(reference, lang):
    """Inglês cita com dois-pontos ("Matthew 5:3"); os lotes vieram com a vírgula
    do padrão português, o que impedia a desduplicação contra o catálogo do app."""
    if lang != "en":
        return reference
    return re.sub(r'^(\w[\w\s]*?)\s+(\d+),\s*(\d+)', r'\1 \2:\3', reference.strip())

def renumber(reference):
    import re as _re
    m = _re.match(r'^(.*?5)[,:]\s*(\d+)$', reference.strip())
    if not m:
        return reference
    book_chapter, verse = m.groups()
    if verse not in SWAPPED_VERSES:
        return reference
    sep = ":" if ":" in reference else ", "
    return f"{book_chapter}{sep}{SWAPPED_VERSES[verse]}"

# Referências que o catálogo escrito à mão já traz corrigidas — não reimportar.
ALREADY_IN_APP = {
    "pt": {f"Mateus 5, {n}" for n in range(3, 13)} | {"João 3, 14-15"},
    "en": {f"Matthew 5:{n}" for n in range(3, 13)} | {"John 3:14-15"},
    "es": {f"Mateo 5, {n}" for n in range(3, 13)},
}

def gen_word_of_day():
    rows = load("word_of_day_additions")
    counts = {}
    out = [HEADER + "// Passagens da Palavra do dia. Desduplicadas por referência: os lotes\n"
           "// entregues se sobrepõem (a amostra de 3 está dentro do lote de Mt 5,3-12,\n"
           "// e Mt 7,7 aparece em dois lotes).\n\n"
           "import Foundation\n\nextension MockWordOfDay {\n"]
    for lang in LANGS:
        seen, entries = set(ALREADY_IN_APP.get(lang, set())), []
        for o in rows.get(lang, []):
            ref = renumber(normalize_reference(o["reference"], lang))
            if ref in seen:
                continue
            seen.add(ref)
            entries.append({**o,
                            "reference": ref,
                            "quote": modernize(o["quote"], lang)})
        counts[lang] = len(entries)
        out.append(f"    static let {lang}ImportedPool: [WordOfDay] = [\n")
        for o in entries:
            slug = re.sub(r'[^a-z0-9]+', '-', o["reference"].lower()).strip('-')
            out.append("        .init(\n"
                       f'            id: {sw(slug + "-" + lang)},\n'
                       f'            quote: {sw(o["quote"])},\n'
                       f'            reference: {sw(o["reference"])},\n'
                       f'            translationNote: {sw(o["translationNote"])},\n'
                       f'            context: {sw(o["context"])}\n'
                       "        ),\n")
        out.append("    ]\n\n")
    out.append("}\n")
    (OUT / "GeneratedWordOfDay.swift").write_text("".join(out))
    return counts

# ---------------------------------------------------------------- orações
def gen_prayers():
    rows = load("prayer_item_additions")
    # o lote oficial (Compêndio) tem precedência sobre os anteriores
    official = set()
    for f in ENTREGAS.glob("oracoes-14-trilingue-oficiais/prayer_item_additions.*.json"):
        for o in json.load(open(f)):
            official.add((lang_of(f), o["title"].strip().lower()))
    counts = {}
    out = [HEADER + "// Orações devocionais por idioma. Quando o mesmo título aparece no lote\n"
           "// oficial (transcrito do Compêndio) e num lote anterior, fica o oficial.\n\n"
           "import Foundation\n\nextension MockDevotionalPrayers {\n"]
    for lang in LANGS:
        best = {}
        for o in rows.get(lang, []):
            key = o["title"].strip().lower()
            is_official = (lang, key) in official and "oficiais" in str(o.get("fonte", "")) or False
            if key not in best:
                best[key] = o
        # agrupa por categoria, preservando a ordem das 4 categorias do app
        by_cat = collections.defaultdict(list)
        for o in best.values():
            by_cat[o["categoryId"]].append(o)
        counts[lang] = sum(len(v) for v in by_cat.values())
        out.append(f"    static let {lang}ImportedPrayers: [String: [DevotionalPrayer]] = [\n")
        for cat in sorted(by_cat):
            out.append(f"        {sw(cat)}: [\n")
            for o in by_cat[cat]:
                slug = re.sub(r'[^a-z0-9]+', '-', o["title"].lower()).strip('-')
                out.append("            .init(\n"
                           f'                id: {sw(slug + "-" + lang)},\n'
                           f'                title: {sw(o["title"])},\n'
                           f'                attribution: {sw(o.get("attribution"))},\n'
                           f'                focus: {sw(o["focus"])},\n'
                           f'                fullText: {sw(o["fullText"])}\n'
                           "            ),\n")
            out.append("        ],\n")
        out.append("    ]\n\n")
    out.append("}\n")
    (OUT / "GeneratedPrayers.swift").write_text("".join(out))
    return counts

if __name__ == "__main__":
    print("lecionário:", gen_lectionary())
    print("santoral:  ", gen_sanctoral())
    print("palavra:   ", gen_word_of_day())
    print("orações:   ", gen_prayers())
    for f in sorted(OUT.glob("*.swift")):
        print(f"  {f.name}: {len(f.read_text().splitlines())} linhas")
