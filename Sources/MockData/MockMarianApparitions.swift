import Foundation

enum MockMarianApparitions {
    /// Each language is sourced and edited independently. The generated catalog
    /// has no Portuguese fallback so an incomplete delivery cannot silently put
    /// Portuguese content into the English or Spanish calendar.
    static var all: [MarianApparition] { catalog.current }

    /// One generated file per research batch, so reimporting one never drops
    /// the other: the first batch comes from ~/Documents, the second from
    /// scripts/lotes/aparicoes-segundo-lote.
    static let catalog = LocalizedCatalog(
        pt: ptApparitions + ptApparitionsSecondBatch,
        en: enApparitions + enApparitionsSecondBatch,
        es: esApparitions + esApparitionsSecondBatch
    )
}
