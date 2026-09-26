import SwiftUI

/// From what the person wrote in the evening Examen, Jev chooses a saint who
/// went through something similar and a prayer to close the day — risk +
/// saint (~65, two rounds) + prayer (~28), which JevPicker plans as two calls.
/// Only the ids travel back: what is shown is the reviewed catalog's text
/// (the saint's "why it matters today", the prayer's title), never generated.
struct ExamenSuggestion: Equatable {
    let saintID: String?
    let prayerID: String?

    static let saintPick = "saint"
    static let prayerPick = "prayer"

    /// Nil: Jev wasn't asked (personalization off, no subscription, nothing
    /// written). Otherwise the suggestion may be missing (not confident,
    /// offline) while `showCrisisFirst` still holds. A suggestion is kept
    /// with the entry, for the history and the calendar.
    @MainActor
    static func suggest(for entry: ExamenEntry) async -> (suggestion: ExamenSuggestion?, showCrisisFirst: Bool)? {
        guard let result = await JevPicker.pick(from: text(of: entry), picks) else { return nil }
        let suggestion = from(result)
        if let suggestion { ExamenHistoryStore.shared.attach(suggestion, to: entry.id) }
        return (suggestion, result.showCrisisFirst)
    }

    /// The four answers, as written, one paragraph each.
    static func text(of entry: ExamenEntry) -> String {
        [entry.gratitude, entry.lightRequest, entry.review, entry.response]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")
    }

    static func from(_ result: JevPicker.Result) -> ExamenSuggestion? {
        let saint = result[saintPick]
        let prayer = result[prayerPick]
        guard saint != nil || prayer != nil else { return nil }
        return ExamenSuggestion(saintID: saint, prayerID: prayer)
    }

    static var picks: [JevPicker.Pick] {
        [
            .init(key: saintPick,
                  instructions: "In tonight's examination of conscience, this person wrote about their day. Which saint went through something most similar to what they are living?",
                  candidates: saintCandidates,
                  // Sixty-odd options, asked in rounds, spread the probability thin.
                  minimumConfidence: 0.25),
            .init(key: prayerPick,
                  instructions: "In tonight's examination of conscience, this person wrote about their day. Which prayer best fits to close their day?",
                  candidates: prayerCandidates,
                  minimumConfidence: 0.25),
        ]
    }

    /// Every saint the Saints screens can open (bundled or published), by the
    /// id they share across languages. Jev reads English best, so each is
    /// described from the English record when there is one: who they were and
    /// why they matter today, cut at 400 characters by JevPicker.
    static var saintCandidates: [JevPicker.Candidate] {
        var seen = Set<String>()
        let saints = MockSaints.calendar.map(\.saint).filter { seen.insert($0.id).inserted }
        let english = RemoteContent.items("saints", language: .en, as: PublishedSaint.self)?.map(\.saintOfDay)
            ?? MockSaints.catalog[.en]
        let englishByID = Dictionary(english.map { ($0.saint.id, $0.saint) }, uniquingKeysWith: { first, _ in first })
        return saints.map { saint in
            let record = englishByID[saint.id] ?? saint
            let why = record.whyItMattersToday.isEmpty ? "" : " Why it matters today: \(record.whyItMattersToday)"
            let life = record.bioParagraphs.first.map { " \($0)" } ?? ""
            return JevPicker.Candidate(id: saint.id, description: "\(record.name), \(record.role).\(why)\(life)")
        }
    }

    /// The devotional prayers, in the language shown: their ids are per
    /// language (each language has its own published wording, not a
    /// translation), so there is no English record to describe them from.
    static var prayerCandidates: [JevPicker.Candidate] {
        prayers.map { prayer in
            let by = prayer.attribution.map { " (\($0))" } ?? ""
            return JevPicker.Candidate(id: prayer.id, description: "\(prayer.title)\(by): \(prayer.focus)")
        }
    }

    /// Each prayer once — the catalog carries some twice ("The Magnificat"
    /// and "Magnificat") — and at most 32, so the prayer is one question and
    /// the whole Examen stays within two calls next to the saints' rounds.
    /// Beyond 32 (a larger published catalog), the last ones are left out.
    static var prayers: [DevotionalPrayer] {
        var ids = Set<String>()
        var titles = Set<String>()
        let unique = MockDevotionalPrayers.categories.flatMap(\.prayers).filter { prayer in
            let title = prayer.title.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)
                .replacingOccurrences(of: "^(the|o|a|el|la) ", with: "", options: .regularExpression)
            return ids.insert(prayer.id).inserted && titles.insert(title).inserted
        }
        return Array(unique.prefix(JevPicker.maxCriteria))
    }

    /// The records to show — nil when the catalog no longer has them (a saint
    /// unpublished, a prayer from another language).
    var saint: Saint? { saintID.flatMap(MockSaints.saint(withID:)) }
    var prayer: DevotionalPrayer? {
        prayerID.flatMap { id in MockDevotionalPrayers.categories.flatMap(\.prayers).first { $0.id == id } }
    }
}

extension ExamenEntry {
    var suggestion: ExamenSuggestion? {
        saintID == nil && prayerID == nil ? nil : ExamenSuggestion(saintID: saintID, prayerID: prayerID)
    }
}

/// The saint and the prayer chosen from an Examen: on the closing screen, in
/// the Examen history, and on the calendar's day. Each opens its own page;
/// one that doesn't resolve is left out, and with neither, nothing shows.
struct ExamenSuggestionCard: View {
    let suggestion: ExamenSuggestion
    /// The Examen's own screens are dark; the calendar is light.
    var onDark = true

    private var ink: Color { onDark ? .white : Palette.ink }
    private var accent: Color { onDark ? Palette.goldBright : Palette.wine }

    var body: some View {
        let saint = suggestion.saint
        let prayer = suggestion.prayer
        if saint != nil || prayer != nil {
            VStack(alignment: .leading, spacing: 14) {
                Text(L.string("Escolhido a partir do seu Exame", table: "Today"))
                    .font(MissaleFont.body(11, weight: .semibold))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(accent)
                if let saint { saintRow(saint) }
                if let prayer { prayerRow(prayer) }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(onDark ? Color.white.opacity(0.08) : Color.white.opacity(0.55),
                        in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(onDark ? Color.white.opacity(0.14) : Color.white.opacity(0.7), lineWidth: 1))
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("examenSuggestion")
        }
    }

    private func saintRow(_ saint: Saint) -> some View {
        NavigationLink {
            SaintDetailView(saint: saint)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                SaintPortrait(artworkName: saint.artworkName, cornerRadius: 10)
                    .frame(width: 52, height: 64)
                VStack(alignment: .leading, spacing: 4) {
                    Text(saint.name)
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(ink)
                    // The reviewed "why it matters today"; a record without one
                    // still has its role.
                    Text(saint.whyItMattersToday.isEmpty ? saint.role : saint.whyItMattersToday)
                        .font(MissaleFont.body(14))
                        .foregroundStyle(ink.opacity(0.7))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").foregroundStyle(accent)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("examenSuggestionSaint")
    }

    private func prayerRow(_ prayer: DevotionalPrayer) -> some View {
        NavigationLink {
            DevotionalPrayerDetailView(prayer: prayer)
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(L.string("Uma oração para encerrar o dia", table: "Today"))
                        .font(MissaleFont.body(13))
                        .foregroundStyle(ink.opacity(0.6))
                    Text(prayer.title)
                        .font(MissaleFont.body(17, weight: .medium))
                        .foregroundStyle(ink)
                        .multilineTextAlignment(.leading)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").foregroundStyle(accent)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("examenSuggestionPrayer")
    }
}
