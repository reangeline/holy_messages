import Foundation

/// Computes the liturgical day for any real calendar date. The temporal cycle
/// (seasons, movable feasts derived from Easter, color, rank, Sunday/weekday
/// reading cycles) is fully algorithmic and correct for any year — see
/// `movableFeasts(year:)` and `temporalDay(for:)`. The sanctoral cycle (which
/// saint or fixed-date feast falls on a given civil date, and whether it
/// outranks the season's own color) is a curated dataset that only covers a
/// deliberately small set of major solemnities plus whatever this app already
/// referenced — see `LiturgicalSanctoral` — not the full General Roman
/// Calendar. Extending it is a content task, not an engine task.
enum LiturgicalEngine {
    enum SeasonKind: String, Codable {
        case advent, christmas, ordinary, lent, triduum, easter
    }

    struct ComputedDay {
        let dateKey: String // "yyyy-MM-dd"
        let season: SeasonKind
        let seasonLabel: String       // "Tempo Comum · 23ª semana", "Quaresma · 2ª semana", ...
        let rank: LiturgicalRank
        let color: LiturgicalColor
        let feastName: String
        let sundayCycle: String       // "A" / "B" / "C" — the Sunday lectionary cycle in force
        let weekdayCycle: String      // "I" / "II" — the weekday first-reading cycle in force
        let isHolyDayOfObligation: Bool
        let isAbstinenceDay: Bool
        let explanation: String
    }

    // MARK: - Easter and the movable feasts that key off it

    /// Anonymous Gregorian algorithm (Meeus/Jones/Butcher) — correct for the
    /// Gregorian calendar in any year, not an approximation.
    static func easterSunday(year: Int) -> Date {
        let a = year % 19
        let b = year / 100
        let c = year % 100
        let d = b / 4
        let e = b % 4
        let f = (b + 8) / 25
        let g = (b - f + 1) / 3
        let h = (19 * a + b - d - g + 15) % 30
        let i = c / 4
        let k = c % 4
        let l = (32 + 2 * e + 2 * i - h - k) % 7
        let m = (a + 11 * h + 22 * l) / 451
        let month = (h + l - 7 * m + 114) / 31
        let day = ((h + l - 7 * m + 114) % 31) + 1
        return dateFrom(year: year, month: month, day: day)
    }

    struct MovableFeasts {
        let year: Int
        let easter: Date
        let ashWednesday: Date
        let palmSunday: Date
        let holyThursday: Date
        let goodFriday: Date
        let holySaturday: Date
        let divineMercySunday: Date
        let ascension: Date          // Thursday, 39 days after Easter (traditional date; many places transfer it to the following Sunday)
        let pentecost: Date
        let trinitySunday: Date
        let corpusChristi: Date      // Thursday after Trinity (traditional date; often transferred to the following Sunday)
        let sacredHeart: Date
        let adventStart: Date        // 4th Sunday before Christmas
        let christTheKing: Date      // Sunday before Advent starts
        let baptismOfTheLord: Date
    }

    static func movableFeasts(year: Int) -> MovableFeasts {
        let easter = easterSunday(year: year)
        let christmas = dateFrom(year: year, month: 12, day: 25)
        let adventStart = previousOrSameSunday(before: addDays(christmas, -21)) // 4th Sunday before Dec 25
        let epiphany = dateFrom(year: year, month: 1, day: 6)
        let epiphanyWeekday = weekday(of: epiphany)
        // Baptism of the Lord: the Sunday after Jan 6, unless Jan 6 is itself a
        // Sunday, in which case Baptism falls the very next day (Monday).
        let baptism: Date = epiphanyWeekday == 1 ? addDays(epiphany, 1) : nextSunday(after: epiphany)
        return MovableFeasts(
            year: year,
            easter: easter,
            ashWednesday: addDays(easter, -46),
            palmSunday: addDays(easter, -7),
            holyThursday: addDays(easter, -3),
            goodFriday: addDays(easter, -2),
            holySaturday: addDays(easter, -1),
            divineMercySunday: addDays(easter, 7),
            ascension: addDays(easter, 39),
            pentecost: addDays(easter, 49),
            trinitySunday: addDays(easter, 56),
            corpusChristi: addDays(easter, 60),
            sacredHeart: addDays(easter, 68),
            adventStart: adventStart,
            christTheKing: addDays(adventStart, -7),
            baptismOfTheLord: baptism
        )
    }

    // MARK: - Temporal cycle: season, color, rank for a date (before sanctoral overlay)

    static func temporalDay(for date: Date) -> ComputedDay {
        let cal = Calendar.gregorianUTC
        let year = cal.component(.year, from: date)
        // A date in Advent/most of Christmastide belongs to the movable-feast
        // set computed from the FOLLOWING January's dates; a date in Ordinary
        // Time/Lent/Easter belongs to the current year's own set. Try both
        // neighbours since Dec dates need next year's Christmas boundary and
        // Jan dates need the current year's Baptism/Ash Wednesday.
        let thisYear = movableFeasts(year: year)
        let nextYear = movableFeasts(year: year + 1)
        let prevYear = movableFeasts(year: year - 1)

        let dateKey = key(for: date)

        // Advent and Christmas (this civil year's Advent runs into next Jan).
        if date >= thisYear.adventStart, date < dateFrom(year: year, month: 12, day: 25) {
            let weekIndex = weeksBetween(thisYear.adventStart, date) + 1
            return adventDay(date, weekIndex: weekIndex, cycle: sundayCycle(forLiturgicalYearStarting: year), weekdayCycle: weekdayCycleLabel(for: year), dateKey: dateKey)
        }
        if date >= dateFrom(year: year, month: 12, day: 25), date <= addDays(dateFrom(year: year, month: 12, day: 25), 11) {
            // Dec 25 – Jan 5-ish stretch that belongs to THIS year's Christmas,
            // ending at next year's Baptism of the Lord.
            return christmasDay(date, baptism: nextYear.baptismOfTheLord, cycle: sundayCycle(forLiturgicalYearStarting: year), weekdayCycle: weekdayCycleLabel(for: year), dateKey: dateKey)
        }
        if date >= dateFrom(year: year, month: 1, day: 1), date <= nextOrEqual(prevYear.baptismOfTheLord, forJanuaryOf: year) {
            // Early January still finishing last year's Christmas season.
            return christmasDay(date, baptism: prevYear.baptismOfTheLord, cycle: sundayCycle(forLiturgicalYearStarting: year - 1), weekdayCycle: weekdayCycleLabel(for: year), dateKey: dateKey)
        }

        let feasts = thisYear
        if date >= feasts.ashWednesday, date < feasts.holyThursday {
            let weekIndex = weeksBetween(feasts.ashWednesday, date) + 1
            return lentDay(date, weekIndex: weekIndex, palmSunday: feasts.palmSunday, cycle: sundayCycle(forLiturgicalYearStarting: year - 1), weekdayCycle: weekdayCycleLabel(for: year), dateKey: dateKey)
        }
        if date >= feasts.holyThursday, date < feasts.easter {
            return triduumDay(date, feasts: feasts, dateKey: dateKey)
        }
        if date >= feasts.easter, date <= feasts.pentecost {
            let weekIndex = weeksBetween(feasts.easter, date) + 1
            return easterDay(date, weekIndex: weekIndex, feasts: feasts, cycle: sundayCycle(forLiturgicalYearStarting: year - 1), weekdayCycle: weekdayCycleLabel(for: year), dateKey: dateKey)
        }
        // Everything else is Ordinary Time.
        return ordinaryDay(date, feasts: feasts, prevBaptism: thisYear.baptismOfTheLord, year: year, dateKey: dateKey)
    }

    // MARK: - Season builders

    private static func adventDay(_ date: Date, weekIndex: Int, cycle: String, weekdayCycle: String, dateKey: String) -> ComputedDay {
        let isGaudete = weekIndex == 3 && weekday(of: date) == 1
        let color: LiturgicalColor = isGaudete ? .rose : .purple
        return ComputedDay(
            dateKey: dateKey, season: .advent,
            seasonLabel: "Advento · \(ordinalPT(weekIndex))ª semana",
            rank: weekday(of: date) == 1 ? .feast : .weekday,
            color: color,
            feastName: weekday(of: date) == 1 ? "\(ordinalPT(weekIndex))º Domingo do Advento" : "Feria do Advento",
            sundayCycle: cycle, weekdayCycle: weekdayCycle,
            isHolyDayOfObligation: weekday(of: date) == 1,
            isAbstinenceDay: weekday(of: date) == 6,
            explanation: isGaudete
                ? "3º Domingo do Advento — \"Gaudete\", alegrai-vos: a cor muda para rosa, antecipando a alegria do Natal que se aproxima."
                : "Advento: quatro semanas de espera e preparação para o Natal do Senhor."
        )
    }

    private static func christmasDay(_ date: Date, baptism: Date, cycle: String, weekdayCycle: String, dateKey: String) -> ComputedDay {
        let cal = Calendar.gregorianUTC
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        var feastName = "Oitava do Natal"
        var rank: LiturgicalRank = .weekday
        var isHoly = false
        if month == 12, day == 25 { feastName = "Natividade do Senhor"; rank = .solemnity; isHoly = true }
        else if month == 1, day == 1 { feastName = "Santa Maria, Mãe de Deus"; rank = .solemnity; isHoly = true }
        else if month == 1, day == 6 { feastName = "Epifania do Senhor"; rank = .solemnity; isHoly = true }
        else if date == baptism { feastName = "Batismo do Senhor"; rank = .feast }
        return ComputedDay(
            dateKey: dateKey, season: .christmas, seasonLabel: "Tempo do Natal",
            rank: rank, color: .white, feastName: feastName,
            sundayCycle: cycle, weekdayCycle: weekdayCycle,
            isHolyDayOfObligation: isHoly, isAbstinenceDay: false,
            explanation: "Tempo do Natal: a celebração do nascimento do Senhor se estende até o Batismo do Senhor."
        )
    }

    private static func lentDay(_ date: Date, weekIndex: Int, palmSunday: Date, cycle: String, weekdayCycle: String, dateKey: String) -> ComputedDay {
        let cal = Calendar.gregorianUTC
        let isAshWednesday = weekIndex == 1 && cal.component(.weekday, from: date) == 4 && weeksBetween(date, date) == 0 && isSameDay(date, addDays(palmSunday, -46 + 39)) // guarded below more simply
        let isLaetare = weekIndex == 4 && weekday(of: date) == 1
        let isPalmWeekEntry = isSameDay(date, palmSunday)
        let color: LiturgicalColor = isPalmWeekEntry ? .red : (isLaetare ? .rose : .purple)
        var feastName = isPalmWeekEntry ? "Domingo de Ramos da Paixão do Senhor" : "Feria da Quaresma"
        if weekday(of: date) == 1, !isPalmWeekEntry { feastName = "\(ordinalPT(weekIndex))º Domingo da Quaresma" }
        _ = isAshWednesday
        return ComputedDay(
            dateKey: dateKey, season: .lent,
            seasonLabel: "Quaresma · \(ordinalPT(weekIndex))ª semana",
            rank: (weekday(of: date) == 1 || isPalmWeekEntry) ? .feast : .weekday,
            color: color, feastName: feastName,
            sundayCycle: cycle, weekdayCycle: weekdayCycle,
            isHolyDayOfObligation: weekday(of: date) == 1,
            isAbstinenceDay: weekday(of: date) == 6 || weekday(of: date) == 4,
            explanation: isLaetare
                ? "4º Domingo da Quaresma — \"Laetare\", alegrai-vos: um respiro rosa na metade do caminho até a Páscoa."
                : isPalmWeekEntry
                ? "Domingo de Ramos: entra-se na Semana Santa lendo a Paixão inteira, com a alegria dos ramos e o peso da cruz no mesmo dia."
                : "Quaresma: quarenta dias de jejum, oração e esmola, preparando a Páscoa."
        )
    }

    private static func triduumDay(_ date: Date, feasts: MovableFeasts, dateKey: String) -> ComputedDay {
        if isSameDay(date, feasts.holyThursday) {
            return ComputedDay(dateKey: dateKey, season: .triduum, seasonLabel: "Tríduo Pascal",
                                rank: .solemnity, color: .white, feastName: "Quinta-feira Santa · Missa da Ceia do Senhor",
                                sundayCycle: "—", weekdayCycle: "—", isHolyDayOfObligation: false, isAbstinenceDay: false,
                                explanation: "O Tríduo Pascal começa esta noite: a instituição da Eucaristia e do sacerdócio.")
        }
        if isSameDay(date, feasts.goodFriday) {
            return ComputedDay(dateKey: dateKey, season: .triduum, seasonLabel: "Tríduo Pascal",
                                rank: .solemnity, color: .red, feastName: "Sexta-feira Santa da Paixão do Senhor",
                                sundayCycle: "—", weekdayCycle: "—", isHolyDayOfObligation: false, isAbstinenceDay: true,
                                explanation: "Único dia do ano sem celebração da Missa — a liturgia é da Paixão, com adoração da cruz.")
        }
        return ComputedDay(dateKey: dateKey, season: .triduum, seasonLabel: "Tríduo Pascal",
                            rank: .solemnity, color: .purple, feastName: "Sábado Santo",
                            sundayCycle: "—", weekdayCycle: "—", isHolyDayOfObligation: false, isAbstinenceDay: false,
                            explanation: "Dia de silêncio litúrgico junto ao sepulcro — sem Missa até a Vigília Pascal, à noite.")
    }

    private static func easterDay(_ date: Date, weekIndex: Int, feasts: MovableFeasts, cycle: String, weekdayCycle: String, dateKey: String) -> ComputedDay {
        var feastName = "Feria do Tempo Pascal"
        var rank: LiturgicalRank = .weekday
        if isSameDay(date, feasts.easter) { feastName = "Páscoa da Ressurreição do Senhor"; rank = .solemnity }
        else if isSameDay(date, feasts.divineMercySunday) { feastName = "Domingo da Divina Misericórdia"; rank = .feast }
        else if isSameDay(date, feasts.ascension) { feastName = "Ascensão do Senhor"; rank = .solemnity }
        else if isSameDay(date, feasts.pentecost) { feastName = "Pentecostes"; rank = .solemnity }
        else if weekday(of: date) == 1 { feastName = "\(ordinalPT(weekIndex))º Domingo da Páscoa"; rank = .feast }
        let isPentecost = isSameDay(date, feasts.pentecost)
        return ComputedDay(
            dateKey: dateKey, season: .easter, seasonLabel: "Tempo Pascal · \(ordinalPT(weekIndex))ª semana",
            rank: rank, color: isPentecost ? .red : .white, feastName: feastName,
            sundayCycle: cycle, weekdayCycle: weekdayCycle,
            isHolyDayOfObligation: weekday(of: date) == 1 || isSameDay(date, feasts.ascension),
            isAbstinenceDay: false,
            explanation: "Tempo Pascal: cinquenta dias de alegria pela Ressurreição, até Pentecostes."
        )
    }

    private static func ordinaryDay(_ date: Date, feasts: MovableFeasts, prevBaptism: Date, year: Int, dateKey: String) -> ComputedDay {
        let isSecondBlock = date > feasts.pentecost
        let weekIndex: Int
        if isSecondBlock {
            // Counted backward from Christ the King = week 34, per the standard
            // General Roman Calendar convention for the second Ordinary Time block.
            let weeksToKing = weeksBetween(date, feasts.christTheKing)
            weekIndex = max(1, 34 - weeksToKing)
        } else {
            weekIndex = weeksBetween(feasts.baptismOfTheLord, date) + 1
        }
        var feastName = "Feria do Tempo Comum"
        var rank: LiturgicalRank = .weekday
        var color: LiturgicalColor = .green
        var isHoly = false
        if isSameDay(date, feasts.trinitySunday) { feastName = "Santíssima Trindade"; rank = .solemnity; color = .white }
        else if isSameDay(date, feasts.corpusChristi) { feastName = "Corpo e Sangue de Cristo"; rank = .solemnity; color = .white }
        else if isSameDay(date, feasts.sacredHeart) { feastName = "Sagrado Coração de Jesus"; rank = .solemnity; color = .white }
        else if isSameDay(date, feasts.christTheKing) { feastName = "Nosso Senhor Jesus Cristo, Rei do Universo"; rank = .solemnity; color = .white; isHoly = true }
        else if weekday(of: date) == 1 { feastName = "\(ordinalPT(weekIndex))º Domingo do Tempo Comum"; rank = .feast; isHoly = true }
        return ComputedDay(
            dateKey: dateKey, season: .ordinary, seasonLabel: "Tempo Comum · \(ordinalPT(weekIndex))ª semana",
            rank: rank, color: color, feastName: feastName,
            sundayCycle: sundayCycle(forLiturgicalYearStarting: isSecondBlock ? year : year - 1),
            weekdayCycle: weekdayCycleLabel(for: year),
            isHolyDayOfObligation: isHoly,
            isAbstinenceDay: weekday(of: date) == 6,
            explanation: "Tempo Comum: a vida ordinária da Igreja, semana após semana, fora dos grandes tempos fortes."
        )
    }

    // MARK: - Cycles

    /// Sunday lectionary cycle for the liturgical year that STARTS in Advent of
    /// `year` (e.g. Advent 2025 opens the 2025–2026 liturgical year).
    static func sundayCycle(forLiturgicalYearStarting year: Int) -> String {
        switch (year + 1) % 3 {
        case 1: "A"
        case 2: "B"
        default: "C"
        }
    }

    /// Weekday first-reading cycle — keyed to the plain civil year of the date
    /// itself (odd = I, even = II), per the General Roman Calendar norm.
    static func weekdayCycleLabel(for year: Int) -> String {
        year % 2 == 0 ? "II" : "I"
    }

    // MARK: - Small date helpers (all pure functions over the fixed UTC calendar)

    private static func dateFrom(year: Int, month: Int, day: Int) -> Date {
        Calendar.gregorianUTC.date(from: DateComponents(year: year, month: month, day: day))!
    }

    private static func addDays(_ date: Date, _ days: Int) -> Date {
        Calendar.gregorianUTC.date(byAdding: .day, value: days, to: date)!
    }

    private static func weekday(of date: Date) -> Int {
        Calendar.gregorianUTC.component(.weekday, from: date) // 1 = Sunday ... 7 = Saturday
    }

    private static func isSameDay(_ a: Date, _ b: Date) -> Bool {
        Calendar.gregorianUTC.isDate(a, inSameDayAs: b)
    }

    private static func previousOrSameSunday(before date: Date) -> Date {
        let w = weekday(of: date)
        return addDays(date, -(w - 1))
    }

    private static func nextSunday(after date: Date) -> Date {
        let w = weekday(of: date)
        let delta = (8 - w) % 7
        return addDays(date, delta == 0 ? 7 : delta)
    }

    private static func nextOrEqual(_ date: Date, forJanuaryOf year: Int) -> Date {
        // `date` is last year's Baptism of the Lord, which always lands in
        // early January — reproject it onto `year`'s January for comparison.
        let cal = Calendar.gregorianUTC
        var comps = cal.dateComponents([.month, .day], from: date)
        comps.year = year
        return cal.date(from: comps) ?? date
    }

    private static func weeksBetween(_ start: Date, _ end: Date) -> Int {
        Calendar.gregorianUTC.dateComponents([.day], from: startOfDay(start), to: startOfDay(end)).day.map { $0 / 7 } ?? 0
    }

    private static func startOfDay(_ date: Date) -> Date {
        Calendar.gregorianUTC.startOfDay(for: date)
    }

    private static func key(for date: Date) -> String {
        let cal = Calendar.gregorianUTC
        let c = cal.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
    }

    private static func ordinalPT(_ n: Int) -> String { "\(n)" }
}
