import SwiftUI

/// Spec §4.3 — the whole liturgical year as one horizontal ribbon, proportional to
/// each season's real length, with "you are here." Teaches the year's shape in one
/// glance: Ordinary Time is most of it, Lent is 40 days, the Triduum barely shows.
struct LiturgicalYearRibbonView: View {
    private struct Segment {
        let entry: SeasonJourney.Entry
        let days: Double
        var season: LiturgicalSeason { entry.season }
    }

    // Ordered by the liturgical year, which begins with Advent, not January.
    // Widths are the real day counts of the year in force, from the engine.
    // Ordinary Time is drawn as one block even though it is split around
    // Lent and Easter; the marker counts only its days already lived.
    private let segments: [Segment] = SeasonJourney.currentYear().map { entry in
        let dias = entry.intervals.reduce(0.0) { soma, faixa in
            soma + faixa.upperBound.timeIntervalSince(faixa.lowerBound) / 86_400 + 1
        }
        return Segment(entry: entry, days: dias)
    }

    /// Where today falls inside the season in force, 0...1.
    private var markerFraction: Double? {
        guard let atual = segments.first(where: { $0.entry.status == .current }) else { return nil }
        let hoje = SeasonJourney.utcDay(.now)
        let vividos = atual.entry.intervals.reduce(0.0) { soma, faixa in
            guard hoje >= faixa.lowerBound else { return soma }
            let fim = min(hoje, faixa.upperBound)
            return soma + fim.timeIntervalSince(faixa.lowerBound) / 86_400 + 1
        }
        return min(vividos / atual.days, 1)
    }

    @State private var selectedSeasonID: String =
        SeasonJourney.currentYear().first { $0.status == .current }?.id ?? "ordinary"

    private var totalDays: Double { segments.reduce(0) { $0 + $1.days } }
    private var selectedSegment: Segment { segments.first { $0.season.id == selectedSeasonID } ?? segments[0] }

    var body: some View {
        ZStack {
            LiturgicalColor.green.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 4) {
                        Eyebrow(text: L.string("The liturgical year", table: "CalendarSaints"))
                        Text(L.string("A year, in one strip", table: "CalendarSaints"))
                            .font(MissaleFont.display(27))
                        Text(L.string("Each season's width is proportional to how long it really lasts — Ordinary Time is most of the year, Lent is 40 days, the Triduum barely shows.", table: "CalendarSaints"))
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.ink.opacity(0.68))
                    }

                    ribbon
                    detail
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(L.string("The year", table: "CalendarSaints")).font(MissaleFont.body(15, weight: .medium))
            }
        }
    }

    private var ribbon: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                HStack(spacing: 2) {
                    ForEach(segments, id: \.season.id) { segment in
                        Button {
                            selectedSeasonID = segment.season.id
                        } label: {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(segment.season.color == .white ? Color.white.opacity(0.9) : segment.season.color.accent.opacity(selectedSeasonID == segment.season.id ? 0.95 : 0.55))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .strokeBorder(selectedSeasonID == segment.season.id ? Palette.wine : .clear, lineWidth: 2)
                                )
                                .frame(width: max(proxy.size.width * segment.days / totalDays - 2, 4))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(height: 48)

                // "You are here" marker, positioned within its segment's slice of the ribbon.
                if let x = markerOffset(in: proxy.size.width) {
                    VStack(spacing: 2) {
                        Text(L.string("you are here", table: "CalendarSaints"))
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Palette.wine)
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Palette.wine)
                    }
                    .offset(x: x - 30, y: -34)
                }
            }
        }
        .frame(height: 82)
    }

    private func markerOffset(in width: CGFloat) -> CGFloat? {
        guard let markerFraction else { return nil }
        var runningDays: Double = 0
        for segment in segments {
            if segment.entry.status == .current {
                let position = runningDays + segment.days * markerFraction
                return width * position / totalDays
            }
            runningDays += segment.days
        }
        return nil
    }

    private var detail: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle().fill(selectedSegment.season.color.accent).frame(width: 10, height: 10)
                    Text(selectedSegment.season.name).font(MissaleFont.body(19, weight: .medium))
                    Spacer()
                    Text(selectedSegment.season.dateRange)
                        .font(MissaleFont.body(13))
                        .foregroundStyle(Palette.ink.opacity(0.55))
                }
                Text(selectedSegment.season.summaryLine)
                    .font(MissaleFont.body(15))
                    .foregroundStyle(Palette.ink.opacity(0.75))

                if selectedSegment.entry.status != .upcoming {
                    NavigationLink {
                        SeasonRetrospectiveView(retrospective: SeasonJourney.retrospective(for: selectedSegment.entry))
                    } label: {
                        Text(L.string("See this season ›", table: "CalendarSaints"))
                            .font(MissaleFont.body(15))
                            .foregroundStyle(Palette.wine)
                    }
                    .padding(.top, 2)
                }
            }
        }
    }
}

#Preview {
    NavigationStack { LiturgicalYearRibbonView() }
}
