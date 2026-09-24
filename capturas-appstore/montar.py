"""Monta as capturas da App Store: legenda em Cormorant sobre o pergaminho do
app, com a tela do aparelho abaixo. 1320x2868 é o tamanho de 6,9" exigido."""
from PIL import Image, ImageDraw, ImageFilter, ImageFont
import pathlib, sys

RAIZ = pathlib.Path("/Users/reangeline/Projects/holy_messages")
FONTES = RAIZ / "Sources/Fonts"
SHOT = pathlib.Path(sys.argv[1])
SAIDA = SHOT / "appstore"
SAIDA.mkdir(parents=True, exist_ok=True)

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
    for linha in quebrar(subtitulo, fSub, W - margem * 2 - 60, draw):
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
    base.save(SAIDA / arquivo, quality=95)
    print("  ", arquivo)


LEGENDAS = [
    ("humor.png", "Comece por", "como você está", "Um toque. Fica no aparelho, e pode ficar em branco.", "1-sentir.png", 2190),
    ("escrever.png", "Escreva antes de", "qualquer resposta", "O que vem depois é para o que você escreveu, não um texto pronto.", "2-escrever.png", 2868),
    ("resposta.png", "Um salmo, um santo,", "e um passo", "Escolhidos para o que você acabou de registrar.", "3-resposta.png", 1960),
    ("hoje.png", "O dia inteiro,", "numa tela só", "A palavra, o santo, a trilha e o terço de hoje.", "4-hoje.png", 2868),
    ("exame.png", "À noite, reveja o dia", "diante de Deus", "O Exame em quatro toques, e as Completas para dormir.", "5-exame.png", 2868),
]

for origem, titulo, destaque, sub, arquivo, corte in LEGENDAS:
    montar(SHOT / "fonte" / origem, titulo, destaque, sub, arquivo, corte)
print("pronto:", SAIDA)
