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
    /// the crisis line for the reader's country. A paywall anywhere in here is
    /// the worst thing this app could do.
    private let caminhoDoApoio = [
        "Sources/Features/Today/MoodCheckInSheet.swift",
        "Sources/Features/Today/MoodReflectionView.swift",
        "Sources/Features/Today/MoodReliefView.swift",
        "Sources/Features/Today/PastoralCareNudgeView.swift",
        "Sources/Features/Settings/PastoralNoteDetailView.swift",
        "Sources/Models/CrisisLine.swift",
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
                    "\(caminho) passou a depender da assinatura: é o caminho que termina numa linha de crise"
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

    /// And the files that exist to show the crisis line must still show it.
    func testTheCrisisLineIsStillReachable() throws {
        for caminho in ["Sources/Features/Today/PastoralCareNudgeView.swift",
                        "Sources/Onboarding/OnboardingSpiritualIntroView.swift"] {
            XCTAssertTrue(
                try fonte(caminho).contains("CrisisLines.current"),
                "\(caminho) deixou de mostrar a linha de crise do país do leitor"
            )
        }
        XCTAssertFalse(CrisisLines.current.number.isEmpty, "a linha de crise ficou sem número")
        XCTAssertFalse(CrisisLines.current.telURL.isEmpty, "a linha de crise ficou sem discagem")
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
