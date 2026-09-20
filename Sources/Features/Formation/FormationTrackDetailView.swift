import SwiftUI

/// Detail screen for a Formation track: a "Continuar" card that resumes where
/// you left off, plus the full list of parts so you can review one you already
/// did or jump ahead to one you're curious about, instead of only ever being
/// able to open whatever part comes next.
struct FormationTrackDetailView: View {
    let track: FormationTrack
    let onBackToTracks: () -> Void
    @ObservedObject private var progressStore = FormationProgressStore.shared

    var body: some View {
        ZStack {
            LiturgicalColor.red.pageBackground
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    if let resumeLesson = track.resumeLesson(progressStore) {
                        continueCard(resumeLesson)
                    }
                    lessonList
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(track.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(track.meta)
                .font(MissaleFont.body(14))
                .foregroundStyle(Palette.ink.opacity(0.65))
            ProgressView(value: track.liveProgress(progressStore))
                .tint(Palette.wine)
            Text(L.string("{done} of {total} parts completed", table: "FormationWordOfDay")
                .replacingOccurrences(of: "{done}", with: "\(track.completedCount(in: progressStore))")
                .replacingOccurrences(of: "{total}", with: "\(track.lessons.count)"))
                .font(MissaleFont.body(13))
                .foregroundStyle(Palette.ink.opacity(0.5))
        }
    }

    private func continueCard(_ lesson: FormationLesson) -> some View {
        NavigationLink {
            FormationLessonView(lesson: lesson, onBackToTracks: onBackToTracks)
        } label: {
            GlassCard {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Eyebrow(text: L.string("Continue", table: "FormationWordOfDay"))
                        Text(L.string("Part {n}: {title}", table: "FormationWordOfDay")
                            .replacingOccurrences(of: "{n}", with: "\(lesson.partNumber)")
                            .replacingOccurrences(of: "{title}", with: lesson.title))
                            .font(MissaleFont.body(17, weight: .medium))
                            .foregroundStyle(Palette.ink)
                    }
                    Spacer()
                    Image(systemName: "play.fill")
                        .foregroundStyle(Palette.wine)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var lessonList: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(L.string("ALL PARTS", table: "FormationWordOfDay"))
                .font(MissaleFont.body(11, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Palette.ink.opacity(0.5))
                .padding(.bottom, 6)

            ForEach(track.lessons) { lesson in
                NavigationLink {
                    FormationLessonView(lesson: lesson, onBackToTracks: onBackToTracks)
                } label: {
                    lessonRow(lesson)
                }
                .buttonStyle(.plain)

                if lesson.id != track.lessons.last?.id {
                    Divider().opacity(0.3)
                }
            }
        }
    }

    private func lessonRow(_ lesson: FormationLesson) -> some View {
        let completed = progressStore.isCompleted(lesson.id)
        return HStack(spacing: 12) {
            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(completed ? Palette.wine : Palette.ink.opacity(0.25))
            VStack(alignment: .leading, spacing: 2) {
                Text(L.string("Part {n}", table: "FormationWordOfDay")
                    .replacingOccurrences(of: "{n}", with: "\(lesson.partNumber)"))
                    .font(MissaleFont.body(12, weight: .semibold))
                    .foregroundStyle(Palette.ink.opacity(0.5))
                Text(lesson.title)
                    .font(MissaleFont.body(16, weight: .medium))
                    .foregroundStyle(Palette.ink)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Palette.ink.opacity(0.3))
        }
        .padding(.vertical, 10)
        // A linha inteira aceita o toque — sem isto, só os glifos respondem.
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack { FormationTrackDetailView(track: MockFormation.track, onBackToTracks: {}) }
}
