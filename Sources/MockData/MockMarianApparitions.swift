import Foundation

enum MockMarianApparitions {
    /// Each language is sourced and edited independently. The generated catalog
    /// has no Portuguese fallback so an incomplete delivery cannot silently put
    /// Portuguese content into the English or Spanish calendar.
    static var all: [MarianApparition] { catalog.current }

    static let catalog = LocalizedCatalog(
        pt: ptApparitions,
        en: enApparitions,
        es: esApparitions
    )
}
