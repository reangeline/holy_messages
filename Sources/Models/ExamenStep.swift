import Foundation

/// One step of the nightly Examen — gratitude, asking for light, review,
/// response. The steps come from the content catalog (MockRosary.examenSteps),
/// so their titles follow whichever language that catalog was authored in.
///
/// Used to live in PrayerItem.swift, alongside the model for the reminders
/// screen that was removed.
struct ExamenStep: Identifiable, Codable {
    var id: Int { number }
    let number: Int
    let title: String
    let subtitle: String
}
