import Foundation

/// Compline's texts, one published edition per language.
///
/// The Portuguese on this screen used to be the CNBB's Liturgia das Horas
/// wording, which is licensed, and the English and Spanish readers saw it
/// untranslated. Each language now quotes an edition in the public domain:
///
/// - pt — Matos Soares, 1956. Public domain under Brazilian copyright law,
///   article 45: the translator died in 1957 leaving no successors.
/// - en — Douay-Rheims, American Edition of 1899.
/// - es — Don Félix Torres Amat, Tomo VII (Salmos and Proverbios), Librería de
///   los Sres. D. Vicente Salvá é Hijo, Paris, 1836 — the same facsimile the
///   Examen's Spanish psalms come from. Facsimile pages recorded below; the
///   historical spelling is kept as printed.
///
/// The psalm is labelled in the Hebrew numbering the app displays everywhere
/// (Psalm 91); all three editions print it as Psalm XC, which the source line
/// says. The doxology is the Compendium of the Catechism's, matching the
/// wording already in `MockDevotionalPrayers` so the app has one version of it.
enum MockCompline {
    static var today: ComplineText { catalog.current }

    static let catalog = LocalizedCatalog(pt: pt, en: en, es: es)

    private static let pt = ComplineText(
        opening: "Restaura-nos, ó Deus, salvador nosso, e depõe a tua indignação contra nós.",
        invitatory: "Apraza-te, ó Deus, libertar-me. Senhor, apressa-te em me socorrer.",
        gloryBe: "Glória ao Pai e ao Filho e ao Espírito Santo. Como era, no princípio, agora e sempre. Ámen.",
        psalmLabel: "SALMO 91",
        psalmText: "Tu que vives sob a proteção do Altíssimo, que moras à sombra do Omnipotente, diz ao Senhor: «Meu refúgio e meu baluarte, meu Deus, em quem confio.»",
        source: "Bíblia Sagrada, tradução de Matos Soares, 1956 — Salmos 84,5; 69,2; 90,1-2, na numeração da Vulgata. Doxologia: Compêndio do Catecismo da Igreja Católica.",
        note: "A abertura das Completas e o salmo da noite. Fica no aparelho, e nenhuma notificação chega enquanto esta tela está aberta."
    )

    private static let en = ComplineText(
        opening: "Convert us, O God our saviour: and turn off thy anger from us.",
        invitatory: "O God, come to my assistance; O Lord, make haste to help me.",
        gloryBe: "Glory be to the Father and to the Son and to the Holy Spirit, as it was in the beginning is now, and ever shall be world without end. Amen.",
        psalmLabel: "PSALM 91",
        psalmText: "He that dwelleth in the aid of the most High, shall abide under the protection of the God of Jacob. He shall say to the Lord: Thou art my protector, and my refuge: my God, in him will I trust.",
        source: "Douay-Rheims, American Edition of 1899 — Psalms 84:5; 69:2; 90:1-2, in the Vulgate numbering. Doxology: Compendium of the Catechism of the Catholic Church.",
        note: "The opening of Compline and the night psalm. It stays on this device, and no notification arrives while this screen is open."
    )

    private static let es = ComplineText(
        opening: "Conviértenos, oh Dios salvador nuestro, y aparta tu ira de nosotros.",
        invitatory: "Oh Dios, atiende á mi socorro: acude, Señor, luego á ayudarme.",
        gloryBe: "Gloria al Padre y al Hijo y al Espíritu Santo. Como era en el principio, ahora y siempre, por los siglos de los siglos. Amén.",
        psalmLabel: "SALMO 91",
        psalmText: "El que se acoge al asilo del Altísimo, descansará siempre bajo la protección del Dios del cielo. Él dirá al Señor: Tú eres mi amparo y refugio; el Dios mío en quien esperaré.",
        source: "Don Félix Torres Amat, Tomo VII: El libro de los Salmos y el de los Proverbios, Librería de los Sres. D. Vicente Salvá é Hijo, París, 1836 — impresos como Salmo LXXXIV, 5 (fac-símile p. 198), Salmo LXIX, 2 (p. 161) y Salmo XC, 1-2 (p. 211). Doxología: Compendio del Catecismo de la Iglesia Católica.",
        note: "La apertura de Completas y el salmo de la noche. Se queda en este dispositivo, y no llega ninguna notificación mientras esta pantalla está abierta."
    )
}
