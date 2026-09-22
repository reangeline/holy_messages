# Capturas para a App Store Connect

## assinatura-revisao-{pt,en,es}.png

A captura que a App Store Connect exige em **Informações de revisão** de cada
assinatura. Mostra a tela onde a compra é oferecida. 1206 × 2622, iPhone 17.

Use a `pt` se a conta da revisão estiver em português; a `en` é a mais segura
para o revisor da Apple, que trabalha em inglês.

### O que foi corrigido antes de gerar

A tela anterior seria rejeitada por três motivos, e os três estavam no código:

1. **"4.8 ★★★★★ · 12,4 mil avaliações"** — nota e contagem inventadas para um
   app que nunca foi publicado. Prova social falsa é rejeição direta.
2. **Plano "Vitalício", R$ 649,90** — não há produto cadastrado para ele.
   Oferecer uma compra que não existe é rejeição.
3. O mesmo plano aparecia nas Configurações por **R$ 349,90** — dois preços
   contraditórios para a mesma coisa, no mesmo app.

## Falta para a captura valer de verdade

Os preços na imagem (**R$ 34,90/mês** e **R$ 199,90/ano**) estão **fixos no
código**, não vêm da App Store. Se os valores que você cadastrou forem outros,
o revisor vê uma divergência entre a captura e o produto.

Para resolver preciso de duas coisas da App Store Connect:

- o **ID de produto** das duas assinaturas (algo como `com.missale.app.monthly`
  e `com.missale.app.yearly`);
- se existe **período de teste gratuito** e de quantos dias — o botão hoje diz
  "Teste grátis por 30 dias", e isso também tem que ser verdade.

Com isso eu ligo o StoreKit 2: a tela passa a ler preço, período e duração do
teste da própria App Store, na moeda da região de quem abre — que é o que os
termos de uso já declaram que ela faz. Aí a captura vale para qualquer preço
que você decida depois, sem regerar nada.

## Ainda pendente, e não é captura

A tela `SubscriptionDetailView` (Configurações › Assinatura) mostra uma
assinatura **falsa e ativa**: "ACTIVE · US$ 39.99/year · renova em 14 de
outubro de 2026, cobrado pela App Store". É uma declaração de cobrança
fabricada na interface entregue, e sai junto com a ligação do StoreKit.
