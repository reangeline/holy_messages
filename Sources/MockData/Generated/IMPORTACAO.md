# Importação do acervo de pesquisa — 19/09/2026

Origem: `~/Documents/Missale-pesquisa/entregas`. Gerado por
`scripts/import_acervo.py`. Reimportar em vez de editar os `Generated*.swift`
à mão.

## Entrou no app

| Coleção | Registros | Onde |
|---|---:|---|
| Lecionário dominical | 156 × 3 idiomas | `MockLectionary.catalog` — referências + resumo, por chave `tempo-semana-ciclo` |
| Santoral de data fixa | 69 × 3 idiomas | `LiturgicalSanctoral.catalog` — 40 festas do lote + 35 santos com data, mais as 12 escritas à mão que o lote não cobre |
| Palavra do dia | 49 × 3 idiomas | `MockWordOfDay.catalog` — soma aos 11 pt / 11 en / 10 es já escritos |
| Orações devocionais | 20 pt · 35 en · 33 es | `MockDevotionalPrayers.catalog` — lote oficial do Compêndio tem precedência sobre os anteriores |
| Arte de santo | 1 | `notburga` no catálogo de assets, via `Saint.artworkName` |

Normalizações aplicadas na importação, conforme as decisões de 19/09:

- **Grafia** modernizada em pt e es (vocabulário intacto): `Bemaventurados` →
  `Bem-aventurados`, `d'elles` → `deles`, `ceus` → `céus`, `prophetas` →
  `profetas`, `Folgae` → `Folgai`, `reyno` → `reino`, `á`/`ó` → `a`/`o`.
- **Numeração** de Mt 5,4 e 5,5 trocada para a das edições atuais (a Vulgata
  inverte as duas).
- **Referências inglesas** normalizadas para dois-pontos (`Matthew 5:3`), que é
  a forma usada no catálogo do app — sem isso a desduplicação não pegava.
- **Desduplicação** por referência, inclusive contra o que já estava escrito à
  mão: os lotes se sobrepõem entre si (a amostra de 3 está dentro do lote de
  Mt 5,3–12, e Mt 7,7 vem em dois lotes) e com o catálogo do app.

## Não entrou, e por quê

**Exame do dia — 480 variações (160 × 3).** Em todos os 16 estados, as 10
variações compartilham **um único** `psalmWhy` e **um único** `stepBody`. São 16
respostas reais vestidas de 160: quem registra "ansioso" dez dias seguidos recebe
a mesma explicação e o mesmo passo concreto todas as vezes — exatamente o que a
meta de 15 por estado existia para evitar. Além disso, as 160 apontam para só 5
santos, e esses 5 ids (`therese`, `john-of-the-cross`, `teresa-calcutta`,
`cure-ars`, `perboyre`) não existem em nenhum dos lotes de santos entregues.
Há também pareamento errado: o Salmo 51 (Miserere, sobre o pecado) aparece para
"ansioso" com a explicação "este salmo desloca a preocupação".

**Formação — 108 partes (36 × 3).** §1, §2 e §4 são próprios de cada parte, mas o
**§3 é literalmente idêntico nas 36** ("Na prática, vale observar três coisas: o
que acontece exteriormente, qual oração acompanha o gesto e qual resposta é
pedida à assembleia"). Quem faz as 7 partes dos sacramentos lê o mesmo terceiro
parágrafo sete vezes. O §3 é justamente onde a casa põe o detalhe histórico
concreto — é o parágrafo que dá voz ao app.

**Fichas completas de santo — os campos ricos dos 105 registros.** As 25 fichas
do primeiro lote têm meta-comentário no lugar de biografia ("A ficha não pretende
substituir o Martirológio Romano", "o grau e a data precisam ser conferidos na
edição usada pelo app") em 25 de 25, `whyItMattersToday` é cópia da primeira
frase do `bio` em 25 de 25, e `prayer` vem vazio. Os campos leves (nome, datas,
identidade, data da memória, grau) **entraram** pelo santoral; os campos da tela
de detalhe não.

**Aparições marianas — 9 registros.** Coleção nova, que não estava no briefing e
não tem modelo nem tela no app. Aguarda decisão de onde deve aparecer.

**Texto integral das leituras** (`firstReadingText`, `psalmText`, `gospelText`,
`secondReadingText`, 156 × 3). O app mostra referência e resumo; o texto fica
fora por licença, como a própria tela declara. Os textos seguem no acervo de
pesquisa.

## Pendente de conferência na origem

O próprio lote marca `verificar: true` em: 468 registros de lecionário
(156 × 3), 105 de santos e 189 de palavra do dia. O que entrou no app carrega
esse status na pesquisa, não no código — o app não tem campo de revisão. Vale
uma passada editorial antes de publicar.

## Estreiteza a corrigir no próximo lote

As 60 passagens da Palavra do dia em português vêm **todas de Mateus 5–7** (o
Sermão da Montanha): 36 do capítulo 5, 9 do 6 e 21 do 7. Como rotação diária,
são três meses sem sair do mesmo discurso. O próximo lote precisa de Salmos,
profetas, cartas e Atos.
