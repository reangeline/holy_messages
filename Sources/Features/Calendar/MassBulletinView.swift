import SwiftUI

/// The Sunday Mass bulletin ("folheto litúrgico") — liturgical header plus the
/// day's reading references. Shows only citations (book, chapter, verse),
/// never the reading text itself: the translation is licensed (CNBB/USCCB),
/// the citation is not. See MockLectionary — most Sundays honestly show
/// "ainda não cadastrado" rather than a guessed reference.
struct MassBulletinView: View {
    let day: LiturgicalEngine.ComputedDay

    private var readings: MassReadings? { MockLectionary.readings(for: day) }

    private var gospelWriter: String {
        switch day.sundayCycle {
        case "A": "Mateus"
        case "B": "Marcos"
        case "C": "Lucas"
        default: ""
        }
    }

    var body: some View {
        ZStack {
            day.color.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Circle().fill(day.color.accent).frame(width: 9, height: 9)
                            Text("\(day.seasonLabel) · Ano \(day.sundayCycle)")
                                .font(MissaleFont.body(12, weight: .semibold))
                                .tracking(1.1)
                                .foregroundStyle(day.color.accent)
                        }
                        Text(day.feastName)
                            .font(MissaleFont.display(28))
                            .foregroundStyle(Palette.ink)
                    }

                    if !gospelWriter.isEmpty {
                        DashedUtilityCard {
                            Text("Ano \(day.sundayCycle): o Evangelho dominical deste ciclo é lido principalmente em \(gospelWriter).")
                                .font(MissaleFont.body(14))
                                .foregroundStyle(Palette.ink.opacity(0.72))
                        }
                    }

                    readingBlock(label: "Primeira Leitura", reference: readings?.firstReading)
                    readingBlock(label: "Salmo Responsorial", reference: readings?.psalm)
                    if let second = readings?.secondReading {
                        readingBlock(label: "Segunda Leitura", reference: second)
                    } else if readings == nil {
                        readingBlock(label: "Segunda Leitura", reference: nil)
                    }
                    readingBlock(label: "Evangelho", reference: readings?.gospel)

                    Text("Só a referência é mostrada — o texto das leituras é licenciado pela CNBB e não pode ser reproduzido aqui sem autorização.")
                        .font(MissaleFont.body(12))
                        .foregroundStyle(Palette.ink.opacity(0.5))
                }
                .padding(20)
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Folheto do domingo").font(MissaleFont.body(15, weight: .medium))
            }
        }
    }

    private func readingBlock(label: String, reference: String?) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Eyebrow(text: label)
                if let reference {
                    Text(reference)
                        .font(MissaleFont.display(20, weight: .medium))
                        .foregroundStyle(Palette.ink)
                } else {
                    Text("Ainda não cadastrado")
                        .font(MissaleFont.body(16))
                        .foregroundStyle(Palette.ink.opacity(0.4))
                        .italic()
                }
            }
        }
    }
}

#Preview {
    NavigationStack { MassBulletinView(day: LiturgicalEngine.day(for: Date())) }
}
