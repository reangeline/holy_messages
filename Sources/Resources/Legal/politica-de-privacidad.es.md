# Política de Privacidad de Missale

**Última actualización: 25 de septiembre de 2026**

Esta política describe la aplicación Missale para iPhone y iPad. Fue escrita a
partir del código de la aplicación, no de una plantilla: todo lo que la
aplicación guarda está listado en `Sources/Models/LocalData.swift`, y una
prueba automatizada falla si la aplicación empieza a guardar algo que no figure
en esta política.

## El resumen

Missale pide una cuenta, creada con "Iniciar sesión con Apple". Esa cuenta es lo
único que la aplicación envía a un servidor nuestro: el identificador que Apple
nos da y, si eliges compartirlo, tu correo (que puede ser una dirección de
reenvío de Apple).

**Lo que escribes y registras queda en tu dispositivo.** Tus notas, el Examen,
el registro de "Hoy estoy…", los rosarios y tu progreso quedan solo en tu
iPhone. **La única excepción es la orientación:** el texto que escribas en el
cuadro "Escribe lo que estás sintiendo" sale del dispositivo cuando, y solo
cuando, tocas "Recibir orientación". Mira "La orientación" más abajo.

## Qué se guarda en tu dispositivo

Todo lo siguiente queda en el almacenamiento local de la aplicación, en tu
dispositivo.

**Lo que escribes y registras**

- Tu registro de "Hoy estoy…": el estado elegido, la fecha y la nota opcional
  que escribas.
- Tus respuestas escritas en el Examen del día: gratitud, petición de luz,
  revisión y respuesta.
- Los rosarios que registres, con el misterio, el modo y la intención cuando
  escribas una.
- Tu progreso en Formación: qué partes completaste y en qué orden.
- En la Biblia, los versículos que marcaste y el capítulo marcado como "dónde
  me quedé".
- Lo que completaste de "Tu día con Dios" cada día (de los últimos 60 días),
  lo que escribiste que esperas de cada día en el ofrecimiento de la mañana, y
  hasta qué capítulo del Nuevo Testamento leíste.
- Los días en que completaste "Tu día con Dios" (solo la fecha), usados para
  pedir una valoración en la App Store una sola vez, el tercer día.
- El nombre que escribas en Ajustes, usado solo para llamarte por tu nombre en
  las pantallas de la aplicación.

**Tus preferencias**

- El idioma elegido para la aplicación.
- El calendario litúrgico regional elegido.
- Si el modo principiante del Rosario está activado.
- Si ya completaste la presentación inicial.
- Los horarios elegidos para el aviso de la lectura del día.

El idioma se guarda en un almacenamiento compartido entre la aplicación y sus
widgets, para que el widget aparezca en el mismo idioma. Ese compartir es
local, en tu dispositivo.

## Qué no hace la aplicación

- **No envía lo que escribes**, salvo el texto de la orientación, cuando la
  pides. Notas, Examen, registros y progreso quedan en tu dispositivo.
- **No tiene sincronización.** Nosotros no copiamos nada a otro dispositivo.
- **No tiene analíticas, telemetría ni rastreadores de terceros.** No incluye
  ningún SDK de análisis, publicidad o atribución.
- **No tiene anuncios.**
- **No vendemos, alquilamos ni compartimos datos.**
- **No accede** a tus contactos, tu calendario, tus fotos, tu micrófono, tu
  cámara ni tu ubicación.

## Tu cuenta

Para usar Missale inicias sesión con **"Iniciar sesión con Apple"**. No hay
contraseña nuestra: quien confirma que eres tú es Apple.

**Qué recibe y guarda nuestro servidor**

- El identificador que Apple crea para ti en Missale (un código que no sirve en
  ninguna otra aplicación).
- Tu correo, solo si eliges compartirlo en la pantalla de Apple. Apple te
  permite ocultarlo; en ese caso recibimos una dirección de reenvío.
- La fecha en que se creó la cuenta.

**En tu dispositivo**, la sesión de la cuenta (las claves que demuestran al
servidor que iniciaste sesión) se guarda en el Llavero del iPhone, cifrada,
solo en este dispositivo, fuera de las copias de seguridad y de iCloud.

**Dónde está.** El servidor funciona en Amazon Web Services (AWS), en Estados
Unidos, que trata estos datos en nuestro nombre. Al crear la cuenta aceptas
esta transferencia internacional, hecha para prestar el servicio que pediste.

**Durante cuánto tiempo.** Hasta que borres la cuenta. No usamos estos datos
para publicidad, no los vendemos y no los cruzamos con nada.

**La aplicación solo se comunica con el servidor de Missale**, y solo para
iniciar sesión, mantenerla, borrar la cuenta y pedir la orientación. Además,
descarga de nuestro servidor de archivos los textos de la propia aplicación
(santos, la palabra del día y otros) cuando publicamos correcciones o
novedades. En esa descarga no se envía nada tuyo: la aplicación solo pide los
archivos, como cualquier página web. Una prueba automatizada falla si
aparece código de red en cualquier otra parte de la aplicación.

## La orientación

En el cuadro "Escribe lo que estás sintiendo" puedes describir cómo estás. Al
tocar **"Recibir orientación"**:

- El texto va al servidor de Missale, que lo pasa a **Jev**, un modelo de
  inteligencia artificial de **TypeSafe AI**, a través de **OpenRouter** (ambas
  en Estados Unidos). Jev no escribe nada: solo **elige**, en el acervo
  revisado de Missale, el estado que el texto describe y la respuesta (el
  Salmo, el santo y el paso) que mejor le corresponde, e indica si el texto
  trae señales de riesgo para la vida, para mostrar primero la orientación de
  crisis.
- **No guardamos el texto** y no entra en los registros del servidor. El
  servidor guarda solo cuántas orientaciones pidió tu cuenta cada día, para un
  límite diario, y cuántas usó sin suscripción. OpenRouter y TypeSafe procesan
  el texto para responder, según sus propias políticas.
- En tu dispositivo, el texto queda guardado como la nota de ese registro de
  "Hoy estoy…", como cualquier nota tuya.
- Como el texto puede hablar de tu fe y de tu salud emocional, que son datos
  sensibles, solo se envía con tu toque en el botón, cada vez, y el aviso está
  justo debajo del cuadro. Siempre puedes registrar cómo estás solo con los
  botones, sin enviar nada.

## Notificaciones

Si lo autorizas, la aplicación programa en tu iPhone los avisos del Ángelus, a
las 6, a las 12 y a las 18. Esos avisos los crea y los dispara el propio
iPhone, a partir del calendario litúrgico que viene dentro de la aplicación. No
existe servidor de notificaciones, no se envía nada a nosotros, y no sabemos si
recibiste, abriste o ignoraste un aviso. Puedes retirar el permiso en cualquier
momento en los Ajustes del iPhone.

## Enlaces a las fuentes

Las fichas de santos, el Examen, las apariciones y las lecturas nombran las
ediciones y los documentos de donde viene el texto, y algunas traen un enlace.
Al tocar un enlace, tu navegador abre el sitio de esa fuente — la Santa Sede,
un santuario, un archivo público. Desde ahí se aplica la política de privacidad
de ese sitio, no esta. La aplicación no envía ningún dato tuyo en esos enlaces.

## Suscripción

Missale ofrece una suscripción opcional. La compra, el cobro, la renovación y
la cancelación las gestiona íntegramente la **App Store de Apple**. Nunca vemos
ni guardamos tu nombre de facturación, tu tarjeta, tu dirección ni ningún dato
de pago. La aplicación solo consulta a la App Store si existe una suscripción
activa en este dispositivo, para desbloquear el contenido correspondiente.

El tratamiento de tus datos de pago por parte de Apple se rige por la política
de privacidad de Apple.

## Borrar tus datos

**Borrar la cuenta**: en **Ajustes › Cuenta › Eliminar cuenta**. Esto borra de
nuestro servidor todo lo que guarda sobre ti (el identificador de Apple, el
correo si lo hay y la fecha de creación) y cierra la sesión en este
dispositivo. La suscripción no se cancela desde ahí: es de la App Store y se
cancela allí.

**Borrar la aplicación del dispositivo elimina todo lo que guardó en él**: tus
notas, tu registro, tu progreso, tu nombre y la sesión. La cuenta en el
servidor sigue hasta que la borres, desde la aplicación o escribiendo al
contacto de abajo.

En **Ajustes › Tus datos** también puedes:

- **Exportar tus datos**: un archivo JSON con todo lo que escribiste y
  registraste, entregado por la hoja de compartir de iOS, para guardarlo o
  enviarlo donde quieras. El archivo se genera en el dispositivo y solo sale de
  él si lo envías.
- **Borrar tus datos**: elimina del dispositivo, de una vez, todo lo que figura
  en "Lo que escribes y registras" arriba. Las preferencias (idioma,
  calendario, horarios) se mantienen. No se puede deshacer.

## Menores

Missale no está dirigida a menores y no recoge a sabiendas datos de menores de
13 años. Si sabes de una cuenta creada por un niño, escribe al contacto de abajo
y se borrará.

## Tus derechos (RGPD, CCPA, LGPD)

Para los datos de la cuenta descritos arriba, **somos los responsables**. El
RGPD, la CCPA y la LGPD te dan derechos de acceso, rectificación, supresión y
portabilidad sobre ellos. Puedes borrar la cuenta en cualquier momento desde la
aplicación, y pedir acceso, rectificación o supresión en el contacto de abajo.

Lo que escribes y registras no llega a nosotros: queda bajo tu propio control,
en tu dispositivo, y se va con la aplicación cuando la borras.

## Cambios en esta política

Si la aplicación empieza a guardar o enviar algo distinto, esta política se
actualizará antes de que la versión que lo haga llegue a la App Store, y
cambiará la fecha de arriba.

## Contacto

ola@missale.app
