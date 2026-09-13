import Foundation

enum OnboardingStep: Equatable {
    case feed
    case sample
    case life(Int)
    case spiritualIntro
    case spiritual(Int)
    case relief
    case loader
    case synthesis
    case notificationTime
    case notificationPreview
    case paywall
}

/// Gap note: MockMood.reliefByState and MockSubscription.plans are authored in
/// Portuguese for the (Portuguese) main app, but the design keeps onboarding in
/// English. Rather than mix languages, this flow has its own small English-only
/// content below. Worth reconciling with a localized content system later.
enum OnboardingRelief {
    static let content: [String: ReliefContent] = [
        "tired": ReliefContent(
            title: "Tiredness is not a lack of faith",
            psalmRef: "Psalm 62",
            psalmText: "My soul thirsteth after thee, my flesh, O how many ways! In a desert land, and where there is no way, and no water.",
            psalmWhy: "The psalmist names the thirst before naming any relief — the wanting is already a kind of prayer.",
            saintName: "St. John of the Cross",
            saintWhy: "He called this stretch the \"dark night\" and taught that it purifies faith rather than ending it.",
            stepTitle: "One concrete step",
            stepBody: "Say tonight's Rosary through to the end, even feeling nothing. Faithfulness matters more than feeling here."
        ),
        "fear": ReliefContent(
            title: "Fear can be handed over, not just felt",
            psalmRef: "Psalm 55",
            psalmText: "Cast thy care upon the Lord, and he shall sustain thee: he shall not suffer the just to waver for ever.",
            psalmWhy: "\"Cast\" is a verb of action — handing the weight over, not just describing it.",
            saintName: "St. Padre Pio",
            saintWhy: "His advice was \"pray, hope, and don't worry\" — not because it's easy, but because worry alone helps nothing.",
            stepTitle: "One concrete step",
            stepBody: "Take three slow breaths and pray one Our Father slowly, attending to each phrase."
        ),
        "lonely": ReliefContent(
            title: "Loneliness is not the same as being unseen",
            psalmRef: "Psalm 27",
            psalmText: "For my father and my mother have left me: but the Lord hath taken me up.",
            psalmWhy: "The psalmist names abandonment plainly, then names who remains.",
            saintName: "St. Thérèse of Lisieux",
            saintWhy: "She lived her final months in profound spiritual darkness, largely unseen by those around her.",
            stepTitle: "One concrete step",
            stepBody: "Name one person you could reach out to this week — even just to say hello."
        ),
        "meaningless": ReliefContent(
            title: "This dryness has a long tradition behind it",
            psalmRef: "Ecclesiastes 1:2",
            psalmText: "Vanity of vanities, said Ecclesiastes: vanity of vanities, and all is vanity.",
            psalmWhy: "Scripture itself contains a whole book that starts from exactly this feeling.",
            saintName: "St. Teresa of Calcutta",
            saintWhy: "She wrote for decades about an interior darkness that never fully lifted, while continuing to serve daily.",
            stepTitle: "One concrete step",
            stepBody: "Do one small, concrete act of service today — the meaning can follow the action instead of preceding it."
        ),
    ]

    static let fallback = ReliefContent(
        title: "This too is something to bring to prayer",
        psalmRef: "Psalm 34",
        psalmText: "I will bless the Lord at all times: his praise shall be always in my mouth.",
        psalmWhy: "Praise here doesn't require a good day — only a willingness to look toward God again.",
        saintName: "St. Thérèse of Lisieux",
        saintWhy: "She kept to small, ordinary gestures of faith even through months of feeling nothing.",
        stepTitle: "One concrete step",
        stepBody: "Before bed, name one thing from today worth being grateful for — even something small."
    )

    static func content(spirit2: String?) -> ReliefContent {
        guard let spirit2, let match = content[spirit2] else { return fallback }
        return match
    }
}

enum OnboardingPaywallContent {
    static let plans: [SubscriptionPlan] = [
        .init(id: "monthly", title: "Monthly", rate: "$6.99/mo", subtitle: "Billed monthly", total: "$6.99", badge: nil),
        .init(id: "annual", title: "Annual", rate: "$3.33/mo", subtitle: "Billed once a year", total: "$39.99/yr", badge: "Most popular"),
        .init(id: "lifetime", title: "Lifetime", rate: "One-time", subtitle: "Yours for good", total: "$129.99", badge: nil),
    ]
    static let planPrice = "$39.99/yr"
}
