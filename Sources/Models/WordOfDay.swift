import Foundation

/// Own file because the widget extension compiles this type too — see the
/// MissaleWidgetsExtension sources in project.yml.
struct WordOfDay: Identifiable, Codable, Hashable {
    let id: String
    let quote: String
    let reference: String
    let translationNote: String // e.g. "Douay-Rheims, domínio público"
    let context: String
}

extension WordOfDay {
    /// "António Pereira de Figueiredo · 1896" — the edition, short. The full
    /// note (volume, city, spelling, PDF pages, "not the current liturgical
    /// translation") was printed under every verse; the complete list of
    /// editions lives in the Terms of Use, §3.
    var shortSource: String {
        let note = translationNote
        let ano = note.range(of: #"\b1[5-9]\d\d\b"#, options: .regularExpression).map { String(note[$0]) }
        // O nome da edição vai até a primeira vírgula, parêntese, ponto e
        // vírgula, "·" ou fim de frase.
        let corte = note.range(of: #"[,(;·]|\. "#, options: .regularExpression)?.lowerBound ?? note.endIndex
        var autor = String(note[..<corte])
        if let ano { autor = autor.replacingOccurrences(of: ano, with: "") }
        autor = autor.split(separator: " ").joined(separator: " ")
            .trimmingCharacters(in: .whitespaces.union(CharacterSet(charactersIn: ".")))
        guard !autor.isEmpty else { return note }
        return ano.map { "\(autor) · \($0)" } ?? autor
    }
}
