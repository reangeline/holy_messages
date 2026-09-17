import Foundation

/// One night's answers to the four Ignatian Examen steps.
struct ExamenEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let gratitude: String
    let lightRequest: String
    let review: String
    let response: String

    init(id: UUID = UUID(), date: Date = Date(), gratitude: String, lightRequest: String, review: String, response: String) {
        self.id = id
        self.date = date
        self.gratitude = gratitude
        self.lightRequest = lightRequest
        self.review = review
        self.response = response
    }
}
