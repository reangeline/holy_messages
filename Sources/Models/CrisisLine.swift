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
    /// Source: cvv.org.br. NEEDS A FINAL CHECK before publishing.
    static let brazil = CrisisLine(
        regionLabel: "Brasil",
        number: "188",
        serviceName: "CVV — Centro de Valorização da Vida",
        detail: "Apoio emocional e prevenção do suicídio. Ligação gratuita, a qualquer hora, sigilosa.",
        telURL: "tel:188",
        smsURL: nil
    )

    /// 988 Suicide & Crisis Lifeline.
    /// Source: 988lifeline.org. NEEDS A FINAL CHECK before publishing.
    static let unitedStates = CrisisLine(
        regionLabel: "United States",
        number: "988",
        serviceName: "988 Suicide & Crisis Lifeline",
        detail: "Call or text, any hour, free and confidential.",
        telURL: "tel:988",
        smsURL: "sms:988"
    )

    /// Línea de la Vida, the Mexican federal line (CONADIC / Secretaría de
    /// Salud). This one I am least sure of — the number has changed form over
    /// the years. MUST BE CONFIRMED against gob.mx before publishing; until
    /// then treat the Spanish card as unverified.
    static let mexico = CrisisLine(
        regionLabel: "México",
        number: "800 911 2000",
        serviceName: "Línea de la Vida",
        detail: "Apoyo emocional y prevención del suicidio. Llamada gratuita, a cualquier hora, confidencial.",
        telURL: "tel:8009112000",
        smsURL: nil
    )
}
