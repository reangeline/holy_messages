import Foundation

/// The crisis line offered on the pastoral-care screens.
///
/// This was a single hardcoded "988" — the United States line — shown to every
/// reader in every language. The label said "· United States", so it was at
/// least honest, but someone in crisis in Brazil was being handed a number that
/// does not answer from a Brazilian phone. A crisis card is the one place in
/// this app where the wrong content is not a cosmetic bug.
///
/// One entry per language, resolved like any other content catalog.
struct CrisisLine {
    /// Country or region whose line this is, spelled for the reader.
    let regionLabel: String
    /// The number as it should be dialled locally.
    let number: String
    /// Name of the service, so the reader can recognize it.
    let serviceName: String
    /// What the service offers — hours, cost, confidentiality.
    let detail: String
    /// `tel:` and `sms:` targets. `sms` is nil where the service has no SMS.
    let telURL: String
    let smsURL: String?
}

enum CrisisLines {
    static var current: CrisisLine { catalog.current }

    static let catalog = LocalizedCatalog(pt: brazil, en: unitedStates, es: mexico)

    /// CVV — Centro de Valorização da Vida. Free, 24h, nationwide in Brazil,
    /// and the line Brazilian public-health material itself points to.
    /// Verified against cvv.org.br on 22 Sep 2026: "Converse gratuitamente com
    /// um dos nossos voluntários, em todo o Brasil, 24 horas por dia — LIGUE
    /// 188."
    static let brazil = CrisisLine(
        regionLabel: "Brasil",
        number: "188",
        serviceName: "CVV — Centro de Valorização da Vida",
        detail: "Apoio emocional e prevenção do suicídio. Ligação gratuita, a qualquer hora, sigilosa.",
        telURL: "tel:188",
        smsURL: nil
    )

    /// 988 Suicide & Crisis Lifeline.
    /// Verified against 988lifeline.org on 22 Sep 2026: available 24/7/365,
    /// free and confidential, reachable by both call and text — which is why
    /// this is the one entry here that carries an `smsURL`.
    static let unitedStates = CrisisLine(
        regionLabel: "United States",
        number: "988",
        serviceName: "988 Suicide & Crisis Lifeline",
        detail: "Call or text, any hour, free and confidential.",
        telURL: "tel:988",
        smsURL: "sms:988"
    )

    /// Línea de la Vida, the Mexican federal line. Verified against
    /// gob.mx/conasama on 22 Sep 2026: 800 911 2000, free, 24 hours a day, 365
    /// days a year, nationwide.
    ///
    /// The doubt recorded here was well placed, but it was about the operator,
    /// not the number: the line moved from CONADIC to **CONASAMA** (Comisión
    /// Nacional de Salud Mental y Adicciones). The number did not change, and
    /// the service now covers mental health explicitly — emotional pain,
    /// depression, anxiety and suicide attempt — not only addictions, which is
    /// what `detail` below claims.
    static let mexico = CrisisLine(
        regionLabel: "México",
        number: "800 911 2000",
        serviceName: "Línea de la Vida",
        detail: "Apoyo emocional y prevención del suicidio. Llamada gratuita, a cualquier hora, confidencial.",
        telURL: "tel:8009112000",
        smsURL: nil
    )
}
