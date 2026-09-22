# Missale.storekit

Configuração local do StoreKit, para rodar e capturar o paywall sem depender da
App Store. **Não vai para o app**: é só do esquema de teste.

Os `productID` aqui têm de ser os mesmos da App Store Connect, senão o teste
passa e a produção não carrega nada. Os preços e o período deste arquivo são
locais e servem só para ver a tela; em produção quem responde é a App Store.

Para usar no Xcode: Product › Scheme › Edit Scheme › Run › Options ›
StoreKit Configuration › Missale.storekit.
