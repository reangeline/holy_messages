# -*- coding: utf-8 -*-
"""Español — consolación: forgiven y loved.

`forgiven` tiene 6 pasajes curados para 15 lecturas, así que hay repetición
forzada de salmo (hasta 3×). Cada repetición cambia de santo y de ángulo: el
Salmo XXXI, por ejemplo, se lee una vez por la dicha del perdonado, otra por
el acto de confesar, otra por lo que deja de pesar.
"""

from exam_relief_content_es._shared import e

BLOCK = {
    "forgiven": [
        e("ta1836-xxxi-1-2", "agostinho", "San Agustín",
          title="Dichoso el hombre",
          why="El salmo llama feliz al perdonado, no al que nunca cayó: la bienaventuranza empieza después de la falta.",
          saint_why="Escribió las Confesiones ya obispo, contando por escrito lo que había hecho en lugar de dejarlo atrás en silencio.",
          step="Escribe una línea sobre algo que ya confesaste y quema el papel."),

        e("ta1836-xxxi-5", "monica", "Santa Mónica",
          title="Dejé de ocultar",
          why="El movimiento del salmo es dejar de esconder: el perdón llega cuando termina el disimulo, no antes.",
          saint_why="Vio a su hijo bautizado en Milán en 387, después de años en que la conversión no parecía llegar.",
          step="Dile hoy a una persona de confianza una cosa que has estado escondiendo."),

        e("ta1836-cii-1-5", "maria-madalena", "Santa María Magdalena",
          title="No olvides sus beneficios",
          why="El salmo pone el perdón en una lista con la salud y el rescate: es un beneficio recibido, no un premio ganado.",
          saint_why="Los cuatro Evangelios la nombran entre las mujeres que estuvieron junto a la cruz y fueron al sepulcro.",
          step="Enumera hoy tres cosas por las que ya fuiste perdonado."),

        e("ta1836-cii-8-14", "joao-paulo-ii", "San Juan Pablo II",
          title="Tardo en airarse",
          why="El salmo mide la clemencia por la distancia del cielo a la tierra: el perdón se describe por su tamaño, no por su condición.",
          saint_why="En 1983 visitó en la cárcel al hombre que le había disparado dos años antes, y habló con él a solas.",
          step="Escribe el nombre de quien te ofendió y reza un Padrenuestro por él."),

        e("ta1836-cxxix-1-8", "padre-pio", "San Pío de Pietrelcina",
          title="En ti se halla la clemencia",
          why="El salmo dice que nadie subsistiría si Dios examinara: el perdón no se apoya en el mérito de quien clama.",
          saint_why="Pasó décadas oyendo confesiones muchas horas al día, en el convento de San Giovanni Rotondo.",
          step="Marca hoy el día y la hora de tu próxima confesión."),

        e("ta1836-xxxi-1-2", "pedro-paulo", "San Pedro",
          title="Se han borrado tus pecados",
          why="El verbo del salmo es borrar, no disculpar: lo que se quitó no vuelve a leerse.",
          saint_why="En el Evangelio de Juan es interrogado tres veces junto al lago, tras haber negado tres veces.",
          step="Deja hoy de repetirte una acusación que ya confesaste."),

        e("ta1836-xxxi-5", "joao-cruz", "San Juan de la Cruz",
          title="Confesaré contra mí mismo",
          why="El salmista se acusa a sí mismo y en la misma frase es perdonado: en el salmo las dos cosas no están separadas por el tiempo.",
          saint_why="Fue encarcelado por sus propios hermanos de Orden en 1577 y escapó de la celda de Toledo nueve meses después.",
          step="Examina hoy el día concreto de ayer, no tu vida entera."),

        e("ta1836-cii-1-5", "vicente-paulo", "San Vicente de Paúl",
          title="Quien sana tus dolencias",
          why="Perdonar y sanar aparecen como un mismo acto: el salmo no divide el alma del cuerpo cansado.",
          saint_why="Organizó en Francia las Damas de la Caridad y luego las Hijas de la Caridad para atender a enfermos y expósitos.",
          step="Cuida hoy de tu cuerpo en una cosa que llevas descuidando."),

        e("ta1836-xxxi-7-11", "teresa-avila", "Santa Teresa de Jesús",
          title="Te enseñaré el camino",
          why="Después del perdón el salmo promete instrucción: no termina en el alivio, sigue en el camino a seguir.",
          saint_why="Escribió el Camino de perfección para sus monjas, y en el Libro de la vida contó sus propios años de oración estancada.",
          step="Elige una cosa concreta que harás distinto mañana."),

        e("ta1836-cxxix-1-8", "jose-sanchez-del-rio", "San José Sánchez del Río",
          title="Esperó mi alma en su palabra",
          why="El salmo espera más que los centinelas la mañana: el perdonado sigue esperando, ahora sin miedo.",
          saint_why="Muerto en Sahuayo en 1928, a los catorce años, durante la persecución religiosa en México.",
          step="Reza hoy al despertar, antes de mirar cualquier pantalla."),

        e("ta1836-cii-8-14", "rita-cassia", "Santa Rita de Casia",
          title="No durará para siempre su enojo",
          why="El salmo pone plazo a la ira y no a la clemencia: el perdón se describe por lo que no persiste.",
          saint_why="Intercedió para que su familia no vengara el asesinato de su marido, y perdonó públicamente a los responsables.",
          step="Deja hoy sin respuesta una provocación pequeña."),

        e("ta1836-xxxi-1-2", "andre-bessette", "San Andrés Bessette",
          title="Exenta de dolo",
          why="El salmo describe el alma perdonada como libre de engaño: lo que se fue no es solo la culpa, es el disimulo.",
          saint_why="Atendió durante años a visitantes en la portería del Colegio Notre-Dame, en Montreal, uno por uno.",
          step="Di hoy una verdad pequeña que te era cómodo omitir."),

        e("ta1836-xxxi-5", "notburga", "Santa Notburga",
          title="Perdonaste la malicia",
          why="El salmo nombra la malicia y la nombra perdonada: no suaviza lo que hubo para poder decir que pasó.",
          saint_why="Sirvienta en el Tirol, se la recuerda por repartir entre los pobres la comida que le sobraba, contra la orden de su patrón.",
          step="Devuelve o repara hoy una cosa pequeña que debías."),

        e("ta1836-cii-1-5", "benito", "San Benito",
          title="Bendice, alma mía",
          why="El salmo ordena al alma bendecir: el perdonado responde alabando, no explicándose.",
          saint_why="Escribió una Regla que pone la oración común en el centro del día y limita la severidad del abad.",
          step="Reza hoy un salmo a la misma hora en que lo rezaste ayer."),

        e("ta1836-xxxi-7-11", "filipe-neri", "San Felipe Neri",
          title="Alegraos en el Señor",
          why="El salmo termina mandando alegrarse y gloriarse: el perdón desemboca en alegría, no en vigilancia.",
          saint_why="Reunía a gente de todas las condiciones en el Oratorio de Roma para oración, música y conversación.",
          step="Invita hoy a alguien a rezar contigo, aunque sea cinco minutos."),
    ],

    "loved": [
        e("ta1836-cxxxviii-5-8", "teresinha", "Santa Teresita del Niño Jesús",
          title="Tú me formaste",
          why="El salmo dice que la mano vino antes que el conocimiento propio: se es amado desde antes de saberlo.",
          saint_why="Llamó a su camino el de la confianza y el abandono, y lo describió como el de un niño en brazos.",
          step="Di hoy en voz alta: fui querido antes de merecerlo."),

        e("ta1836-cii-8-14", "josefina-bakhita", "Santa Josefina Bakhita",
          title="Como un padre se apiada",
          why="El salmo compara la clemencia con la de un padre con sus hijos: el amor aquí se dice por comparación familiar.",
          saint_why="Secuestrada de niña en Darfur, decía llamar «amo» solo a Dios, y trató siempre con dulzura a quienes la habían comprado.",
          step="Trata hoy con paciencia a la persona que más te irrita."),

        e("ta1836-xxvi-7-10", "isabel-trindade", "Santa Isabel de la Trinidad",
          title="Tu cara es la que yo busco",
          why="El salmo pide el rostro, no un favor: el amor se describe como deseo de presencia.",
          saint_why="Escribió una oración a la Trinidad pidiendo quedarse quieta ante Dios «como si mi alma ya estuviera en la eternidad».",
          step="Quédate hoy cinco minutos en silencio sin pedir nada."),

        e("ta1836-iv-7", "carlo-acutis", "San Carlo Acutis",
          title="Sobre nosotros",
          why="El salmo dice la luz impresa sobre nosotros, en plural: el amor recibido no es privado.",
          saint_why="Catalogó milagros eucarísticos en un sitio web y murió de leucemia en Monza en 2006, a los quince años.",
          step="Manda hoy un mensaje a alguien solo para decirle algo bueno."),

        e("ta1836-cii-1-5", "damiao-molokai", "San Damián de Molokai",
          title="Te corona de misericordias",
          why="El salmo habla de corona: el amor se describe como algo puesto encima, visible, no interior y secreto.",
          saint_why="Se quedó en Molokai después de contraer él mismo la lepra, y siguió sirviendo hasta su muerte en 1889.",
          step="Haz hoy por alguien la tarea que nadie quiere hacer."),

        e("ta1836-lvi-2-4", "clara-assis", "Santa Clara de Asís",
          title="A la sombra de tus alas",
          why="El salmo pide no ser librado, sino esperar bajo el ala hasta que pase: el amor aquí es cobijo durante.",
          saint_why="Obtuvo del Papa el privilegio de la pobreza para San Damián y lo defendió durante décadas.",
          step="Pide hoy que te acompañen, no que te resuelvan."),

        e("ta1836-cxxxvii-1-3", "antonio-padua", "San Antonio de Padua",
          title="Oíste las peticiones de mi boca",
          why="La alabanza tiene motivo concreto: fue oído. El amor se reconoce en algo que ocurrió, no en un sentimiento.",
          saint_why="Se le encomienda popularmente lo perdido, por un episodio con un salterio que le fue robado en Bolonia.",
          step="Recuerda hoy una oración tuya que fue respondida y agradécela."),

        e("ta1836-xcix-2-5", "joao-bosco", "San Juan Bosco",
          title="Él es quien nos hizo",
          why="El salmo dice que no nos hicimos a nosotros mismos: el amor precede a todo lo que uno consiga por su cuenta.",
          saint_why="Recogió a muchachos sin oficio en Turín y les enseñó trabajo, catecismo y música al mismo tiempo.",
          step="Elogia hoy a alguien por lo que es, no por lo que hizo."),

        e("ta1836-xxvi-7-10", "oscar-romero", "San Óscar Romero",
          title="No me desampares",
          why="El salmista pide no ser abandonado justo después de decir que sus ojos lo buscan: el amor se pide, no se presume.",
          saint_why="Leía en la radio los nombres de los desaparecidos de la semana, uno por uno, en su homilía dominical.",
          step="Reza hoy por alguien cuyo nombre casi nadie recuerda."),

        e("ta1836-cii-1-5", "notburga", "Santa Notburga",
          title="Quien rescata tu vida",
          why="El salmo enumera rescates concretos: el amor se cuenta por lo que hizo, en una lista.",
          saint_why="Fue despedida por dar comida a los pobres y readmitida más tarde por el mismo patrón.",
          step="Da hoy una cosa tuya que te sirva y no te sobre."),

        e("ta1836-lvi-2-4", "maximiliano-kolbe", "San Maximiliano María Kolbe",
          title="Envió desde el cielo a librarme",
          why="El salmo habla de un envío: el amor que describe llega de fuera, en auxilio, y no se genera por dentro.",
          saint_why="Fundó Niepokalanów, una de las mayores comunidades franciscanas de su tiempo, con imprenta propia.",
          step="Acepta hoy la ayuda que te ofrecieron y estabas rechazando."),

        e("ta1836-cxxxvii-1-3", "monica", "Santa Mónica",
          title="Con todo mi corazón",
          why="La alabanza es entera y con nombre propio: en el salmo el amor recibido se agradece en persona.",
          saint_why="Pidió a su hijo solo que la recordara en el altar, sin exigir nada más para su sepultura.",
          step="Reza hoy por un familiar tuyo que ya murió."),

        e("ta1836-lxii-2-5", "teresa-avila", "Santa Teresa de Jesús",
          title="A ti aspiro desde la aurora",
          why="El salmo dice que el cuerpo también está sediento: el amor se describe con sed, incluso en tierra sin agua.",
          saint_why="Fundó diecisiete conventos viajando por Castilla y Andalucía, ya mayor y con mala salud.",
          step="Empieza hoy el día con una frase de oración antes de levantarte."),

        e("ta1836-xxxv-6-10", "francisco-assis", "San Francisco de Asís",
          title="A hombres y bestias conservas",
          why="El salmo incluye a los animales en el cuidado de Dios: el amor que describe es más ancho que uno.",
          saint_why="Su Cántico llama hermanos al sol, al viento y al agua, y hermana a la muerte corporal.",
          step="Cuida hoy de un animal o de una planta con atención."),

        e("ta1836-iv-7", "luis-gonzaga", "San Luis Gonzaga",
          title="Has infundido la alegría",
          why="La alegría es infundida por otro: el salmo la trata como señal del amor recibido, no como su prueba.",
          saint_why="Murió en Roma a los veintitrés años tras contagiarse cuidando enfermos de peste.",
          step="Sirve hoy a un enfermo, aunque sea con una llamada."),
    ],
}
