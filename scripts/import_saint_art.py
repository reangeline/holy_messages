#!/usr/bin/env python3
"""Importa a arte dos santos e as fichas correspondentes.

Imagens: ~/Projects/Missale/Missale-pesquisa/<Nome do Santo>/<id>-hero-1600x860.png
O id vem do próprio nome do arquivo, não da pasta.

Entra só o hero: o app usa 1600x860 na ficha e recorta o quadrado central para a
miniatura de 50 pt — e o lote foi composto com a figura no centro exatamente
para isso. Guardar as duas versões dobraria o bundle sem ganho.

PNG de 2 a 2,6 MB viraria ~120 MB no app. Convertido para JPEG de qualidade 80,
fica na casa dos 6 MB no total.
"""
import json, glob, pathlib, re, subprocess, collections

PESQUISA = pathlib.Path("/Users/reangeline/Projects/Missale/Missale-pesquisa")
APP = pathlib.Path("/Users/reangeline/Projects/Missale/holy_messages")
ASSETS = APP / "Sources/Assets.xcassets/Saints"
OUT = APP / "Sources/MockData/Generated"
PRAYERS = PESQUISA / "entregas/santos-oracoes"
LANGS = ("pt", "en", "es")

# O arquivo dessa pasta usa o nome completo; a ficha usa o id curto.
ID_ALIASES = {"sao-francisco-de-assis": "francisco-assis"}

# Parágrafos 2 e 3 de cada ficha são boilerplate sobre a própria ficha ("não
# substitui o Martirológio Romano", "a data e o grau devem ser revistos"). O
# primeiro é factual em todas as 105 — conferido antes de importar.
BOILERPLATE = re.compile(
    r'não pretende substituir|não substitui|no sustituye|does not replace|'
    r'precisam? ser conferid|devem ser revistos|é apresentad[ao] aqui|'
    r'aparece no calendário como referência|Esta ficha|This record|Este registro|'
    r'must be reviewed|deben ser revisad', re.I)

RANKS_PT = {"Memória", "Memória facultativa", "Festa", "Solenidade"}

# 23 dos 35 campos "identity" do lote inglês vieram meio traduzidos: só a
# primeira palavra virou inglês e o resto ficou em português ("Bishop de
# Hipona", "Priest e fundador da Ordem dos Pregadores", "Virgin, fundadora das
# Clarissas"). Uma frase híbrida é pior que a portuguesa inteira, e o app já
# declara que um idioma sem catálogo próprio mostra o português — então esses
# caem no valor português em vez de entrar misturados.
MIXED_PT_IN_EN = re.compile(
    r"\b(e|de|da|do|dos|das|m\u00e1rtir|sacerdote|bispo|virgem|religioso|presb\u00edtero|"
    r"adolescente|fundador\w*|padroeir\w*|carmelita|franciscan[ao]|jesu\u00edta|"
    r"canossiana|salvadorenho|mexicano|pregador\w*|Igreja|monaquismo|te\u00f3logo|"
    r"testemunha|Congrega\u00e7\u00e3o|Doutora?)\b", re.I)

def sw(s):
    if s is None:
        return "nil"
    s = (str(s).replace("\\", "\\\\").replace('"', '\\"')
         .replace("\n", "\\n").replace("\t", "\\t").replace("\r", ""))
    return f'"{s}"'


def stories_swift(stories):
    """Histórias e milagres da ficha: cada uma com título, texto e fonte.
    Sem fonte não entra — é a mesma regra do resto do acervo."""
    if not stories:
        return ""
    for s in stories:
        if not s.get("source"):
            raise ValueError(f"história sem fonte: {s.get('title')}")
    itens = ", ".join(
        f'.init(title: {sw(s["title"])}, body: {sw(s["body"])}, source: {sw(s["source"])})'
        for s in stories)
    return f",\n            stories: [{itens}]"


def find_art():
    """id do santo -> caminho do hero."""
    art = {}
    for png in PESQUISA.glob("*/*-hero-1600x860.png"):
        raw = png.name.split("-hero-")[0]
        art[ID_ALIASES.get(raw, raw)] = png
    # o primeiro lote (6 santos) já veio em JPEG no tamanho certo
    for jpg in (PESQUISA / "entregas/imagens-santos").glob("*/*-hero.jpg"):
        art.setdefault(jpg.parent.name, jpg)
    return art

# A faixa da ficha ocupa a largura da tela: 402 pt num iPhone 17, ou 1206 px em
# 3x. O lote vem em 1600 px, 33% mais largo do que o app desenha — redimensionar
# corta um terço do bundle sem perder um pixel visível.
HERO_WIDTH = 1206

def convert(src, dest):
    dest.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        ["sips", "-s", "format", "jpeg", "-s", "formatOptions", "80",
         "--resampleWidth", str(HERO_WIDTH), str(src), "--out", str(dest)],
        check=True, capture_output=True)
    return dest.stat().st_size

def write_imageset(saint_id, src):
    folder = ASSETS / f"{saint_id}.imageset"
    size = convert(src, folder / f"{saint_id}.jpg")
    (folder / "Contents.json").write_text(json.dumps({
        "images": [{"filename": f"{saint_id}.jpg", "idiom": "universal"}],
        "info": {"author": "xcode", "version": 1},
    }, indent=2) + "\n")
    return size

def load_fichas(lang):
    recs = {}
    for f in sorted(glob.glob(str(PESQUISA / f"entregas/santos-*/saint_additions.{lang}.json"))):
        for o in json.load(open(f)):
            # Um lote revisado declara `richDetail`; ele substitui a sinopse inicial.
            # Lotes históricos continuam usando a primeira ocorrência estável.
            if o.get("richDetail") or o["id"] not in recs:
                recs[o["id"]] = o
    return recs

def load_prayers(lang):
    """Orações publicadas por idioma, separadas das fichas biográficas.

    O lote inclui a URL da edição católica usada. Manter a oração fora dos lotes
    de biografia permite revisar ou substituir a fonte sem duplicar 35 fichas.
    """
    path = PRAYERS / f"saint_prayers.{lang}.json"
    prayers = {}
    for o in json.load(open(path)):
        saint_id = o["id"]
        if saint_id in prayers:
            raise ValueError(f"oração duplicada em {path}: {saint_id}")
        if not o.get("prayer") or not o.get("sourceURL", "").startswith("https://"):
            raise ValueError(f"oração sem texto ou fonte em {path}: {saint_id}")
        prayers[saint_id] = o
    return prayers

def main():
    art = find_art()
    ASSETS.mkdir(parents=True, exist_ok=True)
    (ASSETS / "Contents.json").write_text(
        json.dumps({"info": {"author": "xcode", "version": 1},
                    "properties": {"provides-namespace": False}}, indent=2) + "\n")

    total = 0
    for saint_id, src in sorted(art.items()):
        total += write_imageset(saint_id, src)
    print(f"arte: {len(art)} santos, {total/1e6:.1f} MB em JPEG")

    out = ['''// GERADO — não editar à mão.
// Origem: ~/Projects/Missale/Missale-pesquisa, importado por scripts/import_saint_art.py.
//
// Fichas de santo com a arte em domínio público do lote de pesquisa. Lotes ricos
// preservam todos os parágrafos factuais, sua relevância atual e oração publicada.
// Boilerplate editorial dos lotes antigos continua sendo removido.

import Foundation

extension MockSaints {
''']
    counts = collections.Counter()
    pt_fichas = load_fichas("pt")
    for lang in LANGS:
        fichas = load_fichas(lang)
        prayers = load_prayers(lang)
        out.append(f"    static let {lang}ImportedSaints: [Saint] = [\n")
        entries = []
        for saint_id in sorted(fichas):
            o = fichas[saint_id]
            paras = [p for p in o.get("bioParagraphs", []) if not BOILERPLATE.search(p)]
            if o.get("richDetail"):
                bio = paras or [o.get("identity", "")]
                why = o.get("whyItMattersToday", "")
                prayer = prayers.get(saint_id, {}).get("prayer", "")
                if not prayer:
                    raise ValueError(f"ficha rica sem oração {lang}: {saint_id}")
            else:
                # Os lotes antigos copiavam a sinopse no campo de relevância e
                # deixavam a oração vazia. Isso não vira conteúdo rico por acaso.
                bio = paras[:1] or [o.get("identity", "")]
                why = ""
                prayer = ""
            rank = o.get("rank") if o.get("rank") in RANKS_PT else "Memória"
            identity = o.get("identity", "")
            if lang == "en" and MIXED_PT_IN_EN.search(identity):
                identity = pt_fichas.get(saint_id, {}).get("identity", identity)
                counts["en-identity-caiu-no-pt"] += 1
            artwork = sw(saint_id) if saint_id in art else "nil"
            out.append("        .init(\n"
                       f'            id: {sw(saint_id)},\n'
                       f'            name: {sw(o["name"])},\n'
                       f'            lifespan: {sw(o.get("lifespan", ""))},\n'
                       f'            role: {sw(identity)},\n'
                       f'            rank: {sw(rank)},\n'
                       f'            calendarNote: {sw(o.get("calendarNote", ""))},\n'
                       f'            bioParagraphs: [{", ".join(sw(p) for p in bio)}],\n'
                       f'            whyItMattersToday: {sw(why)},\n'
                       f'            prayer: {sw(prayer)},\n'
                       f'            artworkName: {artwork}'
                       + stories_swift(o.get("stories", []))
                       + "\n        ),\n")
            if o.get("dateKey"):
                entries.append((o["dateKey"], saint_id))
            counts[lang] += 1
            if prayer:
                counts[lang + "-orações"] += 1
        out.append("    ]\n\n")

        # calendário: uma celebração por data, a primeira em ordem alfabética de id
        by_date = {}
        for date_key, saint_id in sorted(entries):
            by_date.setdefault(date_key, saint_id)
        out.append(f"    static let {lang}ImportedCalendar: [SaintOfDay] = [\n")
        for date_key in sorted(by_date):
            sid = by_date[date_key]
            out.append(f'        SaintOfDay(dateKey: {sw(date_key)}, region: .general, '
                       f'saint: {lang}ImportedSaints.first {{ $0.id == {sw(sid)} }}!),\n')
        out.append("    ]\n\n")
        counts[lang + "-datas"] = len(by_date)

    out.append("}\n")
    (OUT / "GeneratedSaints.swift").write_text("".join(out))
    print("fichas:", dict(counts))
    print("sem arte:", sorted(set(load_fichas("pt")) - set(art)))

if __name__ == "__main__":
    main()
