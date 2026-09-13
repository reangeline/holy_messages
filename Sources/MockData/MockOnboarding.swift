import Foundation

enum MockOnboarding {
    static let sampleTabs: [SampleTab] = [
        .init(id: "verse", label: "Versículo", kicker: "Today's verse", title: "Exaltation of the Holy Cross",
              body: "Monday, September 14. Red vestments today — the color of blood and of the Cross. This screen carries the color of the day, and it changes when the calendar does.",
              quote: "And as Moses lifted up the serpent in the desert, so must the Son of Man be lifted up."),
        .init(id: "saint", label: "Saint", kicker: "Saint of the day", title: "St. Notburga of Eben",
              body: "A Tyrolean servant, dismissed from her post for giving the poor food that would otherwise be thrown away. She kept giving from what little she had.",
              quote: "Remembered for what she did with the leftovers, and for not stopping when it cost her the job."),
        .init(id: "mass", label: "Mass", kicker: "The Mass, part by part · 1 of 14", title: "The Introductory Rites",
              body: "Before anything is read or offered, the Church gathers and admits what it is.",
              quote: "Why the sign of the cross comes first, and what the greeting actually claims."),
    ]

    static let lifeQuestions: [LifeQuestion] = [
        .init(id: "life-1", title: "Where are you in your walk of faith?",
              subtitle: "There's no wrong answer here.",
              options: [
                .init(id: "practicing", text: "Practicing, most weeks"),
                .init(id: "returning", text: "Coming back after time away"),
                .init(id: "exploring", text: "Exploring Catholicism"),
                .init(id: "struggling", text: "Practicing, but going through a hard time"),
              ], multiSelect: false, skippable: false),
        .init(id: "life-2", title: "How often do you get to Mass?",
              subtitle: "Again, no wrong answer.",
              options: [
                .init(id: "weekly", text: "Every Sunday"),
                .init(id: "monthly", text: "A few times a month"),
                .init(id: "occasions", text: "Mostly on special occasions"),
                .init(id: "trying", text: "I'm trying to get back into it"),
              ], multiSelect: false, skippable: false),
        .init(id: "life-3", title: "What's missing most right now?",
              subtitle: "Pick as many as fit.",
              options: [
                .init(id: "consistency", text: "Consistency"),
                .init(id: "understanding", text: "Understanding what's happening at Mass"),
                .init(id: "community", text: "A sense of community"),
                .init(id: "peace", text: "Peace of mind"),
              ], multiSelect: true, skippable: false),
        .init(id: "life-4", title: "Your state in life",
              subtitle: "So we don't assume.",
              options: [
                .init(id: "single", text: "Single"),
                .init(id: "married", text: "Married"),
                .init(id: "religious", text: "Consecrated / religious life"),
                .init(id: "prefer-not", text: "I'd rather not say"),
              ], multiSelect: false, skippable: true),
    ]

    static let spiritualQuestions: [SpiritualQuestion] = [
        .init(id: "spirit-1", title: "How has prayer been going lately?",
              subtitle: "Not a test. Just naming it.",
              options: [
                .init(id: "alive", text: "Alive, I feel it"),
                .init(id: "dry", text: "Dry, but I keep showing up"),
                .init(id: "absent", text: "Almost nonexistent"),
                .init(id: "doubtful", text: "Full of doubts"),
              ]),
        .init(id: "spirit-2", title: "What's weighing on you most right now?",
              subtitle: "",
              options: [
                .init(id: "tired", text: "Tiredness"),
                .init(id: "fear", text: "Fear about the future"),
                .init(id: "lonely", text: "Loneliness"),
                .init(id: "meaningless", text: "A sense that nothing means much"),
              ]),
        .init(id: "spirit-3", title: "Does any of this describe what you're carrying?",
              subtitle: "These deserve more than an app — we'll say so if you pick one.",
              options: [
                .init(id: "grief", text: "Grief or loss", isCrisisTrigger: true),
                .init(id: "anger", text: "Anger or resentment", isCrisisTrigger: true),
                .init(id: "guilt", text: "Guilt", isCrisisTrigger: true),
                .init(id: "none", text: "None of these"),
              ]),
        .init(id: "spirit-4", title: "How is your relationship with God today?",
              subtitle: "",
              options: [
                .init(id: "close", text: "Close"),
                .init(id: "distant-present", text: "Distant, but still there"),
                .init(id: "confused", text: "Confused"),
                .init(id: "unsure", text: "I'm not sure God is there"),
              ]),
    ]

    static let notificationTimes: [(id: String, title: String, subtitle: String, hour: String)] = [
        ("morning", "Morning", "Right when the day starts", "7:00 AM"),
        ("midday", "Midday", "A pause, not a start", "12:00 PM"),
        ("evening", "Evening", "Before the day winds down", "8:30 PM"),
    ]

    static let planSteps: [(number: Int, title: String, subtitle: String)] = [
        (1, "The Mass, part by part", "One short part a day — you're starting at the Penitential Act."),
        (2, "The daily verse and saint", "Free, every day, forever."),
        (3, "The Rosary, guided", "Today's mystery, with a beginner mode and a teaching layer."),
    ]
}
