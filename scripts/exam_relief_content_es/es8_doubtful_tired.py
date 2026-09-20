# -*- coding: utf-8 -*-
"""Español — desolación: doubtful y tired.

En `doubtful` ninguna lectura reprende la duda: los salmos elegidos la ponen
dentro de la oración («¿Ha de abandonar para siempre?») y la dejan ahí. En
`tired` el paso concreto es casi siempre descansar, comer o dormir — el salmo
CXXVI manda levantarse después de haber descansado, no antes.
"""

from exam_relief_content_es._shared import e

BLOCK = {
    "doubtful": [
        e("ta1836-lxxvi-8-13", "tomas-aquino", "Santo Tomás de Aquino",
          title="¿Es posible que nos abandone?",
          why="El salmista formula la duda entera, con todas sus preguntas, y sigue rezándola: la duda cabe en el salmo.",
          saint_why="Empezaba cada artículo de la Suma exponiendo los argumentos contrarios antes de responder.",
          step="Escribe tu duda como pregunta, completa, sin contestarla hoy."),

        e("ta1836-xxvi-13-14", "monica", "Santa Mónica",
          title="Espera con paciencia",
          why="El salmo no ordena creer: ordena aguardar y cobrar aliento. La duda se trata con tiempo.",
          saint_why="Esperó casi treinta años y en ese tiempo no dejó de pedir por lo mismo.",
          step="Comprométete a rezar por esto treinta días, y apunta la fecha final."),

        e("ta1836-lxi-2-3", "joao-paulo-ii", "San Juan Pablo II",
          title="Dependiendo de él mi salvación",
          why="El salmo apoya la firmeza en quién es Dios y no en la certeza del que reza.",
          saint_why="Escribió sobre la fe y la razón como dos caminos que llevan al mismo sitio, y discutió con filósofos que lo negaban.",
          step="Lee hoy lo que la Iglesia enseña sobre lo que dudas, en una fuente fiable."),

        e("ta1836-xxx-2-6", "edith-stein", "Santa Teresa Benedicta de la Cruz",
          title="No quede yo confundido",
          why="El salmista pide no quedar defraudado: admite que podría, y lo dice en la oración.",
          saint_why="Fue atea durante su adolescencia y llegó a la fe leyendo a Teresa de Jesús, sin abandonar la filosofía.",
          step="Lee hoy diez páginas de un autor que crea, y anota una objeción."),

        e("ta1836-xxxi-7-11", "agostinho", "San Agustín",
          title="Te enseñaré el camino",
          why="La promesa del salmo es de entendimiento: la duda recibe instrucción, no reproche.",
          saint_why="Pasó nueve años entre los maniqueos y los dejó cuando sus preguntas quedaron sin respuesta.",
          step="Formula hoy tu duda a alguien que sepa, y escucha la respuesta hasta el final."),

        e("ta1836-lv-4-5", "padre-pio", "San Pío de Pietrelcina",
          title="Pero yo confío en ti",
          why="El salmo pone el temor y la confianza en la misma frase, unidos por un «pero»: no se excluyen.",
          saint_why="Escribió a su director que temía haber perdido la fe, y siguió celebrando y confesando.",
          step="Di hoy: dudo, y me quedo. Y no añadas nada."),

        e("ta1836-xxvi-13-14", "teresinha", "Santa Teresita del Niño Jesús",
          title="En la tierra de los vivientes",
          why="El salmo espera ver los bienes de Dios en esta tierra: la duda recibe una promesa concreta, no un consuelo vago.",
          saint_why="Escribió que en su última enfermedad las voces de la incredulidad le repetían que no había nada después.",
          step="Escribe una cosa buena que sí crees, y déjala a la vista."),

        e("ta1836-lxi-7-9", "catarina-siena", "Santa Catalina de Siena",
          title="No vacilaré",
          why="El salmista manda a su propia alma mantenerse sujeta: la duda se responde hablándose a sí mismo.",
          saint_why="Dictaba sus cartas y su Diálogo sin haber recibido formación escolar, y las sometía al juicio de teólogos.",
          step="Háblate hoy en voz alta como hablarías a un amigo que duda."),

        e("ta1836-xxx-15-17", "inacio-loyola", "San Ignacio de Loyola",
          title="Tú eres, dije yo, mi Dios",
          why="El salmo registra una decisión dicha: la duda se atraviesa por un acto de voluntad, no por una evidencia.",
          saint_why="Escribió que en tiempo de desolación no se debe cambiar lo decidido en tiempo de consolación.",
          step="No cambies hoy ninguna decisión espiritual que tomaste en tiempo mejor."),

        e("ta1836-lxxvi-8-13", "joao-cruz", "San Juan de la Cruz",
          title="Me acordaré de las obras del Señor",
          why="El salmo corta las preguntas con un recuerdo: la duda se sostiene con memoria, no con argumentos nuevos.",
          saint_why="Distinguió la fe de su sensación, y sostuvo que la fe crece justamente cuando deja de apoyarse en lo que se siente.",
          step="Recuerda hoy tres momentos en que creíste con facilidad."),

        e("ta1836-xc-10-12", "jose", "San José",
          title="Mandó a sus ángeles",
          why="El salmo promete guarda en cada paso: la duda no tiene que ver el camino entero para dar el siguiente.",
          saint_why="En los relatos de Mateo actúa por avisos recibidos en sueños, sin explicación ni confirmación previa.",
          step="Da hoy un solo paso de lo que crees que debes hacer."),

        e("ta1836-lv-4-5", "francisco-xavier", "San Francisco Javier",
          title="Me gloriaré por las promesas",
          why="El salmista se apoya en promesas hechas, no en lo que ve: la duda vuelve a lo prometido.",
          saint_why="Escribió cartas describiendo sus dudas sobre los métodos y el fruto de su propio trabajo en Asia.",
          step="Lee hoy una promesa del Evangelio y cópiala a mano."),

        e("ta1836-xxxi-7-11", "maria-madalena", "Santa María Magdalena",
          title="Tendré fijos sobre ti mis ojos",
          why="Quien vigila es Dios, no el que duda: el salmo invierte la carga de sostener la relación.",
          saint_why="En el relato de Juan confunde a Jesús con el hortelano hasta que él la llama por su nombre.",
          step="Deja hoy de intentar entenderlo y solo di tu nombre en la oración."),

        e("ta1836-xxx-2-6", "isabel-trindade", "Santa Isabel de la Trinidad",
          title="Por honra de tu nombre",
          why="El salmo pide por el nombre de Dios y no por el mérito propio: la duda no invalida la petición.",
          saint_why="Escribió que se apoyaba en la fe desnuda, sin pruebas sensibles, en sus últimos meses de enfermedad.",
          step="Reza hoy sin pedir ninguna señal."),

        e("ta1836-cxxxviii-5-8", "carlo-acutis", "San Carlo Acutis",
          title="Superior a mi alcance",
          why="El salmo admite que la sabiduría de Dios excede lo que se puede abarcar: la duda es una medida, no una falla.",
          saint_why="Reunía documentación sobre milagros eucarísticos precisamente para mostrar hechos verificables.",
          step="Busca hoy un dato verificable sobre lo que dudas, y verifícalo."),
    ],

    "tired": [
        e("ta1836-cxxvi-1-2", "benito", "San Benito",
          title="Levantaos después de haber descansado",
          why="El salmo corrige directamente el exceso de trabajo: llama vano el desvelo y manda descansar primero.",
          saint_why="Su Regla fija el sueño, las comidas y el trabajo con medida, y manda al abad no quebrar al débil.",
          step="Acuéstate hoy a la hora que sabes que deberías."),

        e("ta1836-iv-9-10", "jose", "San José",
          title="Dormiré en paz",
          why="El salmo hace del sueño un acto de confianza: descansar es aquí la forma de esperar.",
          saint_why="Los Evangelios lo muestran recibiendo tres indicaciones mientras dormía, no mientras trabajaba.",
          step="Duerme hoy sin poner alarma para nada opcional."),

        e("ta1836-liv-23", "notburga", "Santa Notburga",
          title="Él te sustentará",
          why="El salmo promete sustento a quien suelta el peso: al cansancio le responde con alimento, no con ánimo.",
          saint_why="Se cuenta que dejaba la hoz al oír la campana de la tarde, aunque quedara trabajo en el campo.",
          step="Para hoy tu trabajo a la hora fijada, aunque quede cosa sin hacer."),

        e("ta1836-xxii-1-3", "damiao-molokai", "San Damián de Molokai",
          title="Aguas que restauran y recrean",
          why="El salmo habla de pasto y de agua: al cansancio se le ofrecen cosas concretas, no significados.",
          saint_why="Trabajó dieciséis años en Molokai y siguió celebrando y construyendo hasta las últimas semanas.",
          step="Bebe agua, come algo y siéntate diez minutos, hoy, sin pantalla."),

        e("ta1836-xxxvii-9-16", "josefina-bakhita", "Santa Josefina Bakhita",
          title="He perdido mis fuerzas",
          why="El salmista dice que hasta la luz de los ojos le falta: el cansancio se nombra sin disculpa.",
          saint_why="En sus últimos años, ya enferma, decía que le parecía volver a cargar las cadenas de su infancia.",
          step="Di hoy a alguien: no puedo más con esto ahora."),

        e("ta1836-xc-1-4", "padre-pio", "San Pío de Pietrelcina",
          title="Descansará bajo su protección",
          why="El salmo promete descanso bajo la sombra: no pide fuerzas nuevas, ofrece cobijo.",
          saint_why="Dormía muy pocas horas y en sus cartas pedía oraciones por su propio agotamiento.",
          step="Reza hoy acostado, si es lo único que te sale."),

        e("ta1836-cxxx-3", "andre-bessette", "San Andrés Bessette",
          title="Espere Israel",
          why="El salmo entero cabe en una línea: cuando no hay fuerzas, basta una frase corta y repetida.",
          saint_why="Rezaba y hacía rezar oraciones muy breves, y trabajó cuarenta años en el mismo oficio de portero.",
          step="Reza hoy una sola frase, tres veces, y nada más."),

        e("ta1836-liv-23", "teresinha", "Santa Teresita del Niño Jesús",
          title="No dejará al justo en agitación",
          why="La promesa es de no quedar en agitación perpetua: el salmo le pone un final al desgaste.",
          saint_why="Escribió que se quedaba dormida en la oración y que no se inquietaba por eso.",
          step="Si te duermes rezando hoy, no lo tomes como falta."),

        e("ta1836-xxxvii-9-16", "oscar-romero", "San Óscar Romero",
          title="Tú me oirás",
          why="El salmo termina la lista de fuerzas perdidas con una sola certeza: será oído. Nada más se le pide.",
          saint_why="Hizo retiro y confesión pocos días antes de su muerte, en medio de un trabajo que no podía sostener solo.",
          step="Pide hoy ayuda concreta a una persona, con una tarea nombrada."),

        e("ta1836-xxii-1-3", "vicente-paulo", "San Vicente de Paúl",
          title="Me ha colocado en lugar de pastos",
          why="El salmo empieza por la provisión, no por la marcha: al cansado se le da de comer antes de moverlo.",
          saint_why="Insistía en que a los hermanos agotados se les diera reposo antes de pedirles más caridad.",
          step="Quita hoy una tarea de tu lista y no la sustituyas."),

        e("ta1836-iv-9-10", "isabel-trindade", "Santa Isabel de la Trinidad",
          title="Descansaré en tus promesas",
          why="El descanso del salmo se apoya en promesas ajenas, no en el trabajo terminado.",
          saint_why="Pasó sus últimos meses sin poder hacer casi nada, y escribió que eso también era oración.",
          step="Acepta hoy que quede algo sin terminar, y dilo en la oración."),

        e("ta1836-vi-3-5", "rita-cassia", "Santa Rita de Casia",
          title="Estoy sin fuerzas",
          why="El salmo dice literalmente que está sin fuerzas y pide sanación: el cansancio se trata como enfermedad.",
          saint_why="Vivió sus últimos años enferma y encamada en el monasterio de Casia.",
          step="Pide hoy cita médica si llevas tiempo postergándola."),

        e("ta1836-xxx-10-13", "edith-stein", "Santa Teresa Benedicta de la Cruz",
          title="Mis años con tanto gemir",
          why="El salmo cuenta el desgaste en años, no en días: reconoce el cansancio acumulado.",
          saint_why="Trabajó años dando clases y traduciendo sin la cátedra que le correspondía, y lo dejó escrito sin queja.",
          step="Mira hoy cuánto llevas así, y dilo en voz alta."),

        e("ta1836-lxxxix-14-17", "monica", "Santa Mónica",
          title="Por los años en que sufrimos miserias",
          why="El salmo pide alegría por los días de humillación, no a cambio de ellos: cuenta el cansancio como parte.",
          saint_why="Murió poco después de ver bautizado a su hijo, al final de un camino que había durado décadas.",
          step="Agradece hoy por un año difícil que ya pasó."),

        e("ta1836-cxli-5-8", "maximiliano-kolbe", "San Maximiliano María Kolbe",
          title="Atiende a mi humilde plegaria",
          why="El salmista pide atención porque está sin fuerzas para huir: el cansancio pide poco y lo pide claro.",
          saint_why="Tenía tuberculosis desde joven y trabajó con un pulmón dañado hasta su detención en 1941.",
          step="Reza hoy lo mínimo que puedas rezar, y considéralo hecho."),
    ],
}
