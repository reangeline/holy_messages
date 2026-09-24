import Foundation

/// The crisis guidance on the pastoral-care screens.
///
/// It used to name one line per language — CVV 188, the 988 Lifeline, Línea de
/// la Vida — but a language is not a country: a Portuguese reader in Portugal
/// or a Spanish reader in Spain was handed a number that doesn't answer there.
/// The guidance is now generic by decision: point to the public support and
/// emergency services wherever the reader is, without a number of our own.
struct CrisisLine {
    let title: String
    let message: String
}

enum CrisisLines {
    static var current: CrisisLine { catalog.current }

    static let catalog = LocalizedCatalog(
        pt: CrisisLine(
            title: "Se você está em crise",
            message: "Procure os serviços públicos de apoio emocional e de saúde da sua cidade ou do seu país. Se estiver em perigo imediato, procure o serviço de emergência local."
        ),
        en: CrisisLine(
            title: "If you are in crisis",
            message: "Reach out to the public mental health and support services in your city or country. If you are in immediate danger, contact your local emergency services."
        ),
        es: CrisisLine(
            title: "Si estás en crisis",
            message: "Busca los servicios públicos de apoyo emocional y de salud de tu ciudad o de tu país. Si estás en peligro inmediato, contacta a los servicios de emergencia locales."
        )
    )
}
