import SwiftUI

/// t4 screen 18 — Formation tracks list. Hub screen (shows the floating tab bar).
struct FormationRootView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LiturgicalColor.red.pageBackground
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        header

                        NavigationLink {
                            FormationLessonView(lesson: MockFormation.atoPenitencial)
                        } label: {
                            trackCard(MockFormation.track, isStarted: true)
                        }
                        .buttonStyle(.plain)

                        ForEach(MockFormation.otherTracks) { track in
                            trackCard(track, isStarted: false)
                        }

                        NavigationLink {
                            GlossaryView()
                        } label: {
                            DashedUtilityCard {
                                HStack {
                                    Text("Glossary and \u{201C}why is today red?\u{201D}", tableName: "FormationWordOfDay")
                                        .font(MissaleFont.body(15))
                                        .foregroundStyle(Palette.ink.opacity(0.75))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Palette.ink.opacity(0.4))
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 110) // room for the floating glass tab bar
                }
            }
            .hubTabBarOverlay()
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Eyebrow(text: L.string( "Formation", table: "FormationWordOfDay"))
            Text("Tracks", tableName: "FormationWordOfDay")
                .font(MissaleFont.display(28))
            // "reviewerCredit" (e.g. "Revisão de conteúdo por Pe. Daniel Vasconcelos.")
            // is owned by MockFormation.swift, out of this pass's scope, and stays
            // Portuguese — so this whole sentence stays Portuguese too rather than
            // mixing an English lead-in with a Portuguese name/credit.
            Text("Uma parte por dia, cerca de quatro minutos. \(MockFormation.reviewerCredit)")
                .font(MissaleFont.body(14))
                .foregroundStyle(Palette.ink.opacity(0.65))
        }
    }

    private func trackCard(_ track: FormationTrack, isStarted: Bool) -> some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(track.title)
                    .font(MissaleFont.body(17, weight: .medium))
                    .foregroundStyle(Palette.ink)
                Text(track.meta)
                    .font(MissaleFont.body(14))
                    .foregroundStyle(Palette.ink.opacity(0.65))
                if isStarted {
                    ProgressView(value: track.progress)
                        .tint(Palette.wine)
                        .padding(.top, 2)
                }
                Text(track.nextUp)
                    .font(MissaleFont.body(13))
                    .foregroundStyle(Palette.ink.opacity(0.5))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(isStarted ? 1 : 0.75)
    }
}

#Preview {
    FormationRootView()
}
