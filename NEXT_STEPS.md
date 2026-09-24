# Missale — o que falta, o que está pendente de decisão, por onde continuar

Escrito em 22 de setembro de 2026, no commit `905b025`. Todos os números abaixo
foram medidos no código, não escritos de memória — e a forma de medir está no
fim, para você poder refazer a conta depois.

Estado: **43 testes unitários e 44 de UI, 0 falhas.** `xcodegen generate` e
build limpos.

---

## 1. O mínimo para publicar

Quatro coisas. Duas são suas, duas são minhas.

### 1.1 A captura de revisão da assinatura — sua, 5 minutos

A App Store Connect exige, em **Informações de revisão** de cada assinatura,
uma captura da tela onde a compra é oferecida.

O passo a passo está em `capturas-appstore/LEIA.md`. Resumo: em *Edit Scheme ›
Run › Arguments* adicione `-openScreen paywall` e `-hasCompletedOnboarding 1`,
⌘R, ⌘S. A tela sai com **Mensal R$ 19,90/mês** e **Anual R$ 129,90/ano**.

Não dá para automatizar: a configuração local do StoreKit se liga à ação Run, e
`SKTestSession` configura o processo de teste, não o do app sob teste
(verificado).

### 1.2 Hospedar a política de privacidade — sua

A App Store Connect exige uma **URL** de política de privacidade para todo app.
O texto está pronto em `Legal/`, nos três idiomas, e também embarcado no app.
Falta publicar numa URL e colar no App Store Connect.

### 1.3 Orientação de crise — decidida

Por decisão sua (feedback do 2.0 (3)), o cartão de crise deixou de citar
números (CVV 188, 988, Línea de la Vida) e passou a um texto genérico: procurar
os serviços públicos de apoio emocional e de saúde, e o serviço de emergência
local em perigo imediato. Está em `Sources/Models/CrisisLine.swift`, nas duas
telas de apoio. Nada mais a conferir aqui.

### 1.4 Mecânico — minha e sua

- Screenshots da listagem, descrição, classificação de idade, questionário de
  privacidade (fácil: tudo local, nada sai do aparelho).
- Assinatura e provisionamento.
- **Um teste em aparelho real.** A suíte roda só no Simulador, que não tem App
  Store: a compra, a restauração e o estado da assinatura nunca foram
  exercitados de verdade. Isto é o maior risco não testado do projeto.

---

## 2. Decisões pendentes

### 2.1 Teste gratuito de 7 dias — feito

O app lê do produto (`introductoryOffer`) e só mostra o teste a quem a Apple
diz que tem direito (`isEligibleForIntroOffer`).

- Em 24/09 as ofertas de 2 semanas (desde 22/09) foram apagadas e trocadas por
  **Grátis na primeira semana**, na Mensal e na Anual, nos mesmos 175 países,
  sem data final. Quem já estava no teste de 2 semanas continua nele.
- A configuração local (`Tests/Support/Missale.storekit`) também está com 1
  semana.
- Uma conta que já assinou não tem mais direito ao teste: é o caso da conta
  usada no TestFlight. Para ver o botão de 7 dias, teste com uma conta Sandbox
  nova.

### 2.2 O que fazer com os 111 santos e as 111 festas que faltam — pendente

Ver §3.1 e §3.2. A decisão é de ritmo: bloquear o lançamento por isso, ou
publicar com o acervo atual e crescer por atualização. **Recomendo publicar:** o
app degrada com honestidade, diz "ainda não cadastrado" onde falta, e os termos
declaram isso em §7.

### 2.3 Apagar e exportar dados — adiado por você, e precisa voltar

Você pediu para tirar por enquanto, e eu tirei — junto com o código que só
existia para os botões. A política de privacidade e os termos foram reescritos
para dizer a verdade: hoje a forma de apagar é apagar o app.

Isso é defensável para um app que não coleta nada, mas **o botão precisa
voltar** antes de o acervo pessoal crescer. Quando voltar, a limpeza vai em
`LocalData`, sobre a lista de chaves que já está lá.

### 2.4 Bíblia em espanhol (Torres Amat) incompleta — pendente

Situação em 23 de setembro de 2026. As três Bíblias estão no app; inglês
(Douay-Rheims) e português (Matos Soares, direitos confirmados por você) podem
ir para a loja. A Torres Amat não, porque o teste `testBiblesReadyForRelease`
barra `missingVerses > 0`:

| | Versículos |
|---|---|
| Faltando | 463 (199 nos deuterocanônicos: Eclesiástico, Macabeus, Baruc…) |
| Com resto de OCR | 630 (1,8%) |
| Da Reina-Valera 1909, marcados com † no app | 1.488 (4,2%) |

O texto vem do Wikisource onde há transcrição, e no resto do OCR de quatro
edições (1823, 1836, 1882, 1894) cotejadas entre si. O que sobrou são
versículos soltos que o OCR de todas as edições perdeu; a busca automática
chegou ao limite.

**Decidir entre:**

- **Continuar a procurar** — transcrever à mão os 463 contra o fac-símile. A
  lista pronta, com o texto da Douay-Rheims de cada um para achar a passagem,
  está em `../missale-biblias-revisao/restantes-torres-amat.csv`. Algumas
  horas de trabalho. O teste libera sozinho quando `missingVerses` chegar a 0.
- **Publicar com aviso** — afrouxar o teste só para a Torres Amat e mostrar no
  app que a edição tem versículos faltando. Decisão editorial.

Os scripts para refazer tudo (conversão, preenchimento com a RV, Wikisource,
OCR das edições) estão na mesma pasta `../missale-biblias-revisao/`.

---

### 2.5 Feedbacks do TestFlight ainda abertos

Registrados aqui para poderem ser apagados do App Store Connect. Os do 2.0 (1)
que o commit `a75d293` tratou e os do 2.0 (3) tratados depois não entram.

Do 2.0 (1):
- Fazer o "Em defesa da fé católica".
- Devocional para mandar uma mensagem a alguém conhecido.
- Áudios gravados com as orações (hoje a voz é a síntese do aparelho).
- Avaliar os termos do suporte.
- Aparições: falta a imagem de Knock (as três fichas novas entraram, §3.3).

Do 2.0 (2), sem a tela no texto do feedback — conferir pela captura antes de
apagar:
- "Avaliar se a mensagem chega assim mesmo" (o aviso da leitura agora é
  agendado de verdade, nos horários escolhidos no onboarding).
- "Está genérico e mal formatado".
- "Deixar o texto maior".
- "Tá com muito texto".
- "Essa primeira parte está confusa" (o começo do onboarding foi refeito).

Do 2.0 (3), o que depende de conteúdo:
- Santo do dia: 53 dias do ano têm santo registrado. Nos outros, o app agora
  mostra "Um santo para conhecer", um diferente a cada dia; o completo é o
  trabalho de §3.2.

### 2.6 Próximas features — pedidas em 24/09

- **Uma história ou curiosidade.** Uma mensagem curta, que muda a cada dia: um
  episódio da vida de um santo, a origem de um costume, uma curiosidade da
  liturgia. Precisa de acervo com fonte, como os santos. O modelo `SaintStory`
  (título, texto, fonte) já existe e pode servir de base.
- **Comentários em lugares a definir.** É a primeira feature que exige
  servidor: hoje o app não faz nenhuma requisição de rede (ver `LocalData` e a
  política). Antes de escrever código: decidir onde se comenta, se há conta ou
  login, a moderação (denúncia, filtro, quem revisa), e reescrever a política
  de privacidade e o questionário da App Store, que hoje dizem "nada sai do
  aparelho". A App Store também exige denúncia e bloqueio em conteúdo gerado
  por usuários (diretriz 1.2).
- **Bíblia: marcar, buscar e continuar — feito em 24/09.** Tocar num
  versículo marca (lista em "Versículos marcados", deslizar remove); busca
  por referência ("Jo 3,16", "1Cor 13", "Sl 22") ou por palavras, sem acento
  nem maiúsculas; e o marcador "onde parei" na barra do capítulo, com o
  cartão "Continuar de onde parei" no início da Bíblia. Tudo local, em
  `bible_highlights` e `bible_bookmarks`.

## 3. O que falta de conteúdo

Medido em 22/09/2026.

| coleção | tem | alvo | falta |
|---|---:|---:|---|
| Palavra do dia | 90 / 90 / 90 | 90 | **0** |
| Exame do dia | 240 / 240 / 240 | 240 | **0** |
| Formação | 36 / 36 / 36 | 36 | **0** |
| Lecionário (domingos) | 156 / 156 / 156 | 156 | **0** |
| Orações devocionais | 28 pt / 35 en / 33 es | 28 | **0** |
| Aparições marianas | 3 / 3 / 3 | — | 3 fichas (§3.3) |
| **Santos detalhados** | 37 por idioma | 100 | **63 × 3 = 189 registros** |
| **Festas de data fixa** | 69 por idioma | 180 | **111 × 3 = 333 registros** |

Nenhum catálogo do app está sem espanhol: **27 de 27 são trilíngues.**

Fora `Text("MISSALE")`, que é a marca, nenhuma tela tem texto fora do catálogo.

### 3.1 Festas de data fixa — o mais fácil dos dois grandes

A fonte é **um documento só**: o Calendário Romano Geral publica as celebrações
de data fixa com grau e cor, e é de onde as 69 saíram. A distribuição mostra
onde falta: janeiro 11, maio 11, mas **setembro 2, novembro 2, dezembro 2**.

Não é pesquisa de 333 fontes — é transcrever uma tabela publicada e usar as
edições oficiais de cada idioma para os nomes (Missal brasileiro, USCCB, CEE).
Estimativa: lotes de ~30 datas, 4 ou 5 sessões.

### 3.2 Santos detalhados — o trabalho mais longo do projeto

Cada ficha precisa de datas, função, grau, nota de calendário, parágrafos
biográficos factuais, "por que importa hoje" e a invocação da Ladainha — com
fonte por registro. As 37 primeiras vieram de sete lotes de pesquisa em
`~/Documents`; o segundo lote (24/09, `scripts/lotes/santos-segundo-lote`,
importado por `scripts/import_saints_batch.py`) trouxe mais 8 para o fim de
setembro e outubro: Cosme e Damião, Arcanjos, Jerônimo, Faustina, Bruno,
João XXIII, Inácio de Antioquia e Lucas. O terceiro lote (`santos-terceiro-lote`)
trouxe mais 10 para o fim de outubro e novembro: Paulo da Cruz, Antônio Maria
Claret, Simão e Judas, Todos os Santos, Carlos Borromeu, Leão Magno, Alberto
Magno, Isabel da Hungria, Cecília e André. Nenhum dos 18 novos tem arte ainda.

Os lotes seguintes podem seguir o mesmo caminho, um arquivo gerado por lote.

Dá para fazer em lotes de 5 fichas, com fonte verificada (vaticano,
martirológio, santuários). Estimativa: 12 a 15 sessões. **Sugiro tratar como
trabalho de fundo**, não como bloqueio.

### 3.3 Aparições — feito, falta a arte de Knock

Aparecida, Lourdes e Rue du Bac (Nossa Senhora das Graças) ganharam ficha com
fonte dos santuários, nos três idiomas, e agora usam a arte que estava parada
no bundle. Ficam no segundo lote, `scripts/lotes/aparicoes-segundo-lote`, com
arquivo gerado próprio, para reimportar o primeiro lote (em `~/Documents`) não
apagar estas. Knock continua com ficha e sem imagem: falta a arte.

### 3.4 Revisão editorial — 762 registros

O acervo de pesquisa marca `verificar: true` em 468 registros de lecionário,
105 de santos e 189 de palavra do dia. É status de pesquisa, não erro visível.
Eu posso conferir por amostragem e te dar a taxa de erro; **aprovar para
publicação é seu.**

---

## 4. Como o dinheiro está montado

Decisão desta versão: **só a palavra do dia é gratuita.**

| grátis | pede assinatura |
|---|---|
| Palavra do dia | Calendário |
| Check-in de humor → alívio → tela pastoral → linha de crise | Formação |
| Ajustes, idioma, os dois documentos legais | Orações e Terço |
| | Santo do dia, Exame, Completas |

**As duas exceções não são comerciais, e estão travadas por teste.**
`SubscriptionGateTests` lê as fontes e falha se um portão aparecer em qualquer
arquivo do caminho do apoio, ou nas telas de Ajustes e legais.

Produtos: `mensal` e `anual` (Product IDs, não os Apple IDs 6814659756 e
6814660801, que o `Product.products(for:)` ignora em silêncio). Preços R$ 19,90
e R$ 129,90 no Brasil, 175 regiões na planilha.

Nenhum preço, período ou prazo de teste está escrito no app — um teste proíbe,
**inclusive os valores certos**, porque são 175 regiões e nenhuma cabe no
código. Tudo vem do StoreKit.

---

## 5. O que este app não faz, e é bom lembrar

Estas são propriedades que os testes defendem. Se alguma cair, a política de
privacidade e os termos passam a mentir.

- **Nenhuma requisição de rede.** Zero `URLSession` no app.
  `LocalDataTests.testTheAppMakesNoNetworkRequests` falha se aparecer uma.
- **Nenhuma conta, nenhum login.** Os botões Apple/Google/Facebook do desenho
  original nunca foram construídos.
- **Nenhum analytics, rastreador ou anúncio.**
- **O direito de assinatura nunca é gravado no aparelho** — lido de
  `Transaction.currentEntitlements` a cada verificação.
- **Toda chave persistida está listada em `LocalData`**, e um teste falha se
  aparecer uma fora da lista. É de lá que a política é escrita.

---

## 6. Ordem que eu sugiro

1. **A captura de revisão** (§1.1) e **hospedar a política** (§1.2) — suas.
2. **Teste em aparelho real** da compra e da restauração (§1.4) — o maior risco
   não testado.
3. **As festas de data fixa** (§3.1) — fonte única, ganho grande.
4. **Os santos** (§3.2) — trabalho de fundo.
5. **Devolver apagar e exportar** (§2.3) antes que o acervo pessoal cresça.

---

## 7. Como refazer as contas

```sh
# Suíte inteira
xcodebuild -project Missale.xcodeproj -scheme Missale \
  -destination 'platform=iOS Simulator,name=iPhone 17' test

# Contagem do acervo por idioma (fatia por declaração, em ordem de arquivo)
python3 - <<'EOF'
import re, pathlib
segs = {}
for f in ("Sources/MockData/MockWordOfDay.swift",
          "Sources/MockData/Generated/GeneratedWordOfDay.swift"):
    t = pathlib.Path(f).read_text()
    marcas = [(m.start(), m.group(1)) for m in
              re.finditer(r"static let (\w+)\s*:\s*\[WordOfDay\]", t)]
    marcas.append((len(t), "FIM"))
    for k, (i, n) in enumerate(marcas[:-1]):
        segs[n] = t[i:marcas[k+1][0]]
for lang in ("pt", "en", "es"):
    refs = re.findall(r'reference:\s*"([^"]+)"', segs[f"{lang}Pool"]) + \
           re.findall(r'reference:\s*"([^"]+)"', segs[f"{lang}ImportedPool"])
    print(lang, len(refs), "registros,", len(set(refs)), "distintos")
EOF
```

Um aviso sobre medir: um regex que procura a próxima declaração com um padrão
diferente do que achou a anterior **vaza entre blocos** e conta o arquivo
inteiro. Errei isso duas vezes nesta sessão e reportei 91 onde eram 90. Fatie
por posições em ordem de arquivo, numa passagem, como acima.

---

## 8. Regras do projeto que continuam valendo

- **Não usar tradução livre para conteúdo católico nem bíblico.** Cada idioma
  usa uma fonte pública ou oficialmente publicada naquele idioma. O texto
  bíblico é copiado do inventário, nunca traduzido a partir de outro idioma.
- **Nunca editar `Sources/MockData/Generated/`** à mão: ajustar o JSON de
  entrega em `~/Documents/Missale-pesquisa/entregas` e rodar o gerador
  (`scripts/import_acervo.py`, `scripts/import_mood_relief.py`,
  `scripts/build_exam_relief.py`).
- **Textos de interface** vão no `.xcstrings` via `L.string(...)` ou
  `Text(_:tableName:)`; **conteúdo do acervo** vai em
  `LocalizedCatalog(pt:en:es:)`.
- Depois de criar ou remover arquivos, rodar `xcodegen generate`. O target do
  widget tem lista de fontes própria e explícita.
- Mensagens de commit em português, terminando com as linhas de co-autoria e de
  sessão.
- **Não usar `git add -A`** neste repositório: há trabalho paralelo na árvore, e
  eu já commitei arquivos que não eram meus uma vez.
