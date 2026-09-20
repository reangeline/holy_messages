# -*- coding: utf-8 -*-
"""Español — steadfast (consolación) y empty (desolación).

`empty` tiene solo 4 pasajes curados para 15 lecturas: cada salmo vuelve
hasta cuatro veces, siempre con otro santo y otro ángulo. La curaduría eligió
pasajes de sed y de morada — no de reproche —, porque el vacío no se trata
aquí como falta de esfuerzo.
"""

from exam_relief_content_es._shared import e

BLOCK = {
    "steadfast": [
        e("ta1836-xlv-2-3", "tomas-aquino", "Santo Tomás de Aquino",
          title="Aun cuando se conmueva la tierra",
          why="El salmo no promete que nada se mueva: promete no temer mientras se mueve.",
          saint_why="Sostuvo que la fe y la razón no se contradicen, y discutió por escrito con quienes lo negaban.",
          step="Escribe la razón por la que sigues en esto, en una sola frase."),

        e("ta1836-xxii-4-6", "martinho-tours", "San Martín de Tours",
          title="Tu vara y tu báculo",
          why="El consuelo del salmo es el instrumento del pastor: la firmeza viene de ser conducido, no de tener fuerzas.",
          saint_why="Fundó Ligugé y Marmoutier y siguió viviendo como monje después de ser hecho obispo.",
          step="Sigue hoy un consejo que ya recibiste y no aplicaste."),

        e("ta1836-cxx-5-8", "jose", "San José",
          title="En todos los pasos de tu vida",
          why="El salmo cubre el día y la noche, el sol y la luna: la guarda que describe no tiene turnos libres.",
          saint_why="Los Evangelios no le atribuyen ninguna palabra; lo describen solo por lo que hizo por el niño y su madre.",
          step="Haz hoy bien tu trabajo sin contárselo a nadie."),

        e("ta1836-lxi-2-3", "inacio-loyola", "San Ignacio de Loyola",
          title="No seré jamás conmovido",
          why="La firmeza se apoya en quién es Dios, no en la constancia del salmista: él solo se mantiene sometido.",
          saint_why="Cambió de plan varias veces — Jerusalén, los estudios, Roma — sin abandonar el propósito de fondo.",
          step="Revisa hoy tu decisión principal y confírmala o cámbiala por escrito."),

        e("ta1836-xc-10-12", "joao-paulo-ii", "San Juan Pablo II",
          title="Te llevarán en sus manos",
          why="El salmo promete guarda en los pasos, no ausencia de piedras: la firmeza convive con el tropiezo posible.",
          saint_why="Siguió gobernando y viajando con Parkinson avanzado, con la voz y el andar visiblemente afectados.",
          step="Haz hoy una cosa que vienes postergando por miedo a hacerla mal."),

        e("ta1836-xxx-2-6", "edith-stein", "Santa Teresa Benedicta de la Cruz",
          title="Alcázar de refugio",
          why="El salmo pide ser puesto en salvo y llama a Dios fortaleza: la firmeza se pide, no se declara.",
          saint_why="Pidió quedarse con su pueblo y rechazó los planes de fuga que se le propusieron en 1942.",
          step="Nombra hoy en la oración la cosa concreta que te da miedo."),

        e("ta1836-cxxvi-1-2", "benito", "San Benito",
          title="En vano se fatigan",
          why="El salmo corrige el exceso de esfuerzo: manda levantarse después de haber descansado.",
          saint_why="Su Regla reparte el día en oración, trabajo y lectura, y pone medida también al ayuno.",
          step="Define hoy la hora en que vas a parar de trabajar, y párate."),

        e("ta1836-lv-4-5", "padre-pio", "San Pío de Pietrelcina",
          title="Desde que apunta el día",
          why="El salmista admite que teme desde que amanece y en la misma línea dice que confía: la firmeza no excluye el miedo.",
          saint_why="Escribió en sus cartas sobre años de angustia interior, mientras confesaba a cientos de personas.",
          step="Reza hoy en el primer momento en que sientas miedo, sin esperar a la noche."),

        e("ta1836-xlv-10-12", "clara-assis", "Santa Clara de Asís",
          title="Estad tranquilos",
          why="El mandato es estar quietos y considerar: la firmeza del salmo empieza por dejar de agitarse.",
          saint_why="Cuando las tropas amenazaron San Damián en 1240 salió con el Santísimo ante la comunidad, sin armas.",
          step="Quédate hoy diez minutos sentado sin hacer nada más."),

        e("ta1836-lxxxiii-11-13", "notburga", "Santa Notburga",
          title="El ínfimo en la Casa de Dios",
          why="El salmista escoge ser el último dentro: la firmeza se dice como preferencia de lugar, no como resistencia.",
          saint_why="Fue sirvienta toda su vida y nunca tuvo cargo alguno; se la representa con la hoz y el pan.",
          step="Haz hoy la tarea más humilde de tu casa sin delegarla."),

        e("ta1836-lvi-2-4", "josefina-bakhita", "Santa Josefina Bakhita",
          title="Hasta que pase la iniquidad",
          why="El salmo mide la espera por la duración del mal, no por la del que espera: hay un final, y no depende de él.",
          saint_why="Declaró ante el tribunal de Venecia, en 1889, que quería quedarse; la ley italiana no reconocía su esclavitud.",
          step="Aguanta hoy una situación injusta sin devolver el golpe, y anótala."),

        e("ta1836-cxxx-3", "maria-madalena", "Santa María Magdalena",
          title="Desde ahora y por siempre",
          why="El salmo es de una línea y no argumenta: manda esperar, y el plazo que da es sin fin.",
          saint_why="Se quedó junto al sepulcro cuando los demás ya se habían ido, según el relato de Juan.",
          step="Quédate hoy en la oración cinco minutos más de lo previsto."),

        e("ta1836-xxvi-13-14", "catarina-siena", "Santa Catalina de Siena",
          title="Pórtate varonilmente",
          why="El salmo manda portarse con valor y cobrar aliento: la firmeza se ordena como conducta, no como sentimiento.",
          saint_why="Reprendió por carta al propio Papa, con respeto y sin retirar la reprensión.",
          step="Pide hoy a alguien que te diga una cosa que hagas mal, y escúchala."),

        e("ta1836-lxi-7-9", "andre-bessette", "San Andrés Bessette",
          title="Esperad en él, pueblos",
          why="El salmista pasa de su alma al pueblo: la firmeza se contagia, se dice en voz alta a otros.",
          saint_why="Impulsó la construcción del Oratorio de San José del Monte Royal recogiendo donativos pequeños durante años.",
          step="Anima hoy a alguien que está a punto de abandonar algo bueno."),

        e("ta1836-cxxxvii-1-3", "francisco-xavier", "San Francisco Javier",
          title="En presencia de los ángeles",
          why="La alabanza se hace ante testigos invisibles: la firmeza del salmo sabe que nadie reza a solas.",
          saint_why="Bautizó en la India, Malaca y Japón, aprendiendo cada vez una lengua nueva y comenzando otra vez desde cero.",
          step="Reza hoy por el trabajo de alguien que nunca vas a conocer."),
    ],

    "empty": [
        e("ta1836-lxii-2-5", "joao-cruz", "San Juan de la Cruz",
          title="Tierra sin agua",
          why="El salmo no niega el desierto: dice que en él se pone en presencia de Dios como si estuviera en el Santuario.",
          saint_why="Llamó noche oscura a la fase en que la oración deja de dar gusto, y la describió como paso, no como pérdida.",
          step="Reza hoy en el mismo lugar de siempre, aunque no sientas nada."),

        e("ta1836-xxvi-4-5", "clara-assis", "Santa Clara de Asís",
          title="Una sola cosa he pedido",
          why="El salmo reduce todo a una petición: cuando no hay nada dentro, basta pedir un lugar donde quedarse.",
          saint_why="Vivió cuarenta y un años en el mismo monasterio de San Damián, sin cambiar de casa.",
          step="Pide hoy una sola cosa en la oración, y ninguna más."),

        e("ta1836-xxii-1-3", "teresinha", "Santa Teresita del Niño Jesús",
          title="Convirtió a mi alma",
          why="El salmo dice que el alma fue vuelta por otro: el vacío no se llena por decisión propia.",
          saint_why="Escribió que en sus últimos meses la fe le parecía un muro, y siguió haciendo los mismos actos pequeños.",
          step="Haz hoy un acto de caridad pequeño sin ganas de hacerlo."),

        e("ta1836-lxxxiii-2-5", "isabel-trindade", "Santa Isabel de la Trinidad",
          title="Mi alma padece deliquios",
          why="El salmo llama desfallecimiento a la ansia de estar en los atrios: el vacío es aquí una forma del deseo.",
          saint_why="Escribió sobre la presencia de Dios en el alma mientras la enfermedad de Addison le quitaba las fuerzas.",
          step="Di hoy en la oración: no siento nada, y sigo aquí."),

        e("ta1836-xxvi-4-5", "benito", "San Benito",
          title="Escondido en su tabernáculo",
          why="El salmo promete cobertura en los días aciagos: el vacío se atraviesa dentro de algo, no a la intemperie.",
          saint_why="Su Regla manda que el monje persevere en el mismo monasterio, y llama estabilidad a esa promesa.",
          step="Mantén hoy tu horario de oración sin cambiarlo."),

        e("ta1836-lxii-2-5", "jose", "San José",
          title="Desde que apunta la aurora",
          why="El salmista busca temprano, antes de sentir algo: el vacío se enfrenta por el horario, no por el ánimo.",
          saint_why="Llevó a su familia a Egipto de noche, según Mateo, sin explicación ni plazo dados.",
          step="Levántate mañana diez minutos antes y reza en ese hueco."),

        e("ta1836-xxii-1-3", "notburga", "Santa Notburga",
          title="Aguas que restauran",
          why="El salmo nombra el pasto y el agua: cosas materiales, no consolaciones. El vacío se atiende también por lo concreto.",
          saint_why="Se la recuerda por la comida que repartía, un pan y una jarra a la vez, no por escritos.",
          step="Come hoy despacio, sentado, sin pantalla."),

        e("ta1836-lxxxiii-2-5", "damiao-molokai", "San Damián de Molokai",
          title="El pajarillo halló un hueco",
          why="El salmo se fija en el pájaro que encontró grieta y la tórtola su nido: al vacío se le promete un lugar pequeño.",
          saint_why="Construyó con sus manos capillas y casas en Kalaupapa, además de cuidar a los enfermos.",
          step="Ordena hoy un rincón de tu casa, uno solo."),

        e("ta1836-xxvi-4-5", "carlo-acutis", "San Carlo Acutis",
          title="Frecuentando su Templo",
          why="El salmo habla de frecuentar: el vacío se trabaja con presencia repetida, no con una gran experiencia.",
          saint_why="Iba a Misa diaria y llamaba a la Eucaristía su «autopista para el cielo».",
          step="Ve hoy a una iglesia, aunque sea diez minutos."),

        e("ta1836-lxii-2-5", "vicente-paulo", "San Vicente de Paúl",
          title="De ti está sedienta mi alma",
          why="El salmo dice que también el cuerpo tiene sed: el vacío no es solo espiritual y no se cura solo por dentro.",
          saint_why="Sostenía que la caridad efectiva empieza por la sopa y la cama, antes del discurso.",
          step="Ayuda hoy a alguien con una necesidad material concreta."),

        e("ta1836-xxii-1-3", "oscar-romero", "San Óscar Romero",
          title="Por los senderos de la justicia",
          why="El salmo dice adónde conduce el pastor: cuando falta el sentido, queda el camino, y es el de la justicia.",
          saint_why="Cambió de postura pública tras el asesinato de un sacerdote amigo en 1977, y lo dijo abiertamente.",
          step="Haz hoy una cosa justa y pequeña que no te apetezca."),

        e("ta1836-lxxxiii-2-5", "agostinho", "San Agustín",
          title="Cuán amables son tus moradas",
          why="El salmo empieza admirando lo que no tiene delante: el vacío puede alabar de lejos.",
          saint_why="Escribió que el corazón está inquieto hasta descansar en Dios, después de años de buscarlo en otras cosas.",
          step="Lee hoy dos páginas de un libro espiritual, no más."),

        e("ta1836-xxii-1-3", "andre-bessette", "San Andrés Bessette",
          title="Me ha colocado en lugar de pastos",
          why="La frase está en pasado: el salmo recuerda un cuidado que ya ocurrió, para el día en que no se siente ninguno.",
          saint_why="Tenía salud frágil y una dieta muy limitada toda su vida, y sostuvo el mismo oficio durante cuarenta años.",
          step="Recuerda hoy un tiempo en que la oración te hacía bien, y anota la fecha."),

        e("ta1836-xxvi-4-5", "maria-madalena", "Santa María Magdalena",
          title="Para contemplar las delicias",
          why="El salmo pide mirar, no recibir: en el vacío el deseo se orienta a contemplar, no a obtener.",
          saint_why="El Evangelio de Juan la muestra mirando dentro del sepulcro antes de entender lo que veía.",
          step="Mira hoy con atención una imagen sagrada durante tres minutos."),

        e("ta1836-lxxxiii-2-5", "filipe-neri", "San Felipe Neri",
          title="Contemplando al Dios vivo",
          why="El salmo dice que el corazón y el cuerpo se transportan juntos: el vacío no descarta el gozo del cuerpo.",
          saint_why="Pasaba largas horas de oración nocturna y, de día, insistía en la alegría como medida de la vida cristiana.",
          step="Busca hoy la compañía de alguien alegre, aunque prefieras estar solo."),
    ],
}
