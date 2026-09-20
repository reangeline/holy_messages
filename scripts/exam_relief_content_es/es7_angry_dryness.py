# -*- coding: utf-8 -*-
"""Español — desolación: angry y dryness.

`angry` es el estado más apretado del inventario: solo 3 pasajes curados para
15 lecturas, o sea 5 vueltas por salmo. Cada vuelta toma una cláusula distinta
del mismo texto — el Salmo IV permite el enojo, le pone límite, le da hora y
lugar, y nombra la rumiación — y ningún registro repite santo.

La regla pastoral es la de los otros idiomas: no se avergüenza la ira, no se
manda perdonar en el acto, y el paso concreto le da a la ira una salida
(decirla, escribirla, esperar, reparar) en lugar de pedir que desaparezca.
"""

from exam_relief_content_es._shared import e

BLOCK = {
    "angry": [
        e("ta1836-iv-5", "joao-batista", "San Juan Bautista",
          title="Enojaos",
          why="El salmo empieza permitiendo el enojo: el imperativo es «enojaos», y solo después viene el límite.",
          saint_why="Reprendió públicamente a Herodes por su matrimonio y no se retractó, según Marcos.",
          step="Di hoy en voz alta, a solas, qué te hizo enojar y por qué fue injusto."),

        e("ta1836-xlv-10-12", "oscar-romero", "San Óscar Romero",
          title="Considerad que yo soy el Dios",
          why="El salmo manda considerar quién es Dios: la ira se aplaca al recordar quién juzgará, no al negar el agravio.",
          saint_why="Denunció con nombres los asesinatos de la semana y siguió llamando a no responder con violencia.",
          step="Escribe el agravio como lo contarías ante un juez, sin adjetivos."),

        e("ta1836-cii-8-14", "rita-cassia", "Santa Rita de Casia",
          title="No durará para siempre su enojo",
          why="El salmo le pone plazo al enojo de Dios: si el suyo termina, el propio no tiene que ser eterno.",
          saint_why="Consiguió que la familia de su marido renunciara a la venganza tras su asesinato en Roccaporena.",
          step="Aplaza hoy tu respuesta veinticuatro horas, y anota la hora."),

        e("ta1836-iv-5", "vicente-paulo", "San Vicente de Paúl",
          title="Y no queráis pecar más",
          why="El límite del salmo no es sentir menos: es no dejar que el enojo se convierta en daño.",
          saint_why="Escribió que su propio temperamento era áspero y bilioso, y que tuvo que trabajarlo durante años.",
          step="Elige hoy una cosa que NO vas a hacer ni decir mientras estés así."),

        e("ta1836-xlv-10-12", "catarina-siena", "Santa Catalina de Siena",
          title="Estad tranquilos",
          why="El mandato es quedarse quieto: el salmo pide detener el cuerpo primero, no convencer al corazón.",
          saint_why="Escribió cartas duras a papas y gobernantes, pero las firmaba pidiendo obediencia a la Iglesia.",
          step="Quédate sentado diez minutos antes de escribir cualquier mensaje."),

        e("ta1836-cii-8-14", "josefina-bakhita", "Santa Josefina Bakhita",
          title="Ni estará amenazando perpetuamente",
          why="El salmo dice que Dios no queda amenazando: la ira que describe no se guarda como arma.",
          saint_why="Sus cicatrices eran permanentes y aun así se negó a hablar de sus dueños con dureza.",
          step="Deja hoy de contar por décima vez lo que te hicieron."),

        e("ta1836-iv-5", "monica", "Santa Mónica",
          title="En el retiro de vuestros lechos",
          why="El salmo le da lugar y hora al enojo: a solas, de noche. No lo saca a la mesa ni a la calle.",
          saint_why="Vivió con un marido de carácter violento y, según Agustín, esperaba el momento en que se le pudiera hablar.",
          step="Reserva hoy un momento a solas para tratar esto, y hasta entonces cállalo."),

        e("ta1836-xlv-10-12", "tomas-aquino", "Santo Tomás de Aquino",
          title="Ensalzado he de ser",
          why="El salmo dice que Dios será exaltado entre las naciones: la ira propia deja de ser la que tiene que arreglarlo.",
          saint_why="Sostuvo que la ira puede ser recta cuando se ajusta a la razón, y que el defecto está en la medida.",
          step="Escribe qué parte de esto te toca a ti y qué parte no."),

        e("ta1836-cii-8-14", "pedro-paulo", "San Pedro",
          title="No nos ha tratado según merecían",
          why="El salmo mide el trato recibido contra el merecido: quien recibió así tiene con qué medir su respuesta.",
          saint_why="Sacó la espada en el huerto, según Juan, y fue detenido por el propio Jesús.",
          step="Devuelve hoy una cortesía a quien te trató mal."),

        e("ta1836-iv-5", "inacio-loyola", "San Ignacio de Loyola",
          title="Las cosas que andáis meditando",
          why="El salmo nombra lo que se rumia en el corazón: la ira se trabaja donde se está repitiendo, no donde estalló.",
          saint_why="En su juventud llegó a buscar pelea con un moro que había hablado mal de la Virgen, y años después escribió reglas para examinar esos impulsos.",
          step="Anota el pensamiento que estás repitiendo y déjalo por escrito, no en la cabeza."),

        e("ta1836-xlv-10-12", "martinho-tours", "San Martín de Tours",
          title="Nuestro defensor",
          why="El salmo llama a Dios defensor: la ira puede soltar la defensa propia porque hay otro que defiende.",
          saint_why="Se negó a seguir combatiendo y pidió ser puesto desarmado en primera línea, según su biógrafo Sulpicio Severo.",
          step="Renuncia hoy a ganar una discusión que ya no importa."),

        e("ta1836-cii-8-14", "agostinho", "San Agustín",
          title="Compasivo es el Señor y benigno",
          why="El salmo describe el carácter de Dios antes de hablar del enojo: la medida de la ira se toma de ahí.",
          saint_why="Escribió a un funcionario pidiendo que no se torturara ni ejecutara a hombres que habían matado a un sacerdote de su diócesis.",
          step="Pide hoy que se haga justicia sin pedir que alguien sufra."),

        e("ta1836-iv-5", "filipe-neri", "San Felipe Neri",
          title="Compungíos",
          why="La palabra del salmo es compungirse: el enojo se examina, y el examen tiene fin.",
          saint_why="Se le atribuye haber dicho que quien no corrige su propio genio no llegará a nada, y trabajaba el suyo con humor.",
          step="Ríete hoy de tu propia reacción, sin excusarla."),

        e("ta1836-xlv-10-12", "clara-assis", "Santa Clara de Asís",
          title="El Señor de los ejércitos está con nosotros",
          why="El salmo dice que está con nosotros, en plural: la ira que aísla se corrige recordando de qué lado se está.",
          saint_why="Frente a las tropas que amenazaban su monasterio salió con el Santísimo y sin ningún arma.",
          step="Habla hoy de esto con alguien que no esté enojado."),

        e("ta1836-cii-8-14", "padre-pio", "San Pío de Pietrelcina",
          title="Cuanta es la elevación del cielo",
          why="El salmo mide la clemencia por la altura del cielo sobre la tierra: una escala que ninguna ofensa alcanza.",
          saint_why="Era brusco en el confesionario y él mismo pedía perdón por su carácter en sus cartas.",
          step="Pide hoy perdón por el tono, aunque tengas razón en el fondo."),
    ],

    "dryness": [
        e("ta1836-lxxvi-8-13", "joao-cruz", "San Juan de la Cruz",
          title="¿Ha de abandonar para siempre?",
          why="El salmo hace la pregunta dentro de la oración: la sequedad puede preguntar si Dios se fue, y seguir rezando.",
          saint_why="Describió la noche del espíritu como purificación, y advirtió que no se mide por el gusto que se siente.",
          step="Reza hoy el tiempo que tenías previsto, sin alargarlo ni acortarlo."),

        e("ta1836-xxvi-4-5", "teresa-avila", "Santa Teresa de Jesús",
          title="Una sola cosa solicitaré",
          why="Cuando no hay nada que sentir, el salmo reduce la oración a una petición sola: quedarse en la casa.",
          saint_why="Contó que pasó cerca de veinte años con la oración áspera y sin consuelo, y que nunca la dejó.",
          step="Lee hoy un solo versículo y quédate en él."),

        e("ta1836-lxii-2-5", "isabel-trindade", "Santa Isabel de la Trinidad",
          title="Como si me hallara en el Santuario",
          why="El salmo dice que en tierra sin agua se pone en presencia como si estuviera en el templo: la sequedad no cancela el lugar.",
          saint_why="Escribió que la fe no necesita sentir para ser verdadera, y lo escribió estando enferma.",
          step="Reza hoy de rodillas, aunque no sientas nada al hacerlo."),

        e("ta1836-iv-2", "padre-pio", "San Pío de Pietrelcina",
          title="Presta oídos a mi oración",
          why="El salmo pide ser oído, no ser consolado: la sequedad solo necesita seguir hablando.",
          saint_why="Escribió a su director espiritual que a veces no sentía nada al celebrar, y celebraba igual.",
          step="Reza hoy en voz alta, aunque suene vacío."),

        e("ta1836-xxvi-7-10", "teresinha", "Santa Teresita del Niño Jesús",
          title="No apartes de mí tu rostro",
          why="El salmista pide el rostro que no ve: la sequedad se dirige a lo ausente y lo llama por su nombre.",
          saint_why="Dijo que en su último año la fe le parecía un muro y que cantaba lo que quería creer, no lo que sentía.",
          step="Di hoy lo que quieres creer, no lo que sientes."),

        e("ta1836-lxxvi-2-4", "monica", "Santa Mónica",
          title="Acordéme de Dios",
          why="El salmo sale de la sequedad por la memoria: se acuerda, medita, y solo entonces siente algo.",
          saint_why="Perseveró rezando por lo mismo durante casi treinta años sin ver resultado.",
          step="Recuerda hoy cómo rezabas hace diez años, y reza así."),

        e("ta1836-xxxv-6-10", "tomas-aquino", "Santo Tomás de Aquino",
          title="Abismo profundísimo tus juicios",
          why="El salmo llama abismo a los juicios de Dios: lo que no se entiende no es señal de ausencia.",
          saint_why="Después de diciembre de 1273 dijo que todo lo escrito le parecía paja, y dejó la Suma sin terminar.",
          step="Acepta hoy no entender, y no busques explicación."),

        e("ta1836-cxlii-3-5", "edith-stein", "Santa Teresa Benedicta de la Cruz",
          title="Púseme a meditar tus obras",
          why="El salmo responde a la zozobra con trabajo de memoria: medita las obras, no busca sentimiento.",
          saint_why="Tradujo y estudió durante años en un colegio de provincias, lejos de la cátedra que no le dieron.",
          step="Estudia hoy diez minutos de catecismo o de Escritura."),

        e("ta1836-lxii-2-5", "damiao-molokai", "San Damián de Molokai",
          title="De cuántas maneras lo está mi cuerpo",
          why="El salmo dice que también el cuerpo tiene sed: la sequedad se atiende con descanso y comida, no solo con oración.",
          saint_why="Trabajó años con pocas fuerzas y siguió celebrando la Misa diaria hasta las últimas semanas.",
          step="Duerme hoy lo que necesitas antes de juzgar tu oración."),

        e("ta1836-xxvi-4-5", "benito", "San Benito",
          title="Todos los días de mi vida",
          why="El salmo pide vivir en la casa todos los días: la sequedad se atraviesa por permanencia, no por intensidad.",
          saint_why="Su Regla manda rezar las mismas horas cada día, tanto en la consolación como en la aridez.",
          step="Mantén hoy el horario de oración sin moverlo ni un minuto."),

        e("ta1836-lxxvi-8-13", "agostinho", "San Agustín",
          title="Entonces dije",
          why="El salmista interrumpe sus propias preguntas con una decisión: recordar las obras antiguas. La sequedad se corta con un acto.",
          saint_why="Escribió que su corazón estuvo inquieto muchos años antes de encontrar descanso, y contó ese tiempo sin adornarlo.",
          step="Escribe hoy una frase que decidas creer, y fírmala."),

        e("ta1836-iv-2", "notburga", "Santa Notburga",
          title="Oyóme Dios",
          why="El salmo afirma en pasado que fue oído: cuando no se siente nada, queda lo que ya ocurrió.",
          saint_why="Se la recuerda por rezar en medio del trabajo del campo, sin tiempos largos de silencio.",
          step="Reza hoy mientras trabajas, con una frase repetida."),

        e("ta1836-xxvi-7-10", "andre-bessette", "San Andrés Bessette",
          title="Sé tú en mi ayuda",
          why="La petición es de ayuda, no de consuelo: la sequedad pide que alguien sostenga, no que se sienta bien.",
          saint_why="Rezaba siempre las mismas oraciones sencillas y las recomendaba a todos, sin prometer experiencias.",
          step="Reza hoy solo un Padrenuestro, despacio."),

        e("ta1836-xxxv-6-10", "francisco-assis", "San Francisco de Asís",
          title="Hasta las nubes tu verdad",
          why="El salmo mide la misericordia por el cielo y las nubes: cuando falta el sentimiento, queda mirar lo creado.",
          saint_why="Compuso el Cántico de las Criaturas casi ciego, en San Damián, en un tiempo de enfermedad y conflicto interno.",
          step="Reza hoy mirando el cielo durante cinco minutos."),

        e("ta1836-lxxvi-2-4", "joao-paulo-ii", "San Juan Pablo II",
          title="Y no quedé burlado",
          why="El salmo dice que levantó las manos de noche y no fue defraudado: la sequedad se responde con gesto, no con ganas.",
          saint_why="Mantuvo la oración de la mañana toda su vida, también en los años en que trabajaba en la cantera y la fábrica.",
          step="Reza hoy de pie, con las manos levantadas, un solo salmo."),
    ],
}
