import XCTest
@testable import Missale

/// Where the subscription gate is, and — the point of the file — where it must
/// never be.
///
/// The decision for this version: only the word of the day is free. But two
/// carve-outs are not commercial, and a UI test cannot cover the whole of the
/// first one (the keyboard on the note screen pushes the buttons out of the
/// accessibility tree). So this reads the sources instead, which is also a
/// stronger claim: the gate cannot appear in these files at all.
final class SubscriptionGateTests: XCTestCase {

    private var raiz: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    private func fonte(_ caminho: String) throws -> String {
        try String(contentsOf: raiz.appendingPathComponent(caminho), encoding: .utf8)
    }

    /// The support path: logging a state, the relief, the pastoral screen, and
    /// the crisis guidance. A paywall anywhere in here is
    /// the worst thing this app could do.
    ///
    /// `MoodCheckInSheet.swift` saiu desta lista quando o alívio (o Salmo, o
    /// santo e o passo) passou a pedir assinatura: é o arquivo que decide isso,
    /// e por isso cita `isSubscribed`. O que ele não pode fazer está coberto
    /// por `testTheMoodSheetGatesOnlyTheReliefStep` logo abaixo — a folha
    /// continua abrindo de graça, e o caminho da crise continua dentro dela.
    private let caminhoDoApoio = [
        "Sources/Features/Today/MoodReflectionView.swift",
        "Sources/Features/Today/MoodReliefView.swift",
        "Sources/Features/Today/PastoralCareNudgeView.swift",
        "Sources/Features/Settings/PastoralNoteDetailView.swift",
        "Sources/Models/CrisisLine.swift",
        // A orientação paga fica em OrientationWritingCard.swift; a tela de
        // crise que ela abre é caminho do apoio como as outras.
        "Sources/Features/Today/OrientationCrisisView.swift",
    ]

    /// Reachable without paying for reasons that are not commercial either:
    /// cancelling, reading what is stored, and the language.
    private let semprePorta = [
        "Sources/Features/Settings/SettingsView.swift",
        "Sources/Features/Settings/DataSettingsView.swift",
        "Sources/Features/Settings/LegalDocumentView.swift",
        "Sources/Features/Settings/LanguageSettingsView.swift",
        "Sources/Features/WordOfDay/WordOfDayView.swift",
    ]

    func testTheSupportPathHasNoGate() throws {
        for caminho in caminhoDoApoio {
            let fonte = try self.fonte(caminho)
            for portao in ["GatedLink", "GatedTab", "isSubscribed", "SubscriptionStore"] {
                XCTAssertFalse(
                    fonte.contains(portao),
                    "\(caminho) passou a depender da assinatura: é o caminho que termina na orientação de crise"
                )
            }
        }
    }

    func testTheFreeScreensHaveNoGate() throws {
        for caminho in semprePorta {
            let fonte = try self.fonte(caminho)
            for portao in ["GatedLink", "GatedTab"] {
                XCTAssertFalse(fonte.contains(portao), "\(caminho) ficou atrás da assinatura")
            }
        }
    }

    /// The mood sheet is the one file on the support path allowed to know about
    /// the subscription, and only for the relief step. It must still open for
    /// free, and it must still carry the way out.
    ///
    /// The count is the teeth of this test: one mention of `isSubscribed` is
    /// the relief branch. A second one would be someone gating the picker, the
    /// note, or the crisis link — the things that must never ask for money.
    func testTheMoodSheetGatesOnlyTheReliefStep() throws {
        let fonte = try self.fonte("Sources/Features/Today/MoodCheckInSheet.swift")

        XCTAssertEqual(
            fonte.components(separatedBy: "isSubscribed").count - 1, 1,
            "a folha do humor passou a consultar a assinatura em mais de um ponto: só o alívio pode pedir"
        )
        for portao in ["GatedLink", "GatedTab"] {
            XCTAssertFalse(fonte.contains(portao), "a folha do humor inteira ficou atrás da assinatura")
        }
        // A porta para o padre, a diocese e a crise, nos dois lugares em que a
        // pessoa pode estar: a primeira tela e o muro que substitui o alívio.
        XCTAssertEqual(
            fonte.components(separatedBy: "showPastoralCare = true").count - 1, 2,
            "o caminho do apoio sumiu de dentro da folha do humor"
        )
        XCTAssertTrue(
            fonte.contains("PastoralCareNudgeView()"),
            "a folha do humor deixou de abrir a tela pastoral"
        )
    }

    /// And the files that exist to show the crisis guidance must still show it.
    func testTheCrisisLineIsStillReachable() throws {
        for caminho in ["Sources/Features/Today/PastoralCareNudgeView.swift",
                        "Sources/Onboarding/OnboardingSpiritualIntroView.swift"] {
            XCTAssertTrue(
                try fonte(caminho).contains("CrisisLines.current"),
                "\(caminho) deixou de mostrar a orientação de crise"
            )
        }
        for idioma in AppLanguage.allCases {
            XCTAssertFalse(CrisisLines.catalog[idioma].message.isEmpty, "a orientação de crise ficou vazia em \(idioma)")
        }
    }

    /// The paid side, so a later change that quietly opens everything shows up
    /// here rather than in the revenue.
    func testThePaidScreensAreGated() throws {
        let raiz = try fonte("Sources/AppRootView.swift")
        for aba in ["CalendarRootView", "FormationRootView", "PrayersRootView"] {
            XCTAssertTrue(
                raiz.contains("GatedTab(content: { \(aba)()"),
                "a aba \(aba) deixou de pedir assinatura"
            )
        }
        let hoje = try fonte("Sources/Features/Today/TodayRootView.swift")
        XCTAssertGreaterThanOrEqual(
            hoje.components(separatedBy: "GatedLink").count - 1, 4,
            "os cartões pagos do Hoje (santo, formação, terço, exame) deixaram de pedir assinatura"
        )
    }
}
