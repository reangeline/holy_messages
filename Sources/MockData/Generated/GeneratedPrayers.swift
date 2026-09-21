// GERADO — não editar à mão.
// Origem: ~/Documents/Missale-pesquisa/entregas, importado por
// scripts/import_acervo.py. Reimportar em vez de corrigir aqui.
//
// Orações devocionais por idioma. Quando o mesmo título aparece no lote
// oficial (transcrito do Compêndio) e num lote anterior, fica o oficial.

import Foundation

extension MockDevotionalPrayers {
    static let ptImportedPrayers: [String: [DevotionalPrayer]] = [
        "contemplation-intimacy": [
            .init(
                id: "sinal-da-cruz-pt",
                title: "Sinal da Cruz",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Fórmula comum da oração cristã",
                fullText: "Em nome do Pai e do Filho e do Espírito Santo. Ámen."
            ),
            .init(
                id: "gl-ria-ao-pai-pt",
                title: "Glória ao Pai",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Doxologia trinitária",
                fullText: "Glória ao Pai e ao Filho e ao Espírito Santo. Como era, no princípio, agora e sempre. Ámen."
            ),
            .init(
                id: "magnificat-pt",
                title: "Magnificat",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Cântico de Maria",
                fullText: "A minha alma glorifica ao Senhor e o meu espírito se alegra em Deus, meu Salvador. Porque pôs os olhos na humildade da sua serva: de hoje em diante me chamarão bem-aventurada todas as gerações. O Todo-Poderoso fez em mim maravilhas: Santo é o seu nome. A sua misericórdia se estende de geração em geração sobre aqueles que O temem. Manifestou o poder do seu braço e dispersou os soberbos. Derrubou os poderosos de seus tronos e exaltou os humildes. Aos famintos encheu de bens e aos ricos despediu de mãos vazias. Acolheu Israel seu servo, lembrado da sua misericórdia, como tinha prometido a nossos pais, a Abraão e à sua descendência para sempre. Glória ao Pai e ao Filho e ao Espírito Santo. Como era no princípio, agora e sempre. Ámen."
            ),
            .init(
                id: "benedictus-pt",
                title: "Benedictus",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Cântico de Zacarias",
                fullText: "Bendito o Senhor Deus de Israel que visitou e redimiu o seu povo, e nos deu um Salvador poderoso na casa de David, seu servo, conforme prometeu pela boca dos seus santos, os profetas dos tempos antigos, para nos libertar dos nossos inimigos, e das mãos daqueles que nos odeiam. Para mostrar a sua misericórdia a favor dos nossos pais, recordando a sua sagrada aliança, e o juramento que fizera a Abraão, nosso pai, que nos havia de conceder esta graça: de O servirmos um dia, sem temor, livres das mãos dos nossos inimigos, em santidade e justiça, na sua presença, todos os dias da nossa vida. E tu, menino, serás chamado profeta do Altíssimo, porque irás à sua frente a preparar os seus caminhos, para dar a conhecer ao seu povo a salvação pela remissão dos seus pecados, graças ao coração misericordioso do nosso Deus, que das alturas nos visita como sol nascente, para iluminar os que jazem nas trevas e na sombra da morte e dirigir os nossos passos no caminho da paz. Glória ao Pai e ao Filho e ao Espírito Santo. Como era no princípio, agora e sempre. Ámen."
            ),
            .init(
                id: "s-mbolo-dos-ap-stolos-pt",
                title: "Símbolo dos Apóstolos",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Profissão de fé",
                fullText: "Creio em Deus, Pai todo-poderoso, Criador do Céu e da Terra. E em Jesus Cristo, seu único Filho, nosso Senhor que foi concebido pelo poder do Espírito Santo; nasceu da Virgem Maria; padeceu sob Pôncio Pilatos, foi crucificado, morto e sepultado; desceu à mansão dos mortos; ressuscitou ao terceiro dia; subiu aos Céus; está sentado à direita de Deus Pai todo-poderoso, de onde há-de vir a julgar os vivos e os mortos. Creio no Espírito Santo; na santa Igreja Católica; na comunhão dos Santos; na remissão dos pecados; na ressurreição da carne; e na vida eterna. Amen."
            ),
            .init(
                id: "credo-niceno-constantinopolitano-pt",
                title: "Credo Niceno-Constantinopolitano",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Profissão de fé litúrgica",
                fullText: "Creio em um só Deus, Pai todo-poderoso Criador do Céu e da Terra, de todas as coisas visíveis e invisíveis. Creio em um só Senhor, Jesus Cristo, Filho Unigénito de Deus, nascido do Pai antes de todos os séculos: Deus de Deus, luz da luz, Deus verdadeiro de Deus verdadeiro; gerado, não criado, consubstancial ao Pai. Por Ele todas as coisas foram feitas. E por nós homens e para nossa salvação desceu dos Céus. E encarnou pelo Espírito Santo, no seio da Virgem Maria, e se fez homem. Também por nós foi crucificado sob Pôncio Pilatos; padeceu e foi sepultado. Ressuscitou ao terceiro dia, conforme as Escrituras; e subiu aos Céus, onde está sentado à direita do Pai. De novo há-de vir em sua glória para julgar os vivos e os mortos; e o seu Reino não terá fim. Creio no Espírito Santo, Senhor que dá a vida, e procede do Pai e do Filho; e com o Pai e o Filho é adorado e glorificado: Ele que falou pelos profetas. Creio na Igreja una, santa, católica e apostólica. Professo um só Baptismo para a remissão dos pecados. E espero a ressurreição dos mortos e a vida do mundo que há-de vir. Ámen."
            ),
            .init(
                id: "vinde-esp-rito-santo-pt",
                title: "Vinde, Espírito Santo",
                attribution: "Sequência de Pentecostes, Veni Sancte Spiritus",
                focus: "Invocação do Espírito Santo",
                fullText: "Vinde, Espírito Santo, enchei os corações dos vossos fiéis e acendei neles o fogo do vosso amor. Enviai o vosso Espírito, e tudo será criado, e renovareis a face da terra. Oremos: Ó Deus, que instruístes os corações dos vossos fiéis com a luz do Espírito Santo, fazei que apreciemos retamente todas as coisas segundo o mesmo Espírito e gozemos sempre da sua consolação. Por Cristo, Senhor nosso. Amém."
            ),
            .init(
                id: "ora-o-de-jesus-pt",
                title: "Oração de Jesus",
                attribution: "Tradição cristã oriental",
                focus: "Invocação breve da misericórdia de Cristo",
                fullText: "Senhor Jesus Cristo, Filho de Deus, tende piedade de mim, pecador."
            ),
            .init(
                id: "te-deum-pt",
                title: "Te Deum",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Hino de louvor à Trindade",
                fullText: "Nós Vos louvamos, ó Deus,\nnós Vos bendizemos, Senhor.\nToda a terra Vos adora,\nPai eterno e omnipotente.\nOs Anjos, os Céus\ne todas as Potestades,\nos Querubins e os Serafins\nVos aclamam sem cessar:\nSanto, Santo, Santo,\nSenhor Deus do Universo,\no céu e a terra proclamam a vossa glória.\nO coro glorioso dos Apóstolos,\na falange venerável dos Profetas,\no exército resplandecente dos Mártires\ncantam os vossos louvores.\nA santa Igreja anuncia por toda a terra\na glória do vosso nome:\nDeus de infinita majestade,\nPai, Filho e Espírito Santo.\nSenhor Jesus Cristo, Rei da glória,\nFilho do Eterno Pai,\npara salvar o homem, tomastes\na condição humana no seio da Virgem Maria.\nVós despedaçastes as cadeias da morte\ne abristes as portas do céu.\nVós estais sentado à direita de Deus,\nna glória do Pai,\ne de novo haveis de vir para julgar\nos vivos e os mortos.\nSocorrei os vossos servos, Senhor,\nque remistes com vosso Sangue precioso;\ne recebei-os na luz da glória,\nna assembleia dos vossos Santos.\nSalvai o vosso povo, Senhor,\ne abençoai a vossa herança;\nsede o seu pastor e guia através dos tempos\ne conduzi-o às fontes da vida eterna.\nNós Vos bendiremos todos os dias da nossa vida\ne louvaremos para sempre o vosso nome.\nDignai-Vos, Senhor, neste dia, livrar-nos do pecado.\nTende piedade de nós,\nSenhor, tende piedade de nós.\nDesça sobre nós a vossa misericórdia,\nPorque em Vós esperamos.\nEm Vós espero, meu Deus,\nnão serei confundido eternamente."
            ),
        ],
        "healing-liberation": [
            .init(
                id: "dai-lhes-senhor-o-eterno-descanso-pt",
                title: "Dai-lhes, Senhor, o eterno descanso",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Súplica pelos defuntos",
                fullText: "Dai-lhes, Senhor, o eterno descanso. Entre os esplendores da luz perpétua. Descansem em paz. Ámen."
            ),
            .init(
                id: "ato-de-contri-o-pt",
                title: "Ato de contrição",
                attribution: "Fórmula tradicional católica",
                focus: "Arrependimento e retorno a Deus",
                fullText: "Meu Deus, porque sois infinitamente bom e vos amo de todo o meu coração, pesa-me de vos ter ofendido. Com o auxílio da vossa graça, proponho firmemente não mais pecar e fugir das ocasiões de pecado. Amém."
            ),
        ],
        "peace-surrender": [
            .init(
                id: "pai-nosso-pt",
                title: "Pai Nosso",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Oração do Senhor",
                fullText: "Pai Nosso que estais nos Céus, santificado seja o vosso Nome, venha a nós o vosso Reino, seja feita a vossa vontade assim na terra como no Céu. O pão nosso de cada dia nos dai hoje, perdoai-nos as nossas ofensas assim como nós perdoamos a quem nos tem ofendido, e não nos deixeis cair em tentação, mas livrai-nos do Mal."
            ),
            .init(
                id: "av-maria-pt",
                title: "Avé Maria",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Oração mariana comum",
                fullText: "Avé Maria, cheia de graça, o Senhor é convosco, bendita sois vós entre as mulheres e bendito é o fruto do vosso ventre, Jesus. Santa Maria, Mãe de Deus, rogai por nós pecadores, agora e na hora da nossa morte. Ámen."
            ),
            .init(
                id: "angelus-pt",
                title: "Angelus",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Oração da Encarnação",
                fullText: "V. O Anjo do Senhor anunciou a Maria. R. E Ela concebeu pelo Espírito Santo. Avé Maria... V. Eis a escrava do Senhor. R. Faça-se em mim, segundo a Vossa palavra. Avé Maria... V. E o Verbo Divino encarnou. R. E habitou entre nós. Avé Maria... V. Rogai por nós, santa Mãe de Deus. R. Para que sejamos dignos das promessas de Cristo. Oremos: Infundi, Senhor, a vossa graça, em nossas almas, para que nós, que, pela anunciação do Anjo, conhecemos a encarnação de Cristo, vosso Filho, pela sua paixão e morte na cruz, sejamos conduzidos à glória da Ressurreição. Pelo mesmo Cristo Senhor nosso. Ámen."
            ),
            .init(
                id: "rainha-do-c-u-pt",
                title: "Rainha do Céu",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Antífona pascal mariana",
                fullText: "Rainha dos céus, alegrai-vos. Aleluia! Porque Aquele que merecestes trazer em vosso seio. Aleluia! Ressuscitou como disse. Aleluia! Rogai por nós a Deus. Aleluia! Alegrai-vos e exultai, ó Virgem Maria. Aleluia! Porque o Senhor ressuscitou, verdadeiramente. Aleluia! Oremos. Ó Deus, que enchestes o mundo de alegria com a ressurreição do Vosso Filho, nosso Senhor Jesus Cristo, concedei, nós vo-lo pedimos, que pela intercessão da Virgem Maria, Sua Mãe, alcancemos as alegrias da vida eterna. Por Cristo, Senhor nosso."
            ),
            .init(
                id: "salve-rainha-pt",
                title: "Salve Rainha",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Antífona mariana tradicional",
                fullText: "Salve, Rainha, mãe de misericórdia, vida, doçura, esperança nossa, salve! A Vós bradamos, os degredados filhos de Eva. A Vós suspiramos, gemendo e chorando neste vale de lágrimas. Eia, pois, advogada nossa, esses Vossos olhos misericordiosos a nós volvei. E, depois deste desterro, nos mostrai Jesus, bendito fruto do Vosso ventre. Ó clemente, ó piedosa, ó doce Virgem Maria. Rogai por nós, Santa Mãe de Deus, para que sejamos dignos das promessas de Cristo."
            ),
            .init(
                id: "lembrai-vos-pt",
                title: "Lembrai-vos",
                attribution: "Tradição atribuída a São Bernardo de Claraval",
                focus: "Confiança na intercessão de Maria",
                fullText: "Lembrai-vos, ó piíssima Virgem Maria, que nunca se ouviu dizer que algum daqueles que tenham recorrido à vossa proteção, implorado a vossa assistência e reclamado o vosso socorro fosse por vós desamparado. Animado eu, pois, com igual confiança, a vós, Virgem entre todas singular, como Mãe recorro; de vós me valho e, gemendo sob o peso dos meus pecados, me prostro a vossos pés. Não desprezeis as minhas súplicas, ó Mãe do Filho de Deus encarnado, mas dignai-vos de as ouvir propícia e de me alcançar o que vos rogo. Amém."
            ),
            .init(
                id: "vossa-prote-o-pt",
                title: "À vossa proteção",
                attribution: "Sub tuum praesidium, antífona mariana antiga",
                focus: "Refúgio sob a proteção de Maria",
                fullText: "À vossa proteção recorremos, Santa Mãe de Deus; não desprezeis as nossas súplicas em nossas necessidades, mas livrai-nos sempre de todos os perigos, ó Virgem gloriosa e bendita. Amém."
            ),
            .init(
                id: "tomai-senhor-e-recebei-pt",
                title: "Tomai, Senhor, e recebei",
                attribution: "Santo Inácio de Loyola, Exercícios Espirituais",
                focus: "Oferta da liberdade e da vida a Deus",
                saintID: "inacio-loyola",
                fullText: "Tomai, Senhor, e recebei toda a minha liberdade, a minha memória, o meu entendimento e toda a minha vontade, tudo o que tenho e possuo. Vós mo destes; a Vós, Senhor, o restituo. Tudo é vosso: disponde de tudo segundo a vossa vontade. Dai-me somente o vosso amor e a vossa graça, que isto me basta."
            ),
        ],
        "protection-combat": [
            .init(
                id: "ao-anjo-da-guarda-pt",
                title: "Ao Anjo da Guarda",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Oração ao anjo da guarda",
                fullText: "Santo Anjo do Senhor, meu zeloso guardador, pois que a ti me confiou a Piedade divina, hoje e sempre me governa, rege, guarda e ilumina. Ámen."
            ),
            .init(
                id: "sob-a-tua-protec-o-pt",
                title: "Sob a Tua Protecção",
                attribution: "Compêndio do Catecismo da Igreja Católica",
                focus: "Antífona mariana de proteção",
                fullText: "À Vossa protecção, recorremos, Santa Mãe de Deus; não desprezeis as nossas súplicas em nossas necessidades; mas livrai-nos de todos os perigos, ó Virgem gloriosa e bendita."
            ),
        ],
    ]

    static let enImportedPrayers: [String: [DevotionalPrayer]] = [
        "contemplation-intimacy": [
            .init(
                id: "the-sign-of-the-cross-en",
                title: "The Sign of the Cross",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Common Christian prayer",
                fullText: "In the name of the Father and of the Son and of the Holy Spirit. Amen."
            ),
            .init(
                id: "glory-be-to-the-father-en",
                title: "Glory be to the Father",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Trinitarian doxology",
                fullText: "Glory be to the Father and to the Son and to the Holy Spirit, as it was in the beginning is now, and ever shall be world without end. Amen."
            ),
            .init(
                id: "the-magnificat-en",
                title: "The Magnificat",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Canticle of Mary",
                fullText: "My soul proclaims the greatness of the Lord, my spirit rejoices in God my Savior, for he has looked with favor on his lowly servant. From this day all generations will call me blessed: the Almighty has done great things for me, and holy is his Name. He has mercy on those who fear him in every generation. He has shown the strength of his arm, he has scattered the proud in their conceit. He has cast down the mighty from their thrones, and has lifted up the lowly. He has filled the hungry with good things, and the rich he has sent away empty. He has come to the help of his servant Israel for he has remembered his promise of mercy, the promise he made to our fathers, to Abraham and his children forever. Glory to the Father and to the Son and to the Holy Spirit, as it was in the beginning, is now, and will be forever. Amen."
            ),
            .init(
                id: "the-benedictus-en",
                title: "The Benedictus",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Canticle of Zechariah",
                fullText: "Blessed be the Lord, the God of Israel! He has visited his people and redeemed them. He has raised up for us a mighty saviour in the house of David his servant, as he promised by the lips of holy men, those who were his prophets from of old. A saviour who would free us from our foes, from the hands of all who hate us. So his love for our fathers is fulfilled and his holy covenant remembered. He swore to Abraham our father to grant us, that free from fear, and saved from the hands of our foes, we might serve him in holiness and justice all the days of our life in his presence. As for you, little child, you shall be called a prophet of God, the Most High. You shall go ahead of the Lord to prepare his ways before him. To make known to his people their salvation through forgiveness of all their sins, the loving-kindness of the heart of our God who visits us like the dawn from on high. He will give light to those in darkness, those who dwell in the shadow of death, and guide us into the way of peace. Glory be to the Father and to the Son and to the Holy Spirit, as it was in the beginning, is now, and ever shall be, world without end. Amen."
            ),
            .init(
                id: "the-apostles-creed-en",
                title: "The Apostles’ Creed",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Profession of faith",
                fullText: "I believe in God the Father almighty, Creator of heaven and earth. And in Jesus Christ, His only Son, our Lord, Who was conceived by the Holy Spirit, born of the Virgin Mary, suffered under Pontius Pilate, was crucified, died, and was buried. He descended into hell; the third day He rose again from the dead; He ascended into heaven, and sits at the right hand of God the Father almighty, from thence He shall come to judge the living and the dead. I believe in the Holy Spirit, the holy Catholic Church, the communion of saints, the forgiveness of sins, the resurrection of the body and life everlasting. Amen."
            ),
            .init(
                id: "the-nicene-constantinopolitan-creed-en",
                title: "The Nicene-Constantinopolitan Creed",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Liturgical profession of faith",
                fullText: "I believe in one God, the Father, the Almighty, maker of heaven and earth, of all that is, seen and unseen. I believe one Lord, Jesus Christ, the only Son of God, eternally begotten of the Father, God from God, Light from Light, true God from true God, begotten, not made, one in Being with the Father. Through Him all things were made. For us men and for our salvation, He came down from heaven: by the power of the Holy Spirit He was born of the Virgin Mary, and became Man. For our sake He was crucified under Pontius Pilate; He suffered, died, and was buried. On the third day He rose again in fulfillment of the Scriptures; He ascended into heaven, and is seated at the right hand of the Father. He will come again in glory to judge the living and the dead, and His kingdom will have no end. I believe in the Holy Spirit, the Lord, the Giver of life, Who proceeds from the Father and the Son. With the Father and the Son He is worshiped and glorified. He has spoken through the prophets. I believe in one, holy, catholic, and apostolic Church. I acknowledge one Baptism for the forgiveness of sins. I look for the resurrection of the dead, and the life of the world to come. Amen."
            ),
            .init(
                id: "the-jesus-prayer-en",
                title: "The Jesus Prayer",
                attribution: "Eastern Christian tradition",
                focus: "Simple invocation of Jesus’ mercy",
                fullText: "Lord Jesus Christ, Son of God, have mercy on me, a sinner."
            ),
            .init(
                id: "come-holy-spirit-en",
                title: "Come, Holy Spirit",
                attribution: "Traditional Catholic hymn",
                focus: "Invocation of the Holy Spirit",
                fullText: "Come, Holy Spirit, Creator blessed, and in our hearts take up your rest; come with your grace and heavenly aid to fill the hearts which you have made. O comforter, to you we cry, O heavenly gift of God most high, O font of life and fire of love, and sweet anointing from above."
            ),
            .init(
                id: "magnificat-en",
                title: "Magnificat",
                attribution: "Gospel prayer, Luke 1:46–55",
                focus: "Mary’s praise and humble joy",
                fullText: "My soul magnifies the Lord, and my spirit rejoices in God my Savior, because he has looked upon the lowliness of his servant. From this day all generations will call me blessed: the Almighty has done great things for me, and holy is his name."
            ),
            .init(
                id: "benedictus-en",
                title: "Benedictus",
                attribution: "Gospel prayer, Luke 1:68–79",
                focus: "Praise at the dawn of salvation",
                fullText: "Blessed be the Lord, the God of Israel; he has come to his people and set them free. He has raised up for us a mighty savior, born of the house of his servant David."
            ),
            .init(
                id: "nunc-dimittis-en",
                title: "Nunc Dimittis",
                attribution: "Gospel prayer, Luke 2:29–32",
                focus: "Peaceful recognition of Christ",
                fullText: "Lord, now you let your servant go in peace; your word has been fulfilled. My own eyes have seen the salvation which you have prepared in the sight of every people: a light to reveal you to the nations and the glory of your people Israel."
            ),
            .init(
                id: "te-deum-en",
                title: "Te Deum",
                attribution: "Ancient Christian hymn",
                focus: "Praise of the Trinity and the Church",
                fullText: "You are God: we praise you; you are the Lord: we acclaim you; you are the eternal Father: all creation worships you. To you all angels, all the powers of heaven, cherubim and seraphim, sing in endless praise."
            ),
        ],
        "healing-liberation": [
            .init(
                id: "eternal-rest-en",
                title: "Eternal Rest",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Prayer for the departed",
                fullText: "Eternal rest grant unto them, O Lord, and let perpetual light shine upon them. May they rest in peace. Amen."
            ),
            .init(
                id: "act-of-contrition-en",
                title: "Act of Contrition",
                attribution: "Traditional sacramental prayer",
                focus: "Repentance and return to God",
                fullText: "O my God, I am heartily sorry for having offended you, and I detest all my sins because of your just punishments, but most of all because they offend you, my God, who are all-good and deserving of all my love. I firmly resolve, with the help of your grace, to sin no more and to avoid the near occasions of sin. Amen."
            ),
            .init(
                id: "prayer-to-our-lady-of-lourdes-en",
                title: "Prayer to Our Lady of Lourdes",
                attribution: "Traditional Catholic devotion",
                focus: "Petition for healing under Mary’s care",
                fullText: "Blessed Mother of Lourdes, you appeared to Bernadette as the Immaculate Conception. Obtain for us a heart made clean by repentance, courage in illness, and trust in the mercy of your Son. Pray for the sick and lead us toward the healing God desires. Amen."
            ),
            .init(
                id: "prayer-to-the-sacred-heart-en",
                title: "Prayer to the Sacred Heart",
                attribution: "Traditional Catholic devotion",
                focus: "Healing through Christ’s merciful Heart",
                fullText: "Most Sacred Heart of Jesus, I place all my trust in you. When I am afraid, let me come to you; when I am wounded, let me remain near you; when I have sinned, let me return to your mercy. Make my heart like yours, patient and humble. Amen."
            ),
            .init(
                id: "prayer-of-st-augustine-en",
                title: "Prayer of St Augustine",
                attribution: "St Augustine",
                focus: "Purification of thought and desire",
                saintID: "agostinho",
                fullText: "Breathe in me, O Holy Spirit, that my thoughts may all be holy. Act in me, O Holy Spirit, that my work, too, may be holy. Draw my heart, O Holy Spirit, that I may love only what is holy. Strengthen me, O Holy Spirit, to defend all that is holy. Guard me, then, O Holy Spirit, that I may always be holy. Amen."
            ),
            .init(
                id: "prayer-for-the-sick-en",
                title: "Prayer for the Sick",
                attribution: "Traditional Catholic petition",
                focus: "Compassion and strength in illness",
                fullText: "Lord Jesus Christ, healer of souls and bodies, stay near those who are sick. Give them patience, strengthen those who care for them, guide the hands of those who treat them, and let the Church accompany them with prayer and charity. May your mercy be known in every place of suffering. Amen."
            ),
        ],
        "peace-surrender": [
            .init(
                id: "our-father-en",
                title: "Our Father",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "The Lord’s Prayer",
                fullText: "Our Father who art in heaven, hallowed be thy name. Thy kingdom come. Thy will be done on earth, as it is in heaven. Give us this day our daily bread, and forgive us our trespasses, as we forgive those who trespass against us, and lead us not into temptation, but deliver us from evil."
            ),
            .init(
                id: "the-hail-mary-en",
                title: "The Hail Mary",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Common Marian prayer",
                fullText: "Hail, Mary, full of grace, the Lord is with thee. Blessed art thou among women and blessed is the fruit of thy womb, Jesus. Holy Mary, Mother of God, pray for us sinners, now and at the hour of our death. Amen."
            ),
            .init(
                id: "the-angelus-en",
                title: "The Angelus",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Prayer of the Incarnation",
                fullText: "V. The Angel of the Lord declared unto Mary. R. And she conceived of the Holy Spirit. Hail Mary... V. Behold the handmaid of the Lord. R. Be it done unto me according to thy word. Hail Mary... V. And the Word was made flesh. R. And dwelt among us. Hail Mary... V. Pray for us, O holy Mother of God. R. That we may be made worthy of the promises of Christ. Let us pray; Pour forth, we beseech thee, O Lord, thy grace into our hearts; that we, to whom the Incarnation of Christ, thy Son, was made known by the message of an angel, may by his Passion and Cross be brought to the glory of his Resurrection. Through the same Christ, our Lord. Amen."
            ),
            .init(
                id: "regina-caeli-en",
                title: "Regina Caeli",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Paschal Marian antiphon",
                fullText: "Queen of heaven, rejoice, alleluia! for he whom you were worthy to bear, alleluia! has risen as he said, alleluia! Pray for us to God, alleluia! Let us pray; O God, who through the resurrection of your Son, our Lord Jesus Christ, did vouchsafe to give joy to the world; grant, we beseech you, that through his Mother, the Virgin Mary, we may obtain the joys of everlasting life. Through the same Christ our Lord. Amen."
            ),
            .init(
                id: "hail-holy-queen-en",
                title: "Hail Holy Queen",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Traditional Marian antiphon",
                fullText: "Hail, Holy Queen, Mother of Mercy, our life, our sweetness and our hope. To you do we cry, poor banished children of Eve. To you do we send up our sighs, mourning and weeping in this valley of tears. Turn then, most gracious advocate, your eyes of mercy toward us, and after this exile show unto us the blessed fruit of your womb, Jesus. O clement, O loving, O sweet Virgin Mary."
            ),
            .init(
                id: "memorare-en",
                title: "Memorare",
                attribution: "St Bernard tradition",
                focus: "Trustful petition to Mary in distress",
                fullText: "Remember, O most gracious Virgin Mary, that never was it known that anyone who fled to thy protection, implored thy help, or sought thine intercession, was left unaided. Inspired by this confidence, I fly unto thee, O Virgin of virgins, my mother; to thee do I come, before thee I stand, sinful and sorrowful. O Mother of the Word Incarnate, despise not my petitions, but in thy mercy hear and answer me. Amen."
            ),
            .init(
                id: "sub-tuum-praesidium-en",
                title: "Sub Tuum Praesidium",
                attribution: "Ancient Marian antiphon",
                focus: "Refuge under Mary’s protection",
                fullText: "We fly to thy patronage, O holy Mother of God; despise not our petitions in our necessities, but deliver us always from all dangers, O glorious and blessed Virgin. Amen."
            ),
            .init(
                id: "prayer-of-trust-en",
                title: "Prayer of Trust",
                attribution: "Charles de Foucauld",
                focus: "Abandonment in God’s hands",
                fullText: "My Father, I abandon myself to you; make of me what you will. Whatever you may do, I thank you: I am ready for everything, I accept everything. Let only your will be done in me, and in all your creatures. I wish no more than this, O Lord. Into your hands I commend my soul; I give it to you with all the love of my heart, because I love you, Lord, and so need to give myself, to surrender myself into your hands, without reserve, and with boundless confidence, for you are my Father."
            ),
            .init(
                id: "suscipe-en",
                title: "Suscipe",
                attribution: "St Ignatius of Loyola",
                focus: "Offering one’s freedom and life to God",
                saintID: "inacio-loyola",
                fullText: "Take, Lord, and receive all my liberty, my memory, my understanding, and my entire will, all that I have and possess. You have given all to me. To you, Lord, I return it. All is yours; dispose of it wholly according to your will. Give me only your love and your grace, for this is enough for me."
            ),
            .init(
                id: "prayer-of-st-thomas-more-en",
                title: "Prayer of St Thomas More",
                attribution: "St Thomas More",
                focus: "Peaceful fidelity under pressure",
                fullText: "Give me, good Lord, a longing to be with you, not for fear of the pains of this world, nor for fear of the pains of purgatory, nor yet for the joys of heaven, but simply for love of you. And give me the grace to labor for your glory, for the good of others, and for my own salvation. Amen."
            ),
        ],
        "protection-combat": [
            .init(
                id: "angel-of-god-en",
                title: "Angel of God",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Prayer to one’s guardian angel",
                fullText: "Angel of God, my guardian dear, to whom God’s love commits me here, ever this day be at my side, to light and guard, to rule and guide. Amen."
            ),
            .init(
                id: "under-your-protection-en",
                title: "Under Your Protection",
                attribution: "Compendium of the Catechism of the Catholic Church",
                focus: "Marian antiphon of protection",
                fullText: "We fly to thy protection, O holy Mother of God. Despise not our petitions in our necessities, but deliver us always from all dangers O glorious and blessed Virgin."
            ),
            .init(
                id: "st-patrick-s-breastplate-en",
                title: "St Patrick’s Breastplate",
                attribution: "Traditional Lorica of St Patrick",
                focus: "Protection and steadfastness in Christ",
                fullText: "Christ with me, Christ before me, Christ behind me, Christ in me, Christ beneath me, Christ above me, Christ on my right, Christ on my left, Christ where I lie, Christ where I sit, Christ where I arise. Christ in the heart of everyone who thinks of me, Christ in the mouth of everyone who speaks to me, Christ in every eye that sees me, Christ in every ear that hears me. Salvation is of the Lord."
            ),
            .init(
                id: "prayer-to-the-holy-cross-en",
                title: "Prayer to the Holy Cross",
                attribution: "Traditional Christian prayer",
                focus: "Protection beneath the Cross",
                fullText: "May the Holy Cross be my light; may the dragon never be my guide. Begone, Satan! Do not suggest to me your vanities. Evil are the things you offer; drink the poison yourself."
            ),
            .init(
                id: "prayer-to-st-raphael-en",
                title: "Prayer to St Raphael",
                attribution: "Traditional Catholic devotion",
                focus: "Protection on a journey and healing",
                fullText: "Blessed Saint Raphael the Archangel, friend and companion on the road of life, be with me in my journeys and keep me safe from every danger. Guide my steps toward what is good, and lead me to the care of God. Amen."
            ),
            .init(
                id: "prayer-to-the-guardian-angel-en",
                title: "Prayer to the Guardian Angel",
                attribution: "Traditional Catholic prayer",
                focus: "Daily protection and guidance",
                fullText: "Angel of God, my guardian dear, to whom God’s love commits me here, ever this day be at my side, to light and guard, to rule and guide. Amen."
            ),
            .init(
                id: "the-leonine-prayer-en",
                title: "The Leonine Prayer",
                attribution: "Pope Leo XIII",
                focus: "Prayer for the Church’s protection",
                fullText: "Saint Michael the Archangel, defend us in battle; be our protection against the wickedness and snares of the devil. May God rebuke him, we humbly pray; and do thou, O Prince of the heavenly host, by the power of God, cast into hell Satan and all the evil spirits who prowl about the world seeking the ruin of souls. Amen."
            ),
        ],
    ]

    static let esImportedPrayers: [String: [DevotionalPrayer]] = [
        "contemplation-intimacy": [
            .init(
                id: "se-al-de-la-cruz-es",
                title: "Señal de la Cruz",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Oración cristiana común",
                fullText: "En el nombre del Padre y del Hijo y del Espíritu Santo. Amén."
            ),
            .init(
                id: "gloria-al-padre-es",
                title: "Gloria al Padre",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Doxología trinitaria",
                fullText: "Gloria al Padre y al Hijo y al Espíritu Santo. Como era en el principio, ahora y siempre, por los siglos de los siglos. Amén."
            ),
            .init(
                id: "magnificat-es",
                title: "Magnificat",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Cántico de María",
                fullText: "Proclama mi alma la grandeza del Señor, se alegra mi espíritu en Dios, mi salvador; porque ha mirado la humillación de su esclava. Desde ahora me felicitarán todas las generaciones, porque el Poderoso ha hecho obras grandes por mí: su nombre es santo, y su misericordia llega a sus fieles de generación en generación. Él hace proezas con su brazo: dispersa a los soberbios de corazón, derriba del trono a los poderosos y enaltece a los humildes, a los hambrientos los colma de bienes y a los ricos los despide vacíos. Auxilia a Israel, su siervo, acordándose de la misericordia —como lo había prometido a nuestros padres— en favor de Abrahán y su descendencia por siempre. Gloria al Padre, y al Hijo, y al Espíritu Santo. Como era en el principio, ahora y siempre, por los siglos de los siglos. Amén."
            ),
            .init(
                id: "benedictus-es",
                title: "Benedictus",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Cántico de Zacarías",
                fullText: "Bendito sea el Señor, Dios de Israel, porque ha visitado y redimido a su pueblo, suscitándonos una fuerza de salvación en la casa de David, su siervo, según lo había predicho desde antiguo por boca de sus santos Profetas. Es la salvación que nos libra de nuestros enemigos y de la mano de todos los que nos odian; realizando la misericordia que tuvo con nuestros padres, recordando su santa alianza y el juramento que juró a nuestro padre Abrahán. Para concedernos que, libres de temor, arrancados de la mano de los enemigos, le sirvamos con santidad y justicia, en su presencia, todos nuestros días. Y a ti, niño, te llamarán profeta del Altísimo, porque irás delante del Señor a preparar sus caminos, anunciando a su pueblo la salvación, el perdón de sus pecados. Por la entrañable misericordia de nuestro Dios, nos visitará el sol que nace de lo alto, para iluminar a los que viven en tinieblas y en sombra de muerte, para guiar nuestros pasos por el camino de la paz. Gloria al Padre, y al Hijo, y al Espíritu Santo. Como era en el principio, ahora y siempre, por los siglos de los siglos. Amén."
            ),
            .init(
                id: "s-mbolo-de-los-ap-stoles-es",
                title: "Símbolo de los Apóstoles",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Profesión de fe",
                fullText: "Creo en Dios, Padre Todopoderoso, Creador del cielo y de la tierra. Creo en Jesucristo, su único Hijo, Nuestro Señor, Que fue concebido por obra y gracia del Espíritu Santo, nació de Santa María Virgen, padeció bajo el poder de Poncio Pilato, fue crucificado, muerto y sepultado, descendió a los infiernos, al tercer día resucitó de entre los muertos, subió a los cielos y está sentado a la derecha de Dios, Padre todopoderoso. Desde allí ha de venir a juzgar a vivos y muertos. Creo en el Espíritu Santo, la santa Iglesia católica, la comunión de los santos, el perdón de los pecados, la resurrección de la carne y la vida eterna. Amén."
            ),
            .init(
                id: "credo-niceno-constantinopolitano-es",
                title: "Credo Niceno-Constantinopolitano",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Profesión de fe litúrgica",
                fullText: "Creo en un solo Dios, Padre Todopoderoso, Creador del cielo y de la tierra, de todo lo visible y lo invisible. Creo en un solo Señor, Jesucristo, Hijo único de Dios, nacido del Padre antes de todos los siglos: Dios de Dios, Luz de Luz, Dios verdadero de Dios verdadero, engendrado, no creado, de la misma naturaleza del Padre, por quien todo fue hecho; que por nosotros, los hombres, y por nuestra salvación bajó del cielo, y por obra del Espíritu Santo se encarnó de María, la Virgen, y se hizo hombre; y por nuestra causa fue crucificado en tiempos de Poncio Pilato; padeció y fue sepultado, y resucitó al tercer día, según las Escrituras, y subió al cielo, y está sentado a la derecha del Padre; y de nuevo vendrá con gloria para juzgar a vivos y muertos, y su reino no tendrá fin. Creo en el Espíritu Santo, Señor y dador de vida, que procede del Padre y del Hijo, que con el Padre y el Hijo recibe una misma adoración y gloria, y que habló por los profetas. Creo en la Iglesia, que es una, santa, católica y apostólica. Confieso que hay un solo Bautismo para el perdón de los pecados. Espero la resurrección de los muertos y la vida del mundo futuro. Amén."
            ),
            .init(
                id: "the-jesus-prayer-es",
                title: "The Jesus Prayer",
                attribution: "Eastern Christian tradition",
                focus: "Simple invocation of Jesus’ mercy",
                fullText: "Señor Jesucristo, Hijo de Dios, ten misericordia de mí, pecador."
            ),
            .init(
                id: "come-holy-spirit-es",
                title: "Come, Holy Spirit",
                attribution: "Traditional Catholic hymn",
                focus: "Invocation of the Holy Spirit",
                fullText: "Ven, Espíritu Creador, visita las almas de tus fieles y llena de la divina gracia los corazones que tú mismo creaste. Tú, llamado Consolador, don del Dios Altísimo, fuente viva, fuego, caridad y espiritual unción."
            ),
            .init(
                id: "nunc-dimittis-es",
                title: "Nunc Dimittis",
                attribution: "Gospel prayer, Luke 2:29–32",
                focus: "Peaceful recognition of Christ",
                fullText: "Ahora, Señor, según tu promesa, puedes dejar a tu siervo irse en paz, porque mis ojos han visto a tu Salvador, a quien has presentado ante todos los pueblos: luz para alumbrar a las naciones y gloria de tu pueblo Israel."
            ),
            .init(
                id: "te-deum-es",
                title: "Te Deum",
                attribution: "Ancient Christian hymn",
                focus: "Praise of the Trinity and the Church",
                fullText: "Tú eres Dios: te alabamos; tú eres el Señor: te aclamamos; tú eres el Padre eterno: toda la creación te adora. A ti todos los ángeles, las potencias del cielo, los querubines y serafines te cantan sin cesar."
            ),
        ],
        "healing-liberation": [
            .init(
                id: "el-eterno-reposo-es",
                title: "El eterno reposo",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Súplica por los difuntos",
                fullText: "Dale Señor el descanso eterno. Brille para él la luz perpetua. Descanse en paz. Amén."
            ),
            .init(
                id: "act-of-contrition-es",
                title: "Act of Contrition",
                attribution: "Traditional sacramental prayer",
                focus: "Repentance and return to God",
                fullText: "Dios mío, me arrepiento de todo corazón de haberte ofendido y detesto todos mis pecados, porque temo perder el cielo y merecer el infierno, pero sobre todo porque te ofenden a ti, que eres tan bueno y digno de todo mi amor. Propongo firmemente, con la ayuda de tu gracia, no pecar más y evitar las ocasiones próximas de pecado. Amén."
            ),
            .init(
                id: "prayer-to-our-lady-of-lourdes-es",
                title: "Prayer to Our Lady of Lourdes",
                attribution: "Traditional Catholic devotion",
                focus: "Petition for healing under Mary’s care",
                fullText: "Madre bendita de Lourdes, te apareciste a Bernardita como la Inmaculada Concepción. Alcánzanos un corazón purificado por la conversión, fortaleza en la enfermedad y confianza en la misericordia de tu Hijo. Ruega por los enfermos y condúcenos a la sanación que Dios quiere. Amén."
            ),
            .init(
                id: "prayer-to-the-sacred-heart-es",
                title: "Prayer to the Sacred Heart",
                attribution: "Traditional Catholic devotion",
                focus: "Healing through Christ’s merciful Heart",
                fullText: "Sacratísimo Corazón de Jesús, pongo toda mi confianza en ti. Cuando tenga miedo, haz que acuda a ti; cuando esté herido, haz que permanezca cerca de ti; cuando haya pecado, haz que vuelva a tu misericordia. Haz mi corazón semejante al tuyo, paciente y humilde. Amén."
            ),
            .init(
                id: "prayer-of-st-augustine-es",
                title: "Prayer of St Augustine",
                attribution: "St Augustine",
                focus: "Purification of thought and desire",
                saintID: "agostinho",
                fullText: "Respira en mí, oh Espíritu Santo, para que mis pensamientos sean santos. Actúa en mí, oh Espíritu Santo, para que también mi trabajo sea santo. Atrae mi corazón, oh Espíritu Santo, para que ame solamente lo santo. Fortaléceme, oh Espíritu Santo, para defender lo santo. Guárdame, pues, oh Espíritu Santo, para que sea siempre santo. Amén."
            ),
            .init(
                id: "prayer-for-the-sick-es",
                title: "Prayer for the Sick",
                attribution: "Traditional Catholic petition",
                focus: "Compassion and strength in illness",
                fullText: "Señor Jesucristo, médico de las almas y de los cuerpos, permanece cerca de los enfermos. Dales paciencia, fortalece a quienes los cuidan, guía las manos de quienes los tratan y permite que la Iglesia los acompañe con oración y caridad. Que tu misericordia se conozca en todo lugar de sufrimiento. Amén."
            ),
        ],
        "peace-surrender": [
            .init(
                id: "padre-nuestro-es",
                title: "Padre nuestro",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "La oración del Señor",
                fullText: "Padre nuestro que estás en el cielo, santificado sea tu Nombre; venga a nosotros tu Reino; hágase tu voluntad en la tierra como en el cielo. Danos hoy nuestro pan de cada día; perdona nuestras ofensas, como también nosotros perdonamos a los que nos ofenden; no nos dejes caer en la tentación, y líbranos del mal. Amén."
            ),
            .init(
                id: "ave-mar-a-es",
                title: "Ave María",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Oración mariana común",
                fullText: "Dios te salve, María, llena eres de gracia; el Señor es contigo. Bendita Tú eres entre todas las mujeres, y bendito es el fruto de tu vientre, Jesús. Santa María, Madre de Dios, ruega por nosotros, pecadores, ahora y en la hora de nuestra muerte. Amén."
            ),
            .init(
                id: "el-ngelus-es",
                title: "El Ángelus",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Oración de la Encarnación",
                fullText: "El ángel del Señor anunció a María. Y concibió por obra y gracia del Espíritu Santo. Dios te salve, María... He aquí la esclava del Señor. Hágase en mí según tu palabra. Dios te salve, María... Y el Verbo de Dios se hizo carne. Y habitó entre nosotros. Dios te salve, María... Ruega por nosotros, Santa Madre de Dios, para que seamos dignos de alcanzar las promesas de Jesucristo. Oremos. Infunde, Señor, tu gracia en nuestras almas, para que, los que hemos conocido, por el anuncio del Ángel, la Encarnación de tu Hijo Jesucristo, lleguemos por los Méritos de su Pasión y su Cruz, a la gloria de la Resurrección. Por Jesucristo Nuestro Señor. Amén. Gloria al Padre..."
            ),
            .init(
                id: "reina-del-cielo-es",
                title: "Reina del cielo",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Antífona mariana pascual",
                fullText: "Reina del cielo alégrate; aleluya. Porque el Señor a quien has merecido llevar; aleluya. Ha resucitado según su palabra; aleluya. Ruega al Señor por nosotros; aleluya. Gózate y alégrate, Virgen María; aleluya. Porque verdaderamente ha resucitado el Señor; aleluya. Oremos. Oh Dios, que por la resurrección de tu Hijo, nuestro Señor Jesucristo, has llenado el mundo de alegría, concédenos, por intercesión de su Madre, la Virgen María, llegar a alcanzar los gozos eterno. Por nuestro Señor Jesucristo. Amén."
            ),
            .init(
                id: "salve-regina-es",
                title: "Salve Regina",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Antífona mariana tradicional",
                fullText: "Dios te salve, Reina y Madre de misericordia, vida, dulzura y esperanza nuestra; Dios te salve. A ti llamamos los desterrados hijos de Eva; a ti suspiramos, gimiendo y llorando en este valle de lágrimas. Ea, pues, Señora, abogada nuestra, vuelve a nosotros esos tus ojos misericordiosos; y después de este destierro, muéstranos a Jesús, fruto bendito de tu vientre. ¡Oh, clementísima, oh piadosa, oh dulce Virgen María!"
            ),
            .init(
                id: "memorare-es",
                title: "Memorare",
                attribution: "St Bernard tradition",
                focus: "Trustful petition to Mary in distress",
                fullText: "Remember, oh piadosísima Virgen María, que jamás se ha oído decir que ninguno de cuantos han acudido a tu protección, implorando tu auxilio, haya sido abandonado. Animado por esta confianza, a ti acudo, oh Virgen de las vírgenes y Madre mía; a ti vengo, y ante ti me presento, pecador y afligido. No desprecies mis súplicas, oh Madre del Verbo encarnado, antes bien, escúchalas y acógelas benignamente. Amén."
            ),
            .init(
                id: "sub-tuum-praesidium-es",
                title: "Sub Tuum Praesidium",
                attribution: "Ancient Marian antiphon",
                focus: "Refuge under Mary’s protection",
                fullText: "Bajo tu amparo nos acogemos, santa Madre de Dios; no desprecies las súplicas que te dirigimos en nuestras necesidades; antes bien, líbranos siempre de todo peligro, oh Virgen gloriosa y bendita. Amén."
            ),
            .init(
                id: "prayer-of-trust-es",
                title: "Prayer of Trust",
                attribution: "Charles de Foucauld",
                focus: "Abandonment in God’s hands",
                fullText: "Padre mío, me abandono a ti: haz de mí lo que quieras. Sea lo que sea, te doy las gracias: estoy dispuesto a todo, lo acepto todo. Con tal de que tu voluntad se cumpla en mí y en todas tus criaturas, no deseo nada más, Dios mío. Pongo mi alma en tus manos; te la doy, Dios mío, con todo el amor de mi corazón, porque te amo y necesito entregarme a ti, ponerme en tus manos sin medida, con infinita confianza, porque tú eres mi Padre."
            ),
            .init(
                id: "suscipe-es",
                title: "Suscipe",
                attribution: "St Ignatius of Loyola",
                focus: "Offering one’s freedom and life to God",
                saintID: "inacio-loyola",
                fullText: "Toma, Señor, y recibe toda mi libertad, mi memoria, mi entendimiento y toda mi voluntad, todo mi haber y mi poseer. Tú me lo diste; a ti, Señor, lo devuelvo. Todo es tuyo: dispón de ello según tu voluntad. Dame tu amor y gracia, que esto me basta."
            ),
            .init(
                id: "prayer-of-st-thomas-more-es",
                title: "Prayer of St Thomas More",
                attribution: "St Thomas More",
                focus: "Peaceful fidelity under pressure",
                fullText: "Dame, buen Señor, deseo de estar contigo, no por miedo a los dolores de este mundo, ni por miedo a los del purgatorio, ni siquiera por las alegrías del cielo, sino simplemente por amor a ti. Dame la gracia de trabajar por tu gloria, por el bien de los demás y por mi salvación. Amén."
            ),
        ],
        "protection-combat": [
            .init(
                id: "ngel-de-dios-es",
                title: "Ángel de Dios",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Oración al ángel custodio",
                fullText: "Ángel de Dios, que eres mi custodio, pues la bondad divina me ha encomendado a ti, ilumíname, guárdame, defiéndeme y gobiérname. Amén."
            ),
            .init(
                id: "bajo-tu-protecci-n-es",
                title: "Bajo tu protección",
                attribution: "Compendio del Catecismo de la Iglesia Católica",
                focus: "Antífona mariana de protección",
                fullText: "Bajo tu amparo nos acogemos, Santa Madre de Dios; no deseches las súplicas que te dirigimos en nuestras necesidades; antes bien, líbranos siempre de todo peligro, ¡Oh Virgen gloriosa y bendita!"
            ),
            .init(
                id: "st-patrick-s-breastplate-es",
                title: "St Patrick’s Breastplate",
                attribution: "Traditional Lorica of St Patrick",
                focus: "Protection and steadfastness in Christ",
                fullText: "Cristo conmigo, Cristo delante de mí, Cristo detrás de mí, Cristo en mí, Cristo bajo mí, Cristo sobre mí, Cristo a mi derecha, Cristo a mi izquierda, Cristo donde me acuesto, Cristo donde me siento, Cristo donde me levanto. Cristo en el corazón de todo el que piensa en mí, Cristo en la boca de todo el que habla de mí, Cristo en cada ojo que me ve, Cristo en cada oído que me escucha. La salvación es del Señor."
            ),
            .init(
                id: "prayer-to-the-holy-cross-es",
                title: "Prayer to the Holy Cross",
                attribution: "Traditional Christian prayer",
                focus: "Protection beneath the Cross",
                fullText: "Que la Santa Cruz sea mi luz; que el dragón no sea mi guía. ¡Apártate, Satanás! No me aconsejes tus vanidades. Es malo lo que ofreces; bebe tú mismo tu veneno."
            ),
            .init(
                id: "prayer-to-st-raphael-es",
                title: "Prayer to St Raphael",
                attribution: "Traditional Catholic devotion",
                focus: "Protection on a journey and healing",
                fullText: "Bendito san Rafael Arcángel, amigo y compañero en el camino de la vida, acompáñame en mis viajes y protégeme de todo peligro. Guía mis pasos hacia el bien y llévame al cuidado de Dios. Amén."
            ),
            .init(
                id: "prayer-to-the-guardian-angel-es",
                title: "Prayer to the Guardian Angel",
                attribution: "Traditional Catholic prayer",
                focus: "Daily protection and guidance",
                fullText: "Ángel de Dios, que eres mi custodio, pues la bondad divina me ha encomendado a ti, ilumíname, guárdame, gobiérname y guíame. Amén."
            ),
            .init(
                id: "the-leonine-prayer-es",
                title: "The Leonine Prayer",
                attribution: "Pope Leo XIII",
                focus: "Prayer for the Church’s protection",
                fullText: "San Miguel Arcángel, defiéndenos en la batalla; sé nuestro amparo contra la perversidad y las asechanzas del demonio. Que Dios manifieste sobre él su poder, es nuestra humilde súplica; y tú, oh Príncipe de la milicia celestial, con el poder que Dios te ha conferido, arroja al infierno a Satanás y a los demás espíritus malignos que vagan por el mundo para la perdición de las almas. Amén."
            ),
        ],
    ]

}
