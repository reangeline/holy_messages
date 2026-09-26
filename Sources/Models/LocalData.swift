import Foundation

/// Everything the app keeps on the device, in one place.
///
/// This exists so the privacy policy can describe the app from a list that is
/// checked by a test rather than from memory — `LocalDataTests` fails when a
/// key is persisted without being listed here.
///
/// Export and erase work over this same list (Settings › Your data), so what
/// the policy describes, what the file carries and what the button removes can
/// never drift apart.
///
/// Nothing here is ever uploaded. The only network code is `MissaleAPI`
/// (sign-in and the account), which sends none of these keys — see
/// `LocalDataTests`, which also fails if a key is added without being listed.
///
/// Outside UserDefaults, the Keychain holds the account session
/// (`SessionKeychain`: tokens and Apple's user identifier), on this device only.
enum LocalData {

    /// Text and records the reader creates — what the policy calls "what you
    /// write", and what a future wipe has to remove.
    static let personalKeys = [
        "mood_history_entries",          // registro de humor: estado, data e a nota opcional
        "mood_last_relief_index",        // qual alívio foi mostrado por último, por estado
        "examen_entries",                // as quatro respostas escritas no Exame, e o santo e a oração que o Jev escolheu delas
        "rosary_history_entries",        // terços rezados
        "formation_completed_lesson_ids",
        "formation_completed_lesson_order",
        "userDisplayName",               // o nome digitado nas Configurações
        "routine_completions",           // o que do "Seu dia com Deus" foi feito em cada dia (últimos 60)
        "routine_nt_position",           // quantos capítulos do Novo Testamento já foram lidos
        "routine_intentions",            // o que a pessoa escreveu que espera do dia, no oferecimento (últimos 60)
        "routine_intention_verses",      // o versículo escolhido pelo Jev para a intenção de cada dia (id do acervo, últimos 60)
        "bible_highlights",              // versículos marcados na Bíblia
        "bible_bookmarks",               // o capítulo marcado como "onde parei", por Bíblia
        "review_routine_days",           // dias com o "Seu dia com Deus" completo, para o pedido de avaliação
        "word_of_day_shown",             // no grupo do app: a palavra de cada dia (últimos 30) e se foi escolhida pelo Jev a partir do que a pessoa escreveu
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
        "reading_reminder_minutes",      // os horários escolhidos para o aviso da leitura do dia
        "review_prompt_asked",           // se o pedido de avaliação já foi feito
        "reading_text_size",             // o tamanho escolhido para o texto da Bíblia, dos santos e da formação
        "jev_personalization_enabled",   // "Personalizar com o que escrevo": se o texto pode ir ao Jev (ligado por padrão)
    ]

    // MARK: - Export and erase

    /// Everything in `personalKeys`, as readable JSON: values stored as JSON
    /// are unpacked, and the dates inside them — kept as seconds since 2001 —
    /// become ISO 8601 text.
    static func exportJSON(from defaults: UserDefaults = .standard, now: Date = Date()) -> Data {
        var records: [String: Any] = [:]
        for key in personalKeys {
            // `word_of_day_shown` lives in the app group (WordOfDayLog), not in
            // `defaults`, so the widget can read it too — the export has to
            // look there instead, or the key comes back empty.
            let source = key == WordOfDayLog.storageKey ? WordOfDayLog.defaults : defaults
            guard let value = source.object(forKey: key) else { continue }
            if let data = value as? Data, let json = try? JSONSerialization.jsonObject(with: data) {
                records[key] = readableDates(json)
            } else if JSONSerialization.isValidJSONObject([value]) {
                records[key] = value
            }
        }
        let file: [String: Any] = [
            "app": "Missale",
            "exportedAt": ISO8601DateFormatter().string(from: now),
            "records": records,
        ]
        return (try? JSONSerialization.data(withJSONObject: file, options: [.prettyPrinted, .sortedKeys])) ?? Data()
    }

    /// Removes what the reader wrote and recorded, keeps the preferences (the
    /// language above all), and has every store read the empty state at once.
    @MainActor
    static func erasePersonalData(from defaults: UserDefaults = .standard) {
        personalKeys.forEach(defaults.removeObject(forKey:))
        MoodHistoryStore.shared.reload()
        ExamenHistoryStore.shared.list.reload()
        RosaryHistoryStore.shared.list.reload()
        FormationProgressStore.shared.reload()
        DailyRoutineStore.shared.reload()
        BibleNotesStore.shared.reload()
        // Kept in the app group, for the widget, so outside `defaults`.
        WordOfDayLog.defaults.removeObject(forKey: WordOfDayLog.storageKey)
        PersonalizedWordOfDay.shared.sync()
    }

    private static func readableDates(_ value: Any) -> Any {
        switch value {
        case let dictionary as [String: Any]:
            return Dictionary(uniqueKeysWithValues: dictionary.map { key, inner -> (String, Any) in
                if key == "date", let seconds = inner as? Double {
                    return (key, ISO8601DateFormatter().string(from: Date(timeIntervalSinceReferenceDate: seconds)))
                }
                return (key, readableDates(inner))
            })
        case let array as [Any]:
            return array.map(readableDates)
        default:
            return value
        }
    }
}
