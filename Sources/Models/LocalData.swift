import Foundation

/// Everything the app keeps on the device, in one place.
///
/// This exists so the privacy policy can describe the app from a list that is
/// checked by a test rather than from memory — `LocalDataTests` fails when a
/// key is persisted without being listed here.
///
/// There is no wipe function: the screen that offered one cleared the mood log
/// only, while telling the reader their Examen notes were gone, and both it and
/// the export beside it are deferred. Until they exist, deleting the app is
/// what removes the data, which is what the policy says. When the button comes
/// back, the wipe belongs here, over this same list.
///
/// Nothing here is ever uploaded. The app makes no network requests at all —
/// see `LocalDataTests`, which fails if a key is added without being listed.
enum LocalData {

    /// Text and records the reader creates — what the policy calls "what you
    /// write", and what a future wipe has to remove.
    static let personalKeys = [
        "mood_history_entries",          // registro de humor: estado, data e a nota opcional
        "mood_last_relief_index",        // qual alívio foi mostrado por último, por estado
        "examen_entries",                // as quatro respostas escritas no Exame
        "rosary_history_entries",        // terços rezados
        "formation_completed_lesson_ids",
        "formation_completed_lesson_order",
        "userDisplayName",               // o nome digitado nas Configurações
        "routine_completions",           // o que do "Seu dia com Deus" foi feito em cada dia (últimos 60)
        "routine_nt_position",           // quantos capítulos do Novo Testamento já foram lidos
        "review_routine_days",           // dias com o "Seu dia com Deus" completo, para o pedido de avaliação
    ]

    /// Choices about how the app behaves, as opposed to what the reader wrote.
    /// The distinction matters for a future wipe: clearing the language and the
    /// calendar would restart the app in a language nobody chose.
    static let preferenceKeys = [
        "appLanguageOverride",           // no grupo do app, partilhado com o widget
        "liturgicalCalendarRegionID",
        "rosaryBeginnerMode",
        "rosaryVoiceGuide",              // a voz lendo o Terço, ligada ou não
        "examenMinutesOfDay",            // a hora escolhida para o Exame da noite
        "hasCompletedOnboarding",
        "review_prompt_asked",           // se o pedido de avaliação já foi feito
    ]
}
