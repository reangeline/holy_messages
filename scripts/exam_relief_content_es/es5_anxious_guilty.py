# -*- coding: utf-8 -*-
"""Español — desolación: anxious y guilty.

`guilty` tiene 5 pasajes curados para 15 lecturas (3× cada uno, con santo y
ángulo distintos). La regla pastoral vale igual que en portugués e inglés:
ninguna lectura refuerza la acusación ni pide más escrúpulo. Los salmos
elegidos son los del perdón ya concedido y los del clamor oído; el paso
concreto empuja a la confesión o a la reparación, nunca a la vigilancia
interior sin salida.
"""

from exam_relief_content_es._shared import e

BLOCK = {
    "anxious": [
        e("ta1836-liv-23", "padre-pio", "San Pío de Pietrelcina",
          title="Arroja tus ansiedades",
          why="El verbo es arrojar, no dominar: el salmo manda entregar el peso, no dejar de sentirlo.",
          saint_why="Respondía a quien le escribía angustiado con una frase suya: reza, espera y no te agites.",
          step="Escribe tu preocupación en un papel y guárdalo cerrado hasta mañana."),

        e("ta1836-liv-3-9", "edith-stein", "Santa Teresa Benedicta de la Cruz",
          title="El pavor me ha sobrecogido",
          why="El salmista describe el temblor en el pecho sin disculparse: la angustia entra entera en la oración.",
          saint_why="Escribió sobre la vida interior en los últimos años antes de su deportación, sabiendo lo que se acercaba.",
          step="Di hoy en voz alta lo que temes, con esas palabras."),

        e("ta1836-xc-1-4", "jose", "San José",
          title="Debajo de sus alas",
          why="El salmo promete sombra y refugio, no retirada del peligro: el lazo de los cazadores existe.",
          saint_why="Según Mateo cambió de destino al volver de Egipto, avisado de que Judea seguía siendo insegura.",
          step="Toma hoy una decisión práctica de precaución, y solo una."),

        e("ta1836-xxx-2-6", "joao-paulo-ii", "San Juan Pablo II",
          title="Acude prontamente",
          why="El salmista pide prisa: la angustia puede pedir el plazo corto sin dejar de ser oración.",
          saint_why="Dijo en 1978, al empezar su pontificado, unas palabras sobre no tener miedo, al abrir las puertas.",
          step="Reza hoy una oración corta tres veces en el día, no una larga."),

        e("ta1836-cxlii-3-5", "joao-cruz", "San Juan de la Cruz",
          title="Me acordé de los días antiguos",
          why="El salmo sale de la angustia por la memoria, no por el análisis: recuerda y medita lo hecho antes.",
          saint_why="Escribió los poemas del Cántico en la cárcel de Toledo y los completó ya libre.",
          step="Recuerda hoy una dificultad pasada que se resolvió, y di cómo."),

        e("ta1836-lv-9-13", "monica", "Santa Mónica",
          title="Tienes presentes mis lágrimas",
          why="El salmo dice que las lágrimas están contadas conforme a la promesa: la angustia no cae al vacío.",
          saint_why="Lloró durante años por su hijo, y un obispo le dijo que no era posible que ese hijo se perdiera.",
          step="Llora hoy si te viene, sin interrumpirlo."),

        e("ta1836-lvi-2-4", "josefina-bakhita", "Santa Josefina Bakhita",
          title="Ten piedad de mí",
          why="El salmo repite la petición dos veces en una línea: la angustia no necesita variar las palabras.",
          saint_why="Contó su historia sin resentimiento a las novicias, y decía que si no la hubieran raptado no habría conocido a Cristo.",
          step="Repite hoy la misma jaculatoria mientras caminas."),

        e("ta1836-xc-14-16", "maximiliano-kolbe", "San Maximiliano María Kolbe",
          title="Con él estoy en la tribulación",
          why="La promesa es de compañía dentro, no de rescate antes: la angustia se atraviesa acompañada.",
          saint_why="Sostuvo a los hombres encerrados con él en el búnker del hambre durante los días que duró.",
          step="Acompaña hoy a alguien que está peor que tú, sin aconsejarle nada."),

        e("ta1836-xlv-2-3", "teresa-avila", "Santa Teresa de Jesús",
          title="Refugio y fortaleza",
          why="El salmo declara el refugio antes de nombrar el temblor de la tierra: primero el amparo, después el miedo.",
          saint_why="Escribió que la oración es trato de amistad, y que la paciencia todo lo alcanza.",
          step="Reza hoy en un lugar donde te sientas seguro, aunque sea el coche."),

        e("ta1836-xxx-8-9", "francisco-assis", "San Francisco de Asís",
          title="Abriste ancho camino",
          why="El salmo agradece el espacio dado a los pies: la angustia se alivia por ensanchamiento, no por explicación.",
          saint_why="Renunció públicamente a los bienes de su padre en la plaza de Asís y vivió del trabajo y la limosna.",
          step="Sal hoy a caminar veinte minutos sin destino."),

        e("ta1836-lv-4-5", "rita-cassia", "Santa Rita de Casia",
          title="Nada temeré de los mortales",
          why="El salmista teme desde el amanecer y aun así dice que confía: las dos frases están pegadas.",
          saint_why="Insistió durante años en ser admitida en el monasterio de Casia, después de que la rechazaran.",
          step="Vuelve hoy a pedir una cosa que te negaron."),

        e("ta1836-iv-2", "antonio-padua", "San Antonio de Padua",
          title="Me ensanchaste el corazón",
          why="El salmo dice que en la angustia el corazón fue ensanchado: el apuro es el lugar del alivio, no su obstáculo.",
          saint_why="Fue enviado a tareas humildes en Forlì antes de que se descubriera su formación y empezara a predicar.",
          step="Respira hoy despacio diez veces antes de contestar un mensaje difícil."),

        e("ta1836-lxxvi-2-4", "isabel-trindade", "Santa Isabel de la Trinidad",
          title="Levanté por la noche mis manos",
          why="El salmo sitúa la oración en la noche y admite que el alma se negaba a todo consuelo.",
          saint_why="Pasó sus últimas semanas con dolores intensos y siguió escribiendo cartas breves a su familia.",
          step="Reza hoy de noche, de pie, con las manos abiertas."),

        e("ta1836-cxx-5-8", "andre-bessette", "San Andrés Bessette",
          title="Ni de día el sol",
          why="El salmo cubre los dos peligros, el del día y el de la noche: a la angustia le responde con horarios, no con razones.",
          saint_why="Recibía a los visitantes en la portería y los mandaba rezar a San José, sin prometer resultados.",
          step="Deja hoy el teléfono fuera del cuarto al dormir."),

        e("ta1836-cxxvi-1-2", "benito", "San Benito",
          title="Levantaos después de haber descansado",
          why="El salmo corrige el desvelo: manda dormir primero y trabajar después. La angustia se combate también con sueño.",
          saint_why="Su Regla fija horas de descanso y prohíbe al abad imponer cargas que quiebren al débil.",
          step="Acuéstate hoy media hora antes de lo habitual."),
    ],

    "guilty": [
        e("ta1836-xxxi-5", "agostinho", "San Agustín",
          title="Tú perdonaste",
          why="En el salmo la confesión y el perdón ocurren en la misma frase: no hay plazo de prueba entre las dos.",
          saint_why="Contó por escrito sus propias faltas ya obispo, no para castigarse, sino para narrar la misericordia.",
          step="Apunta hoy el día y la hora en que irás a confesarte."),

        e("ta1836-xxxi-1-2", "pedro-paulo", "San Pedro",
          title="A quien no arguye de pecado",
          why="El salmo llama dichoso al que ya no es acusado: quien fue perdonado deja de estar bajo cargo.",
          saint_why="Fue confirmado como pastor después de su negación, no a pesar de ella según el relato de Juan.",
          step="Deja hoy de releer mentalmente una falta ya confesada."),

        e("ta1836-cxxix-1-8", "padre-pio", "San Pío de Pietrelcina",
          title="¿Quién podrá subsistir?",
          why="El salmo dice que nadie resistiría el examen: la culpa deja de ser una medida personal y pasa a ser común.",
          saint_why="Confesaba muchas horas al día y era conocido por ser breve con quien volvía sobre lo ya absuelto.",
          step="Cuenta hoy tu falta una sola vez, a un confesor, y no más."),

        e("ta1836-vi-3-5", "maria-madalena", "Santa María Magdalena",
          title="Sálvame por tu misericordia",
          why="El salmista pide por la misericordia, no por su arrepentimiento: el motivo del perdón está en Dios.",
          saint_why="En Lucas es descrita entre las mujeres que habían sido curadas y seguían a Jesús sosteniendo el grupo.",
          step="Reza hoy un acto de contrición y no lo repitas después."),

        e("ta1836-iv-5", "inacio-loyola", "San Ignacio de Loyola",
          title="En el retiro de vuestros lechos",
          why="El salmo manda examinar en silencio y no pecar más: mira hacia adelante, no hacia el recuento del daño.",
          saint_why="Escribió reglas contra el escrúpulo: mandaba no volver sobre lo ya juzgado y desconfiar de la tristeza que paraliza.",
          step="Haz hoy el examen de cinco minutos y ciérralo con una decisión."),

        e("ta1836-xxxi-5", "monica", "Santa Mónica",
          title="Dejé de ocultar mi injusticia",
          why="Lo que el salmo cambia no es la falta, es el silencio: dejar de esconder ya es el giro.",
          saint_why="Habló abiertamente con Ambrosio sobre su hijo en lugar de guardarse el problema.",
          step="Pide hoy consejo a una persona sabia sobre esto, sin adornar el relato."),

        e("ta1836-xxxi-1-2", "vicente-paulo", "San Vicente de Paúl",
          title="Se han perdonado sus iniquidades",
          why="El salmo usa el pasado: la bienaventuranza es de quien ya recibió, no de quien todavía lo intenta.",
          saint_why="Insistía en que a los pobres se los sirve sin pedirles cuentas de su conducta previa.",
          step="Sirve hoy a alguien sin juzgar cómo llegó a su situación."),

        e("ta1836-cxxix-1-8", "joao-cruz", "San Juan de la Cruz",
          title="Desde lo más profundo clamé",
          why="El clamor sale del fondo: el salmo no pide subir primero para poder ser oído.",
          saint_why="Escribió que hay que pasar de la meditación a la simple atención, y que el alma no debe medirse por lo que siente.",
          step="Reza hoy sin examinar lo que sientes al rezar."),

        e("ta1836-vi-3-5", "rita-cassia", "Santa Rita de Casia",
          title="Sáname, Señor",
          why="El salmista pide sanación, no castigo: trata la culpa como herida que requiere cura.",
          saint_why="Cuidó en su casa a su marido violento y, tras su muerte, pidió entrar en el monasterio sin exigir reparación.",
          step="Pide hoy perdón a una persona concreta, en una frase."),

        e("ta1836-iv-5", "jose-sanchez-del-rio", "San José Sánchez del Río",
          title="No queráis pecar más",
          why="El salmo se cierra con un propósito simple: no repetir. No pide sentir más remordimiento.",
          saint_why="Muerto a los catorce años en Sahuayo, en 1928; su carta a su madre pide que no llore por él.",
          step="Quita hoy una ocasión concreta: borra, bloquea o cambia de camino."),

        e("ta1836-xxxi-5", "joao-batista", "San Juan Bautista",
          title="Confesaré contra mí mismo",
          why="El salmista se acusa él, sin que otro lo acuse: la confesión es un acto propio, y termina.",
          saint_why="Predicó la penitencia junto al Jordán y remitió a otro a quienes lo seguían, sin quedarse con ellos.",
          step="Confiesa hoy lo concreto, sin explicar los motivos."),

        e("ta1836-xxxi-1-2", "josefina-bakhita", "Santa Josefina Bakhita",
          title="Se han borrado",
          why="El salmo dice borrados, no perdonados a medias: lo quitado no queda en el registro.",
          saint_why="Perdonó a quienes la habían esclavizado y decía que les besaría las manos, porque así conoció a Dios.",
          step="Escribe la falta en un papel, tacha la palabra y tira el papel."),

        e("ta1836-cxxix-1-8", "oscar-romero", "San Óscar Romero",
          title="En ti se halla la clemencia",
          why="El salmo sitúa la clemencia como cosa estable en Dios: la culpa se mide contra ella, no contra uno mismo.",
          saint_why="Predicaba la conversión sin exceptuarse, y decía en público que también él debía cambiar.",
          step="Repara hoy una cosa concreta que dañaste, aunque sea pequeña."),

        e("ta1836-vi-3-5", "teresinha", "Santa Teresita del Niño Jesús",
          title="Hasta mis huesos se han estremecido",
          why="El salmo admite el desgaste del cuerpo por la culpa, y pide vuelta y rescate, no penitencia añadida.",
          saint_why="Enseñó a ofrecer las propias faltas y no a esconderlas, comparándose con un niño que cae y vuelve a levantarse.",
          step="Trátate hoy como tratarías a un amigo que hizo lo mismo."),

        e("ta1836-iv-5", "filipe-neri", "San Felipe Neri",
          title="Compungíos, y basta",
          why="El salmo manda compungirse en el retiro de la noche: una vez, en su hora, y no todo el día.",
          saint_why="Mandaba a los escrupulosos tareas ridículas y prohibía la tristeza prolongada por las propias faltas.",
          step="Haz hoy una cosa que te dé alegría, sin sentirte en deuda."),
    ],
}
