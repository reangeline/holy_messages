# Capturas para a App Store Connect

## assinatura-revisao-{pt,en,es}.png

A captura que a App Store Connect exige em **Informações de revisão** de cada
assinatura: a tela onde a compra é oferecida. 1206 × 2622, iPhone 17.

Use a `en` — o revisor da Apple trabalha em inglês.

**Estas imagens estão desatualizadas.** Foram feitas antes de o StoreKit ser
ligado, e mostram os preços que estavam cravados no código. Refaça pelo passo
a passo abaixo, que produz a tela com os valores reais da App Store Connect.

## Como refazer, com os preços de verdade

A captura precisa vir da ação **Run** do Xcode, porque é ela que carrega os
produtos locais. Um teste de UI não serve: a configuração do StoreKit não
alcança o app sob teste (o `SKTestSession` configura o processo de teste, não o
processo do app — testei).

1. Abra `Missale.xcodeproj` no Xcode.
2. Confirme em **Product › Scheme › Edit Scheme › Run › Options › StoreKit
   Configuration** que está `Tests/Support/Missale.storekit`. Já vem assim.
3. Em `Tests/Support/Missale.storekit`, ajuste `displayPrice` das duas
   assinaturas para os valores que você cadastrou na App Store Connect. Hoje
   estão 34.90 e 199.90, que foram os do código antigo — se não forem os seus,
   troque, senão a captura mostra preço que não será cobrado.
4. Rode no simulador (⌘R). A tela abre direto se você usar o argumento
   `-openScreen paywall` em **Run › Arguments**; sem ele, a tela está no fim do
   onboarding.
5. ⌘S no simulador salva a captura na Mesa.

Se a assinatura tiver **teste gratuito**, coloque-o em `introductoryOffer` no
mesmo arquivo — o botão passa a dizer os dias que o produto oferece, em vez de
prometer trinta como antes.

## O que o app faz agora

Nada de preço, período ou prazo de teste está escrito no app. Tudo vem do
StoreKit: o valor já na moeda de quem abre, o período da assinatura, e o teste
gratuito do `introductoryOffer` do produto. Se a App Store não responder, a
tela diz isso e oferece continuar de graça — nunca cai num preço próprio.

Os identificadores são `mensal` e `anual`, em
`SubscriptionStore.ProductID`. São os Product IDs, não os Apple IDs
(6814659756 e 6814660801), que o `Product.products(for:)` ignora em silêncio.

## O que foi corrigido para a captura poder existir

1. **"4.8 ★★★★★ · 12,4 mil avaliações"** — nota e contagem inventadas para um
   app que nunca foi publicado. Rejeição direta.
2. **Plano "Vitalício", R$ 649,90** — sem produto cadastrado. E aparecia por
   R$ 349,90 nas Configurações: dois preços para a mesma coisa.
3. **Configurações › Assinatura** declarava "ACTIVE · US$ 39.99/year · renova
   em 14 de outubro de 2026, cobrado pela App Store" em toda instalação, sem
   ter cobrado ninguém.

`PaywallUITests` e `SubscriptionStoreTests` falham se qualquer um dos três
voltar.

## Ainda pendente, e não é captura

**Nada no app está atrás da assinatura.** Não existe um `if isSubscribed` em
nenhuma tela de conteúdo. O paywall promete desbloquear quatro coisas — todas
as trilhas de Formação, o calendário completo, as orações offline, o Terço
guiado — e as quatro já estão abertas. Decidir o que fica atrás do muro, ou
transformar a assinatura em apoio sem desbloqueio, é decisão de produto.
