import AVFoundation

/// Reads each step of the Rosary aloud and says when it is done, so the
/// guided screen can move to the next bead on its own.
///
/// The toggle on the picker used to be called "human voice" and did nothing:
/// there are no recordings in the app. This is the system's own speech
/// synthesis, in the app's language, entirely on the device — no audio is
/// downloaded and nothing leaves the phone.
@MainActor
final class RosaryVoiceGuide: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var onFinish: (() -> Void)?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// Speaks `text`, then calls `onFinish` — unless it was interrupted by
    /// `stop()` or by another `speak`, in which case the tap already advanced.
    func speak(_ text: String, onFinish: @escaping () -> Void) {
        stop()
        // Toca com o aparelho no silencioso: é o modo de rezar com o celular
        // no bolso, e o botão lateral não deveria calar a oração.
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: Self.voiceLanguage)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.92
        utterance.postUtteranceDelay = 0.6
        self.onFinish = onFinish
        synthesizer.speak(utterance)
    }

    func stop() {
        onFinish = nil
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }
    }

    func finish() {
        stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    private static var voiceLanguage: String {
        switch AppLanguagePreference.resolveCurrent() {
        case .pt: "pt-BR"
        case .es: "es-MX"
        case .en: "en-US"
        }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            let next = self.onFinish
            self.onFinish = nil
            next?()
        }
    }
}

extension RosaryPrayerStep {
    /// What the voice reads: the mystery and its fruit on an announcement, the
    /// prayer itself otherwise, and the list items on the intentions step.
    var spokenText: String {
        if let items = promptItems {
            return ([kicker] + items.map { "\($0.label). \($0.detail)" }).joined(separator: ". ")
        }
        var partes: [String] = []
        if let mysteryTitleLine { partes.append(mysteryTitleLine) }
        partes.append(text)
        if let fruit {
            partes.append(L.string("Fruit: {fruit}", table: "Prayers").replacingOccurrences(of: "{fruit}", with: fruit))
        }
        return partes.joined(separator: ". ")
    }
}
