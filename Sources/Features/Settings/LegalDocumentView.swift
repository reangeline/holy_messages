import SwiftUI

/// The two legal documents, read from the Markdown files bundled with the app.
///
/// This replaces a screen that printed "This text hasn't been written yet."
/// The documents live in `Legal/` at the repo root and are copied into
/// `Sources/Resources/Legal` so the app ships them — the same file the App
/// Store listing links to, rather than a second copy that drifts from it.
///
/// One file per language: they are our own prose, not liturgical text, so each
/// is written rather than machine-translated, and the three say the same thing.
enum LegalDocument: Hashable {
    case privacy
    case terms

    /// Basenames without extension, per language.
    func resourceName(for language: AppLanguage) -> String {
        switch (self, language) {
        case (.privacy, .pt): "politica-de-privacidade.pt"
        case (.privacy, .en): "privacy-policy.en"
        case (.privacy, .es): "politica-de-privacidad.es"
        case (.terms, .pt): "termos-de-uso.pt"
        case (.terms, .en): "terms-of-use.en"
        case (.terms, .es): "terminos-de-uso.es"
        }
    }
}

struct LegalDocumentView: View {
    let document: LegalDocument

    private var language: AppLanguage { AppLanguagePreference.resolveCurrent() }

    private var markdown: String? {
        let name = document.resourceName(for: language)
        guard let url = Bundle.main.url(forResource: name, withExtension: "md")
                ?? Bundle.main.url(forResource: name, withExtension: "md", subdirectory: "Legal"),
              let texto = try? String(contentsOf: url, encoding: .utf8)
        else { return nil }
        return texto
    }

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                if let markdown {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(Self.blocks(from: markdown).enumerated()), id: \.offset) { _, block in
                            view(for: block)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                } else {
                    // Não inventa um texto legal: diz que não conseguiu abrir o
                    // arquivo e manda ao endereço onde ele está publicado.
                    VStack(alignment: .leading, spacing: 10) {
                        Text("We couldn't open this document on your device.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(17, weight: .medium))
                        Text("The current version is published at missale.app, and the App Store listing links to it.", tableName: "SettingsDetail")
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.7))
                    }
                    .padding(24)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - A very small Markdown reader

    /// Only what these two documents use: one H1, H2 headings, bullets, and
    /// paragraphs with `**bold**` runs. A full Markdown engine would be more
    /// code than the documents need.
    enum Block: Equatable {
        case title(String)
        case heading(String)
        case bullet(String)
        case paragraph(String)
    }

    static func blocks(from markdown: String) -> [Block] {
        var blocks: [Block] = []
        // Linhas acumuladas e se elas pertencem a um marcador. Um parágrafo ou
        // um marcador do Markdown ocupa várias linhas do arquivo e só termina
        // na linha em branco — sem isto, a continuação de um marcador virava um
        // parágrafo solto, e a política aparecia partida no meio das frases.
        var pendente: [String] = []
        var pendenteEhMarcador = false

        func fechar() {
            let texto = pendente.joined(separator: " ").trimmingCharacters(in: .whitespaces)
            if !texto.isEmpty {
                blocks.append(pendenteEhMarcador ? .bullet(texto) : .paragraph(texto))
            }
            pendente = []
            pendenteEhMarcador = false
        }

        for linha in markdown.components(separatedBy: .newlines) {
            let corte = linha.trimmingCharacters(in: .whitespaces)
            if corte.isEmpty {
                fechar()
            } else if corte.hasPrefix("## ") {
                fechar()
                blocks.append(.heading(String(corte.dropFirst(3))))
            } else if corte.hasPrefix("# ") {
                fechar()
                blocks.append(.title(String(corte.dropFirst(2))))
            } else if corte.hasPrefix("- ") {
                fechar()
                pendente = [String(corte.dropFirst(2))]
                pendenteEhMarcador = true
            } else {
                pendente.append(corte)
            }
        }
        fechar()
        return blocks
    }

    /// `**bold**` becomes bold; everything else stays plain. Falls back to the
    /// raw string if the markup doesn't parse, so a stray asterisk never blanks
    /// a paragraph of a legal document.
    private func inline(_ text: String) -> AttributedString {
        (try? AttributedString(markdown: text)) ?? AttributedString(text)
    }

    @ViewBuilder
    private func view(for block: Block) -> some View {
        switch block {
        case .title(let text):
            Text(text)
                .font(MissaleFont.display(28, weight: .semibold))
                .foregroundStyle(Palette.ink)
                .padding(.bottom, 2)
        case .heading(let text):
            Text(text)
                .font(MissaleFont.display(20, weight: .medium))
                .foregroundStyle(Palette.ink)
                .padding(.top, 10)
        case .bullet(let text):
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("·").font(MissaleFont.body(16)).foregroundStyle(Palette.wine)
                Text(inline(text))
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.82))
            }
        case .paragraph(let text):
            Text(inline(text))
                .font(MissaleFont.body(15))
                .foregroundStyle(Palette.ink.opacity(0.82))
                .lineSpacing(3)
        }
    }
}

#Preview {
    NavigationStack { LegalDocumentView(document: .privacy) }
}
