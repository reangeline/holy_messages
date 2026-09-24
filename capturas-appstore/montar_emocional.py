"""Monta o carrossel emocional da App Store, nos três idiomas: legenda em Cormorant sobre o pergaminho do
app, com a tela do aparelho abaixo. 1320x2868 é o tamanho de 6,9" exigido."""
from PIL import Image, ImageDraw, ImageFilter, ImageFont
import pathlib, sys

RAIZ = pathlib.Path("/Users/reangeline/Projects/holy_messages")
FONTES = RAIZ / "Sources/Fonts"
SHOT = pathlib.Path(sys.argv[1])  # pasta com as capturas cruas: <idioma>-<tela>.png
SAIDA = pathlib.Path(__file__).parent / "listagem-emocional"

W, H = 1320, 2868
PERGAMINHO = (248, 243, 234)
PERGAMINHO_FUNDO = (235, 230, 220)
TINTA = (34, 27, 28)
VINHO = (122, 31, 43)
OURO = (141, 106, 34)


def fonte(nome, tam):
    return ImageFont.truetype(str(FONTES / nome), tam)


def fundo():
    """O mesmo pergaminho do app, com os dois halos do LiturgicalColor."""
    base = Image.new("RGB", (W, H), PERGAMINHO)
    halo = Image.new("RGB", (W, H), PERGAMINHO)
    d = ImageDraw.Draw(halo)
    d.ellipse([W * 0.35, -H * 0.06, W * 1.30, H * 0.30], fill=(226, 205, 205))
    d.ellipse([-W * 0.35, H * 0.06, W * 0.55, H * 0.42], fill=(238, 228, 205))
    d.ellipse([W * 0.10, H * 0.80, W * 1.15, H * 1.12], fill=(233, 222, 214))
    halo = halo.filter(ImageFilter.GaussianBlur(190))
    base = Image.blend(base, halo, 0.85)
    # Uma base um pouco mais funda embaixo, para a imagem não flutuar.
    fundoGrad = Image.new("L", (1, H))
    for y in range(H):
        fundoGrad.putpixel((0, y), int(28 * (y / H) ** 2))
    mask = fundoGrad.resize((W, H))
    base.paste(Image.new("RGB", (W, H), PERGAMINHO_FUNDO), (0, 0), mask)
    return base


def quebrar(texto, f, largura, draw):
    linhas, atual = [], ""
    for palavra in texto.split():
        teste = (atual + " " + palavra).strip()
        if draw.textlength(teste, font=f) <= largura:
            atual = teste
        else:
            if atual:
                linhas.append(atual)
            atual = palavra
    if atual:
        linhas.append(atual)
    return linhas


def equilibrar(texto, f, largura, draw):
    """Quebra no mesmo número de linhas, mas na menor largura que o mantém —
    assim a última linha não fica com uma palavra sozinha."""
    linhas = quebrar(texto, f, largura, draw)
    while largura > 200 and len(quebrar(texto, f, largura - 10, draw)) == len(linhas):
        largura -= 10
    return quebrar(texto, f, largura, draw)


def cantos(im, raio):
    mask = Image.new("L", im.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, im.width - 1, im.height - 1],
                                           radius=raio, fill=255)
    saida = Image.new("RGBA", im.size)
    saida.paste(im, (0, 0), mask)
    return saida


def montar(origem, titulo, destaque, subtitulo, arquivo, corte=None):
    tela_origem_w = 1320
    base = fundo()
    draw = ImageDraw.Draw(base)

    # EB Garamond, e não o Cormorant do título no app: sem o motor de shaping
    # (libraqm não está disponível aqui) o PIL desloca os acentos compostos do
    # Cormorant — "você está" saía com o circunflexo solto e à direita. O iOS
    # usa CoreText e não tem esse problema, então o app segue com o Cormorant.
    fTitulo = fonte("EBGaramond-SemiBold.ttf", 94)
    fSub = fonte("EBGaramond-Regular.ttf", 46)

    margem = 96
    y = 150

    # O título, com a última parte em vinho — o mesmo realce do paywall.
    for i, linha in enumerate(quebrar(titulo, fTitulo, W - margem * 2, draw)):
        draw.text((W / 2, y), linha, font=fTitulo, fill=TINTA, anchor="ma")
        y += 112
    if destaque:
        for linha in quebrar(destaque, fTitulo, W - margem * 2, draw):
            draw.text((W / 2, y), linha, font=fTitulo, fill=VINHO, anchor="ma")
            y += 112

    y += 18
    for linha in equilibrar(subtitulo, fSub, W - margem * 2 - 60, draw):
        draw.text((W / 2, y), linha, font=fSub, fill=(90, 80, 78), anchor="ma")
        y += 60

    # A tela entra num lugar fixo, sempre abaixo da legenda, e sangra 30px
    # pela base — "continua abaixo". O recorte é o mesmo para as cinco, senão
    # cada aparelho ficaria de um tamanho e o conjunto perderia o alinhamento.
    TOPO, SANGRIA = 770, 30
    largura = int(W * 0.855)
    altura = H + SANGRIA - TOPO
    corte = round(altura * tela_origem_w / largura)

    tela = Image.open(origem).convert("RGB")
    tela = tela.crop((0, 0, tela.width, min(corte, tela.height)))
    tela = cantos(tela.resize((largura, altura), Image.LANCZOS), 62)

    x = (W - largura) // 2
    topo = TOPO

    sombra = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(sombra).rounded_rectangle(
        [x + 10, topo + 22, x + largura - 10, topo + altura], radius=58,
        fill=(70, 45, 40, 105))
    base.paste(Image.alpha_composite(
        base.convert("RGBA"), sombra.filter(ImageFilter.GaussianBlur(38))
    ).convert("RGB"), (0, 0))

    base.paste(tela, (x, topo), tela)
    arquivo.parent.mkdir(parents=True, exist_ok=True)
    base.save(arquivo, quality=95)
    print("  ", arquivo.relative_to(SAIDA))


# Narrativa: chegar como está → escrever → receber uma palavra → voltar todo
# dia → ver a constância → entregar o dia à noite.
TELAS = ["humor", "escrever", "resposta", "hoje", "jornada", "exame"]

LEGENDAS = {
    "pt": [
        ("Chegue do jeito", "que você está", "Um lugar para parar, respirar e contar a Deus como vai o coração."),
        ("Coloque em palavras", "o que pesa", "Só você vê. Fica guardado no seu aparelho."),
        ("Uma palavra para", "o que você sente", "Um salmo, um santo que passou por isso e um passo pequeno."),
        ("Alguns minutos com Deus,", "todos os dias", "A Palavra, o santo, o terço e a sua trilha, numa tela só."),
        ("Veja o caminho", "que você está fazendo", "Sem metas nem cobranças: só a fidelidade de cada dia."),
        ("À noite, entregue", "o dia a Deus", "O Exame em quatro passos, e as Completas para dormir em paz."),
    ],
    "en": [
        ("Come just", "as you are", "A place to pause, breathe, and tell God how your heart is."),
        ("Put into words", "what weighs on you", "Only you see it. It stays on your phone."),
        ("A word for", "what you feel", "A psalm, a saint who went through it, and one small step."),
        ("A few minutes with God,", "every day", "The Word, the saint, the Rosary and your path, on one screen."),
        ("See the path", "you are walking", "No goals, no pressure: just the faithfulness of each day."),
        ("At night, give", "the day to God", "The Examen in four steps, and Compline to sleep in peace."),
    ],
    "es": [
        ("Llega tal", "como estás", "Un lugar para detenerte, respirar y contarle a Dios cómo está tu corazón."),
        ("Pon en palabras", "lo que te pesa", "Solo tú lo ves. Queda guardado en tu teléfono."),
        ("Una palabra para", "lo que sientes", "Un salmo, un santo que pasó por lo mismo y un pequeño paso."),
        ("Unos minutos con Dios,", "cada día", "La Palabra, el santo, el Rosario y tu camino, en una sola pantalla."),
        ("Mira el camino", "que vas haciendo", "Sin metas ni presiones: solo la fidelidad de cada día."),
        ("De noche, entrega", "el día a Dios", "El Examen en cuatro pasos, y las Completas para dormir en paz."),
    ],
}

for idioma, legendas in LEGENDAS.items():
    for n, (tela, (titulo, destaque, sub)) in enumerate(zip(TELAS, legendas), 1):
        montar(SHOT / f"{idioma}-{tela}.png", titulo, destaque, sub,
               SAIDA / idioma / f"{n}-{tela}.png")
print("pronto:", SAIDA)
