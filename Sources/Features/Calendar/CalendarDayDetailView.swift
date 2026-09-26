import SwiftUI

/// t4 screen 9 — detail for a specific day. Push/detail screen, no tab bar.
/// Genuinely functional, not a mockup: what the reader did and wrote that day
/// (see DayRecord), or an honest "nothing registered" state — never a canned
/// example. See spec §1.5.
struct CalendarDayDetailView: View {
    let mark: CalendarDayMark
    @ObservedObject private var moodHistory = MoodHistoryStore.shared
    @ObservedObject private var examenHistory = ExamenHistoryStore.shared.list
    @ObservedObject private var rosaryHistory = RosaryHistoryStore.shared.list
    @ObservedObject private var routine = DailyRoutineStore.shared

    private var isToday: Bool { mark.dateKey == MockLiturgical.today.dateKey }
    private var feastInfo: (feastName: String, note: String?)? { MockLiturgical.dayFeastInfo(for: mark.dateKey) }

    /// Real engine output for this date, used only to check "is this a
    /// Sunday" and to build the Mass bulletin — the rest of this screen still
    /// uses `feastInfo`/`detail` above so September's hand-authored content
    /// (today/tomorrow) is untouched.
    private var computedDay: LiturgicalEngine.ComputedDay? {
        MockLiturgical.date(fromKey: mark.dateKey).map(LiturgicalEngine.day(for:))
    }

    private var record: DayRecord {
        DayRecord(dateKey: mark.dateKey, moods: moodHistory.entries, examens: examenHistory.items,
                  rosaries: rosaryHistory.items, routine: routine)
    }

    private var saintsOfTheDay: [Saint] { MockSaints.saints(on: String(mark.dateKey.suffix(5))) }

    private var detail: DayDetail {
        let latest = record.moods.last
        let relief = latest.map { MockMood.relief(for: $0.stateID).content }
        return DayDetail(
            dateLabel: DateKeyLabel.dayMonth(fromKey: mark.dateKey),
            // Fallback comes from the engine's own name catalog, not a literal:
            // a date with no entry is an ordinary weekday, named per language.
            feastName: feastInfo?.feastName ?? LiturgicalNameCatalog.current.weekdayOfOrdinaryTime,
            color: mark.color,
            loggedStateTitle: latest?.stateLabel,
            loggedNote: latest?.note,
            psalmRef: relief?.psalmRef,
            psalmText: relief?.psalmText,
            liturgyNote: feastInfo?.note
        )
    }

    var body: some View {
        ZStack {
            detail.color.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text(detail.color.name)
                            .font(MissaleFont.body(12, weight: .semibold))
                            .tracking(1.2)
                            .foregroundStyle(detail.color.accent)
                        Spacer()
                    }
                    Eyebrow(text: detail.dateLabel)
                    Text(detail.feastName)
                        .font(MissaleFont.display(29))

                    let record = record
                    if !record.isEmpty {
                        if !record.moods.isEmpty {
                            GlassCard {
                                VStack(alignment: .leading, spacing: 6) {
                                    Eyebrow(text: L.string("You logged", table: "CalendarSaints"))
                                    ForEach(record.moods) { entry in
                                        Text(entry.stateLabel).font(MissaleFont.body(19, weight: .medium))
                                        if let note = entry.note {
                                            quote(note)
                                        }
                                    }
                                }
                            }
                        }
                        routineCard(record)
                        ForEach(record.examens) { examenCard($0) }
                        ForEach(record.rosaries) { entry in
                            GlassCard {
                                VStack(alignment: .leading, spacing: 6) {
                                    Eyebrow(text: L.string("Rosary", table: "Prayers"))
                                    Text(entry.mysterySet.displayName).font(MissaleFont.body(19, weight: .medium))
                                    if let intention = entry.intention { quote(intention) }
                                }
                            }
                        }
                    } else {
                        DashedUtilityCard {
                            Text(isToday
                                 ? L.string("Nothing logged today yet.", table: "CalendarSaints")
                                 : L.string("Nothing logged that day.", table: "CalendarSaints"))
                                .font(MissaleFont.body(15))
                                .foregroundStyle(Palette.ink.opacity(0.7))
                        }
                    }

                    if let psalmText = detail.psalmText, let psalmRef = detail.psalmRef {
                        LiturgicalGradientCard(color: .red) {
                            VStack(alignment: .leading, spacing: 8) {
                                Eyebrow(text: L.string("That day's passage", table: "CalendarSaints"), color: Palette.goldBright)
                                Text(psalmText)
                                    .font(MissaleFont.display(21, italic: true))
                                    .foregroundStyle(.white)
                                Text(psalmRef)
                                    .font(MissaleFont.body(14))
                                    .foregroundStyle(.white.opacity(0.85))
                            }
                        }
                    }

                    if let liturgyNote = detail.liturgyNote {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 6) {
                                Eyebrow(text: L.string("That day in the liturgy", table: "CalendarSaints"))
                                Text(liturgyNote).font(MissaleFont.body(17))
                            }
                        }
                    }

                    if !saintsOfTheDay.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Eyebrow(text: L.string("Saints of the day", table: "CalendarSaints"))
                            ForEach(saintsOfTheDay) { saint in
                                NavigationLink {
                                    SaintDetailView(saint: saint)
                                } label: {
                                    GlassCard {
                                        HStack(spacing: 12) {
                                            SaintPortrait(artworkName: saint.artworkName)
                                                .frame(width: 44, height: 44)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(saint.name)
                                                    .font(MissaleFont.body(17, weight: .medium))
                                                    .foregroundStyle(Palette.ink)
                                                Text(saint.role)
                                                    .font(MissaleFont.body(14))
                                                    .foregroundStyle(Palette.ink.opacity(0.6))
                                                    .lineLimit(2)
                                            }
                                            Spacer(minLength: 0)
                                            Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    if let computedDay, computedDay.weekday == 1 {
                        NavigationLink {
                            MassBulletinView(day: computedDay)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(L.string("Sunday bulletin", table: "CalendarSaints"))
                                        .font(MissaleFont.body(17, weight: .medium))
                                        .foregroundStyle(Palette.ink)
                                    Text(L.string("The readings for this Mass", table: "CalendarSaints"))
                                        .font(MissaleFont.body(14))
                                        .foregroundStyle(Palette.ink.opacity(0.6))
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(Palette.wine)
                            }
                            .padding(14)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Color.white.opacity(0.6), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // Era "Setembro" fixo, mesmo abrindo um dia de dezembro.
                Text(DateKeyLabel.month(fromKey: mark.dateKey)).font(MissaleFont.body(15, weight: .medium))
            }
        }
    }
    private func quote(_ text: String) -> some View {
        Text("\u{201C}\(text)\u{201D}")
            .font(MissaleFont.body(15))
            .foregroundStyle(Palette.ink.opacity(0.72))
    }

    /// "Seu dia com Deus" as it went that day: what was done, and the line
    /// written at the morning offering. The check-in and the Examen have
    /// their own cards.
    @ViewBuilder
    private func routineCard(_ record: DayRecord) -> some View {
        if !record.routineDone.isEmpty || record.intention != nil {
            GlassCard {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(text: L.string("SEU DIA COM DEUS", table: "Today"))
                    ForEach(record.routineDone, id: \.self) { item in
                        Label(routineTitle(item), systemImage: "checkmark")
                            .font(MissaleFont.body(17))
                    }
                    if let intention = record.intention {
                        Text(L.string("O que você espera do seu dia?", table: "Today"))
                            .font(MissaleFont.body(14))
                            .foregroundStyle(Palette.ink.opacity(0.6))
                            .padding(.top, 4)
                        quote(intention)
                    }
                }
            }
        }
    }

    private func routineTitle(_ item: DailyRoutineStore.Item) -> String {
        switch item {
        case .morning: L.string("Oferecimento do dia", table: "Today")
        case .prayer: L.string("Oração", table: "Today")
        case .reading: L.string("Novo Testamento", table: "Today")
        }
    }

    /// The four answers, under the step titles the Examen itself uses.
    private func examenCard(_ entry: ExamenEntry) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                Eyebrow(text: L.string("Exame do dia", table: "Today"))
                let answers = [entry.gratitude, entry.lightRequest, entry.review, entry.response]
                ForEach(Array(zip(MockRosary.examenSteps, answers)), id: \.0.id) { step, answer in
                    if !answer.isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.title.uppercased())
                                .font(MissaleFont.body(11, weight: .semibold))
                                .tracking(1.0)
                                .foregroundStyle(Palette.ink.opacity(0.5))
                            Text(answer).font(MissaleFont.body(16))
                        }
                    }
                }
            }
        }
    }
}
