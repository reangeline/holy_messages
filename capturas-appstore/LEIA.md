# Captura de revisão da assinatura

A App Store Connect exige, em **Informações de revisão** de cada assinatura,
uma captura da tela onde a compra é oferecida.

**As capturas antigas foram apagadas.** Mostravam R$ 34,90/mês e R$ 199,90/ano,
que estavam cravados no código e **não são os preços cadastrados** — os reais
são R$ 19,90 e R$ 129,90. Uma captura com preço que não será cobrado é
divergência na mão do revisor.

## Como capturar

A captura tem de vir da ação **Run** do Xcode: é ela que carrega os produtos
locais. Teste de UI não serve — a configuração do StoreKit não alcança o app
sob teste (`SKTestSession` configura o processo de teste, não o do app;
verificado).

1. Abra `Missale.xcodeproj`.
2. **Product › Scheme › Edit Scheme › Run › Arguments**, adicione
   `-openScreen paywall` e `-hasCompletedOnboarding 1`. A tela abre direto; sem
   isso, ela está no fim do onboarding.
3. Confirme em **Run › Options › StoreKit Configuration** que está
   `Tests/Support/Missale.storekit`. Já vem assim.
4. ⌘R. A tela mostra **Mensal R$ 19,90/mês** e **Anual R$ 129,90/ano**, que são
   os valores de `Tests/Support/Missale.storekit`, iguais aos do Brasil na sua
   planilha de preços.
5. ⌘S no simulador salva a captura na Mesa.

Para capturar em outra moeda, mude o `displayPrice` no mesmo arquivo — a
planilha tem os 175 valores por região.

## Teste gratuito

A configuração local está com `introductoryOffer: null`, então o botão diz
"Assinar". **Se você cadastrou período de teste na App Store Connect**, o app
lê do produto e o botão passa a dizer os dias reais — não precisa mexer em
código. Para ver isso na captura, preencha `introductoryOffer` no arquivo
local.

## O que o app faz agora

Nenhum preço, período ou prazo de teste está escrito no app — um teste falha se
voltarem, inclusive os valores certos, porque são 175 regiões e o valor muda em
cada uma. Tudo vem do StoreKit: valor na moeda de quem abre, período da
assinatura, e teste do `introductoryOffer` do produto.

Identificadores: `mensal` e `anual`, em `SubscriptionStore.ProductID`. São os
Product IDs — não os Apple IDs (6814659756 e 6814660801), que o
`Product.products(for:)` ignora em silêncio.

Se a App Store não responder, a tela declara isso e oferece continuar de graça.
Nunca cai num preço próprio.

## O que fica grátis, e o que não

Decisão desta versão: **só a palavra do dia** é gratuita. Calendário, Formação,
Orações, santo do dia, Terço, Exame e Completas pedem assinatura.

Duas exceções que não são comerciais e estão travadas por teste
(`SubscriptionGateUITests`):

- **O caminho de apoio.** O check-in de humor, o alívio e as telas pastorais
  que terminam no número de crise do país do leitor nunca ficam atrás do muro.
- **Ajustes e os dois documentos legais**, para a pessoa poder cancelar, ler o
  que é guardado e apagar o app sabendo o que ele reteve.

E a tela bloqueada mantém a barra de abas: a primeira versão do portão a
removia e prendia a pessoa na aba, sem caminho de volta ao Hoje — e portanto
sem caminho para o apoio.
