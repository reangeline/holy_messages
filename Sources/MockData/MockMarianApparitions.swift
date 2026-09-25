import Foundation

enum MockMarianApparitions {
    /// Each language is sourced and edited independently. The generated catalog
    /// has no Portuguese fallback so an incomplete delivery cannot silently put
    /// Portuguese content into the English or Spanish calendar.
    ///
    /// What the admin page published wins. The record is published as is —
    /// its fields are all text — and the art keeps coming from the id.
    static var all: [MarianApparition] {
        let language = AppLanguagePreference.resolveCurrent()
        return RemoteContent.items("apparitions", language: language, as: MarianApparition.self) ?? catalog[language]
    }

    /// One generated file per research batch, so reimporting one never drops
    /// the other: the first batch comes from ~/Documents, the second from
    /// scripts/lotes/aparicoes-segundo-lote.
    static let catalog = LocalizedCatalog(
        pt: ptApparitions + ptApparitionsSecondBatch,
        en: enApparitions + enApparitionsSecondBatch,
        es: esApparitions + esApparitionsSecondBatch
    )
}
