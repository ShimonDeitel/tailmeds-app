import Foundation

struct FlareEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var symptom: String
    var trigger: String
    var createdAt: Date = Date()
}
