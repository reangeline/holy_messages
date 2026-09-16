import Foundation

/// Fixed-date solemnities and feasts that can override the temporal cycle's own
/// color/rank on a weekday — a deliberately small, curated set (major universal
/// solemnities/feasts plus the handful of dates this app already had authored
/// content for), NOT the full General Roman Calendar. Keyed "MM-dd", so the
/// same entry applies every year. Extending this is a content task — see the
/// "Liturgia" tab in the Acervo tool, which mirrors this list for review.
///
/// Deliberately does NOT duplicate `MockSaints.calendar` (the fuller saint
/// biography catalog used for "Santo do dia"): that catalog can carry regional
/// or optional-memorial saints (e.g. São João Gabriel Perboyre on Sep 23) that
/// aren't strong enough to move this engine's own color/rank computation, so
/// the two lists intentionally don't have to agree on every date.
enum LiturgicalSanctoral {
    struct FixedFeast {
        let monthDay: String // "MM-dd"
        let name: String
        let rank: LiturgicalRank
        let color: LiturgicalColor
    }

    static let feasts: [FixedFeast] = [
        .init(monthDay: "02-02", name: "Apresentação do Senhor", rank: .feast, color: .white),
        .init(monthDay: "03-19", name: "São José, Esposo de Maria", rank: .solemnity, color: .white),
        .init(monthDay: "03-25", name: "Anunciação do Senhor", rank: .solemnity, color: .white),
        .init(monthDay: "06-24", name: "Natividade de São João Batista", rank: .solemnity, color: .white),
        .init(monthDay: "06-29", name: "São Pedro e São Paulo, Apóstolos", rank: .solemnity, color: .red),
        .init(monthDay: "08-15", name: "Assunção de Nossa Senhora", rank: .solemnity, color: .white),
        .init(monthDay: "09-08", name: "Natividade de Nossa Senhora", rank: .feast, color: .white),
        .init(monthDay: "09-14", name: "Exaltação da Santa Cruz", rank: .feast, color: .red),
        .init(monthDay: "09-15", name: "Nossa Senhora das Dores", rank: .memorial, color: .white),
        .init(monthDay: "11-01", name: "Todos os Santos", rank: .solemnity, color: .white),
        .init(monthDay: "12-08", name: "Imaculada Conceição de Nossa Senhora", rank: .solemnity, color: .white),
        .init(monthDay: "12-12", name: "Nossa Senhora Aparecida, Padroeira do Brasil", rank: .solemnity, color: .white),
    ]

    static func feast(monthDay: String) -> FixedFeast? {
        feasts.first { $0.monthDay == monthDay }
    }

    /// Applies the sanctoral overlay to an already-computed temporal day.
    /// Simplified precedence (not the full Table of Liturgical Days): a
    /// season's own solemnity or Sunday always wins UNLESS the fixed feast is
    /// itself a solemnity; any weekday (feria) yields fully to a fixed feast
    /// of any rank.
    static func overlay(on day: LiturgicalEngine.ComputedDay, dateKey: String) -> LiturgicalEngine.ComputedDay {
        let monthDay = String(dateKey.suffix(5))
        guard let fixed = feast(monthDay: monthDay) else { return day }
        let seasonWins = day.rank == .solemnity || (day.isHolyDayOfObligation && day.rank == .feast)
        if seasonWins && fixed.rank != .solemnity { return day }
        return LiturgicalEngine.ComputedDay(
            dateKey: day.dateKey, season: day.season, weekIndex: day.weekIndex, weekday: day.weekday, seasonLabel: day.seasonLabel,
            rank: fixed.rank, color: fixed.color, feastName: fixed.name,
            sundayCycle: day.sundayCycle, weekdayCycle: day.weekdayCycle,
            isHolyDayOfObligation: fixed.rank == .solemnity ? true : day.isHolyDayOfObligation,
            isAbstinenceDay: day.isAbstinenceDay,
            explanation: "\(fixed.name) — \(fixed.rank.rawValue.lowercased())."
        )
    }
}

extension LiturgicalEngine {
    /// The full computed day — temporal cycle plus the sanctoral overlay.
    /// This is what the rest of the app should call.
    static func day(for date: Date) -> ComputedDay {
        let base = temporalDay(for: date)
        return LiturgicalSanctoral.overlay(on: base, dateKey: base.dateKey)
    }
}
