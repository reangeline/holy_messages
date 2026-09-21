import Foundation

/// Everything the app keeps on the device, in one place.
///
/// This exists so "Delete everything" can actually mean it, and so the privacy
/// policy can describe the app from a list that is checked by a test rather
/// than from memory. Before this, the delete button cleared the mood log only:
/// a reader who wrote something in the Examen and then tapped "Apagar tudo"
/// kept that text on the device, while the screen said notes were deleted.
///
/// Nothing here is ever uploaded. The app makes no network requests at all —
/// see `LocalDataTests`, which fails if a key is added without being listed.
enum LocalData {

    /// Text and records the reader creates. This is what "Delete everything"
    /// must remove, and what the policy calls "what you write".
    static let personalKeys = [
        "mood_history_entries",          // registro de humor: estado, data e a nota opcional
        "mood_last_relief_index",        // qual alívio foi mostrado por último, por estado
        "examen_entries",                // as quatro respostas escritas no Exame
        "rosary_history_entries",        // terços rezados
        "formation_completed_lesson_ids",
        "formation_completed_lesson_order",
        "userDisplayName",               // o nome digitado nas Configurações
    ]

    /// Choices about how the app behaves. Kept on delete: wiping the reader's
    /// language and calendar would restart the app in a language they did not
    /// choose, which is not what the button offers to do.
    static let preferenceKeys = [
        "appLanguageOverride",           // no grupo do app, partilhado com o widget
        "liturgicalCalendarRegionID",
        "rosaryBeginnerMode",
        "hasCompletedOnboarding",
    ]

    /// How many records the reader has created, for the delete confirmation.
    /// Counts entries, not keys: a reader deciding whether to wipe wants to
    /// know how much of their own writing is at stake.
    @MainActor
    static var recordCount: Int {
        MoodHistoryStore.shared.entries.count
            + ExamenHistoryStore.shared.list.items.count
            + RosaryHistoryStore.shared.list.items.count
            + FormationProgressStore.shared.completedLessonIDs.count
    }

    /// Irreversible, local, immediate.
    ///
    /// Clears the live stores first — each keeps an in-memory copy, so wiping
    /// only the stored keys would leave the deleted entries on screen and save
    /// them back on the next write — then removes any remaining key directly.
    @MainActor
    static func deleteEverything() {
        MoodHistoryStore.shared.deleteAll()
        ExamenHistoryStore.shared.deleteAll()
        RosaryHistoryStore.shared.deleteAll()
        FormationProgressStore.shared.deleteAll()

        let stores = [UserDefaults.standard, AppLanguagePreference.store]
        for key in personalKeys {
            for store in stores {
                store.removeObject(forKey: key)
            }
        }
    }
}
