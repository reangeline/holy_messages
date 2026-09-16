import Foundation

enum MockDevotionalPrayers {
    static let categories: [PrayerCategory] = [
        .init(id: "peace-surrender", title: "Orações de Paz e Entrega", prayers: [
            .init(
                id: "st-francis-peace",
                title: "Oração de São Francisco",
                attribution: "São Francisco de Assis",
                focus: "A paz, o amor ao próximo e ser um instrumento do bem.",
                fullText: "Senhor, fazei de mim um instrumento da vossa paz.\nOnde houver ódio, que eu leve o amor;\nonde houver ofensa, que eu leve o perdão;\nonde houver discórdia, que eu leve a união;\nonde houver dúvida, que eu leve a fé;\nonde houver erro, que eu leve a verdade;\nonde houver desespero, que eu leve a esperança;\nonde houver tristeza, que eu leve a alegria;\nonde houver trevas, que eu leve a luz.\nÓ Mestre, fazei que eu procure mais consolar, que ser consolado; compreender, que ser compreendido; amar, que ser amado.\nPois é dando que se recebe, é perdoando que se é perdoado, e é morrendo que se vive para a vida eterna."
            ),
            .init(
                id: "abandonment-foucauld",
                title: "Oração de Abandono",
                attribution: "São Charles de Foucauld",
                focus: "Uma entrega total de confiança na vontade de Deus.",
                fullText: "Meu Pai, eu me abandono a Vós, fazei de mim o que quiserdes. O que fizerdes de mim, eu Vos agradeço. Estou pronto para tudo, aceito tudo, contanto que a Vossa vontade se faça em mim e em todas as Vossas criaturas. Não desejo mais nada, meu Deus. Entrego minha alma em Vossas mãos. Dou-a a Vós, meu Deus, com todo o amor do meu coração, porque Vos amo. E para mim é uma necessidade de amor dar-me, entregar-me em Vossas mãos, sem medida, com uma infinita confiança, porque Vós sois meu Pai."
            ),
        ]),
        .init(id: "protection-combat", title: "Orações de Proteção e Combate Espiritual", prayers: [
            .init(
                id: "st-benedict",
                title: "Oração de São Bento",
                attribution: "Medalha de São Bento",
                focus: "Proteção contra o mal e repulsa das tentações da alma.",
                fullText: "A Cruz Sagrada seja a minha luz, não seja o dragão o meu guia. Retira-te, Satanás! Nunca me aconselhes coisas vãs. É mau o que me ofereces: bebe tu mesmo o teu veneno!"
            ),
            .init(
                id: "st-michael",
                title: "Oração a São Miguel Arcanjo",
                attribution: "Papa Leão XIII",
                focus: "Proteção espiritual contra as forças do mal.",
                fullText: "São Miguel Arcanjo, defendei-nos no combate. Sede o nosso refúgio contra as maldades e ciladas do demônio. Que Deus vos exorte, pedimos suplicantes. E vós, príncipe da milícia celeste, pela virtude divina, precipitai no inferno a satanás e a todos os espíritos malignos que andam pelo mundo para perder as almas. Amém."
            ),
        ]),
        .init(id: "healing-liberation", title: "Orações de Cura e Libertação", prayers: [
            .init(
                id: "st-augustine-spirit",
                title: "Oração de Santo Agostinho ao Espírito Santo",
                attribution: "Santo Agostinho",
                focus: "A luz divina, a clareza mental e a pureza de pensamentos.",
                fullText: "Respirai em mim, ó Espírito Santo, para que os meus pensamentos sejam todos santos. Agi em mim, ó Espírito Santo, para que o meu trabalho, também, seja santo. Atraí o meu coração, ó Espírito Santo, para que eu ame somente o que é santo. Dai-me força, ó Espírito Santo, para defender o que é santo. Guardai-me, então, ó Espírito Santo, para que eu seja sempre santo. Amém."
            ),
            .init(
                id: "guardian-angel",
                title: "Oração do Anjo da Guarda",
                attribution: "Santo Anjo",
                focus: "Uma oração simples de proteção diária, ensinada desde a infância.",
                fullText: "Santo Anjo do Senhor, meu zeloso guardador, se a ti me confiou a piedade divina, sempre me rege, me guarda, me governa e me ilumina. Amém."
            ),
        ]),
        .init(id: "contemplation-intimacy", title: "Orações de Contemplação e Intimidade", prayers: [
            .init(
                id: "anima-christi",
                title: "Alma de Cristo",
                attribution: "Anima Christi, oração medieval",
                focus: "A união íntima com Jesus — muito recitada após receber a Eucaristia.",
                fullText: "Alma de Cristo, santificai-me.\nCorpo de Cristo, salvai-me.\nSangue de Cristo, inebriai-me.\nÁgua do lado de Cristo, lavai-me.\nPaixão de Cristo, confortai-me.\nÓ bom Jesus, ouvi-me.\nDentro de Vossas chagas, escondei-me.\nNão permitais que eu me separe de Vós.\nDo espírito maligno, defendei-me.\nNa hora da minha morte, chamai-me.\nE mandai-me ir para Vós,\npara que com os Vossos santos Vos louve\npor todos os séculos dos séculos. Amém."
            ),
        ]),
    ]
}
