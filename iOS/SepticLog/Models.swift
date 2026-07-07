import Foundation

struct EntryEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var pumpOutDate: Date
    var company: String
    var cost: String
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), pumpOutDate: Date = Date(), company: String = "", cost: String = "", notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.pumpOutDate = pumpOutDate
        self.company = company
        self.cost = cost
        self.notes = notes
        self.createdAt = createdAt
    }
}
