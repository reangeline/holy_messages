# Política de Privacidade do Missale

**Última atualização: 26 de setembro de 2026**

Esta política descreve o aplicativo Missale para iPhone e iPad. Ela foi escrita
a partir do código do aplicativo, não de um modelo: a lista de tudo o que é
guardado está em `Sources/Models/LocalData.swift` e um teste automatizado falha
se um dado novo passar a ser guardado sem entrar nesta política.

## O resumo

O Missale pede uma conta, criada com o "Entrar com a Apple". Essa conta é a
única coisa que o aplicativo envia para um servidor nosso: o identificador que
a Apple nos dá e, se você escolher compartilhá-lo, o seu e-mail (que pode ser um
endereço de encaminhamento da Apple).

**O que você escreve e registra fica no seu aparelho.** As anotações, o
Exame, o registro do "Hoje eu estou…", os terços e o progresso ficam só no seu
iPhone. **Há duas exceções, e nas duas o texto só serve para o Jev escolher
algo no acervo revisado:** o texto que você escrever na caixa "Escreva o que
você está sentindo" sai do aparelho quando, e só quando, você toca em "Receber
orientação"; e, se você for assinante e a personalização estiver ligada,
alguns textos que você escreve (a intenção do Terço, o Exame, a intenção da
manhã) saem para escolher o que mostrar. Veja "A orientação" e "A
personalização" abaixo.

## O que fica guardado no seu aparelho

Tudo abaixo fica no armazenamento local do aplicativo, no seu aparelho.

**O que você escreve e registra**

- O registro do "Hoje eu estou…": o estado escolhido, a data e a anotação
  opcional que você digitar.
- As suas respostas escritas no Exame do dia: gratidão, pedido de luz, revisão
  e resposta.
- Os terços que você registrar, com o mistério, o modo e a intenção, quando
  você escrever uma.
- O seu progresso na Formação: quais partes você concluiu e em que ordem.
- Na Bíblia, os versículos que você marcou e o capítulo marcado como "onde
  parei".
- O que você concluiu do "Seu dia com Deus" em cada dia (dos últimos 60 dias),
  o que você escreveu que espera de cada dia no oferecimento da manhã, e até
  qual capítulo do Novo Testamento você leu.
- Os dias em que você completou o "Seu dia com Deus" (só a data), usados para
  pedir uma avaliação na App Store uma única vez, no terceiro dia.
- O nome que você digitar nas Configurações, usado apenas para chamá-lo pelo
  nome nas telas do aplicativo.

**As suas preferências**

- O idioma escolhido para o aplicativo.
- O calendário litúrgico regional escolhido.
- Se o modo iniciante do Terço está ligado.
- Se "Personalizar com o que escrevo" está ligado.
- Se você já concluiu a apresentação inicial.
- Os horários escolhidos para o aviso da leitura do dia.

O idioma fica num armazenamento compartilhado entre o aplicativo e os seus
widgets, para que o widget apareça no mesmo idioma. Esse compartilhamento é
local, no seu aparelho.

## O que o aplicativo não faz

- **Não envia o que você escreve**, exceto o texto da orientação, quando você
  pede, e os textos da personalização, se você for assinante e ela estiver
  ligada. Nada disso é guardado por nós: anotações, Exame, registros e
  progresso ficam no seu aparelho.
- **Não tem sincronização.** Nada é copiado para outro aparelho por nós.
- **Não tem analytics, telemetria nem rastreadores de terceiros.** Nenhum SDK
  de análise, publicidade ou atribuição está incluído.
- **Não tem anúncios.**
- **Não vende, aluga nem compartilha dados.**
- **Não acessa** seus contatos, sua agenda, suas fotos, seu microfone, sua
  câmera ou sua localização.

## A sua conta

Para usar o Missale você entra com o **"Entrar com a Apple"**. Não existe senha
nossa: quem confirma que é você é a Apple.

**O que o nosso servidor recebe e guarda**

- O identificador que a Apple cria para você no Missale (um código que não
  serve em nenhum outro aplicativo).
- O seu e-mail, só se você escolher compartilhá-lo na tela da Apple. A Apple
  permite esconder o e-mail; nesse caso recebemos um endereço de
  encaminhamento.
- A data em que a conta foi criada.

**No seu aparelho**, a sessão da conta (as chaves que provam para o servidor
que você entrou) fica nas Chaves do iPhone (Keychain), criptografada, apenas
neste aparelho, fora de backups e do iCloud.

**Onde fica.** O servidor roda na Amazon Web Services (AWS), nos Estados
Unidos, que processa esses dados em nosso nome. Ao criar a conta, você concorda
com essa transferência internacional, feita para prestar o serviço que você
pediu.

**Por quanto tempo.** Até você apagar a conta. Não usamos esses dados para
publicidade, não os vendemos e não os cruzamos com nada.

**O aplicativo só se comunica com o servidor do Missale**, e só para entrar,
manter a sessão, apagar a conta, pedir a orientação e a personalização. Além disso, ele baixa do
nosso servidor de arquivos os textos do próprio aplicativo (santos, palavra do
dia e outros) quando publicamos correções ou novidades. Nesse download nada seu
é enviado: o aplicativo só pede os arquivos, como qualquer página da web. Um teste automatizado falha se código de rede
aparecer em qualquer outra parte do aplicativo.

## A orientação

Na caixa "Escreva o que você está sentindo", você pode descrever como está. Ao
tocar em **"Receber orientação"**:

- O texto vai para o servidor do Missale, que o repassa ao **Jev**, um modelo
  de inteligência artificial da **TypeSafe AI**, por meio da **OpenRouter**
  (ambas nos Estados Unidos). O Jev não escreve nada: ele só **escolhe**, no
  acervo revisado do Missale, o estado que o texto descreve e a resposta (o
  Salmo, o santo e o passo) que mais combina, e indica se o texto traz sinal
  de risco à vida, para mostrarmos primeiro a orientação de crise.
- **Nós não guardamos o texto** e ele não entra nos registros do servidor. O
  servidor guarda apenas quantas orientações a sua conta pediu em cada dia,
  para um limite diário, e quantas usou sem assinatura. A OpenRouter e a
  TypeSafe processam o texto para responder, conforme as políticas delas.
- No seu aparelho, o texto fica salvo como a anotação daquele registro do
  "Hoje eu estou…", como qualquer anotação sua.
- Como o texto pode falar da sua fé e da sua saúde emocional, que são dados
  sensíveis, ele só é enviado com o seu toque no botão, em cada vez, e o aviso
  está logo abaixo da caixa. Você pode sempre registrar como está só com os
  botões, sem enviar nada.

## A personalização

Se você é assinante, o Missale pode escolher, a partir do que você escreve, o
que mostrar em alguns momentos do dia. Isso acontece enquanto **"Personalizar
com o que escrevo"** estiver ligado em **Configurações**. Vem ligado, e você
pode desligar a qualquer momento.

- **O que é enviado:** a intenção que você escreve para o Terço; as respostas
  escritas do Exame do dia; a intenção da manhã, no oferecimento; e, para a
  palavra do dia, o último registro do "Hoje eu estou…" ou a última intenção da
  manhã que você escreveu.
- **Quando:** só se você for assinante e a personalização estiver ligada. Sem
  assinatura, ou com ela desligada, nada disso sai do aparelho, e o aplicativo
  funciona como sempre, sem personalizar.
- **Para quê:** o texto vai para o servidor do Missale, que o repassa ao
  **Jev**, como na orientação. O Jev não escreve nada: ele só **escolhe**, no
  acervo revisado do Missale, o que combina com o que você escreveu (por
  exemplo, os mistérios do Terço), e indica se o texto traz sinal de risco à
  vida, para mostrarmos primeiro a orientação de crise. O que aparece assim é
  sempre marcado como escolhido a partir do que você escreveu.
- **Nós não guardamos esse texto** e ele não entra nos registros do servidor.
  O servidor guarda apenas quantas escolhas a sua conta pediu em cada dia, para
  um limite diário. A OpenRouter e a TypeSafe processam o texto para responder,
  conforme as políticas delas.

## Notificações

Se você autorizar, o aplicativo agenda no seu iPhone os avisos do Angelus, às
6h, 12h e 18h. Esses avisos são criados e disparados pelo próprio iPhone, a
partir do calendário litúrgico que já vem no aplicativo. Não existe servidor de
notificações, nada é enviado para nós, e nós não ficamos sabendo se você
recebeu, abriu ou ignorou um aviso. Você pode revogar a autorização a qualquer
momento nos Ajustes do iPhone.

## Links para fontes

As fichas de santos, o Exame, as aparições e as leituras citam as edições e os
documentos de onde o texto veio, e algumas trazem um link. Ao tocar num link,
o seu navegador abre o site daquela fonte — a Santa Sé, um santuário, um
arquivo público. A partir dali vale a política de privacidade do site que você
abriu, não esta. O aplicativo não envia nenhum dado seu nesses links.

## Assinatura

O Missale oferece uma assinatura opcional. A compra, a cobrança, a renovação e
o cancelamento são processados inteiramente pela **App Store da Apple**. Nós
não vemos e não armazenamos o seu nome de cobrança, o seu cartão, o seu
endereço ou qualquer dado de pagamento. O aplicativo consulta na App Store
apenas se existe uma assinatura ativa neste aparelho, para liberar o conteúdo
correspondente.

O tratamento dos seus dados de pagamento pela Apple é regido pela política de
privacidade da Apple.

## Apagar os seus dados

**Apagar a conta**: em **Configurações › Conta › Apagar conta**. Isso apaga do
nosso servidor tudo o que ele guarda sobre você (o identificador da Apple, o
e-mail, se houver, e a data de criação) e encerra a sessão neste aparelho. A
assinatura não é cancelada por aí: ela é da App Store, e se cancela lá.

**Apagar o aplicativo do aparelho remove tudo o que ele guardou nele** — as suas
anotações, o seu registro, o seu progresso, o seu nome e a sessão. A conta no
servidor continua até você apagá-la, pelo aplicativo ou escrevendo para o
contato abaixo.

Em **Configurações › Seus dados** você também pode:

- **Exportar os seus dados**: um arquivo JSON com tudo o que você escreveu e
  registrou, entregue pela folha de compartilhar do iOS, para você guardar ou
  enviar para onde quiser. O arquivo é gerado no aparelho e só sai dele se
  você mandar.
- **Apagar os seus dados**: remove do aparelho, de uma vez, tudo o que está em
  "O que você escreve e registra" acima. As preferências (idioma, calendário,
  horários) continuam. Não dá para desfazer.

## Crianças

O Missale não é dirigido a crianças e não coleta, de propósito, dados de menores
de 13 anos. Se você souber de uma conta criada por uma criança, escreva para o
contato abaixo e ela será apagada.

## Os seus direitos (LGPD, GDPR, CCPA)

Para os dados da conta descritos acima, **nós somos os controladores**. A LGPD,
o GDPR e a CCPA dão a você direitos de acesso, correção, exclusão e
portabilidade sobre eles. Você pode apagar a conta a qualquer momento no
aplicativo, e pode pedir acesso, correção ou exclusão pelo contato abaixo.

O que você escreve e registra não fica conosco: o texto que passa pelo
servidor na orientação e na personalização não é guardado, e todo o resto fica
sob o seu próprio controle, no seu aparelho, e sai com o aplicativo quando você
o apaga.

## Mudanças nesta política

Se o aplicativo passar a guardar ou enviar algo diferente, esta política será
atualizada antes da versão que fizer isso chegar à App Store, e a data no topo
mudará.

## Contato

ola@missale.app
