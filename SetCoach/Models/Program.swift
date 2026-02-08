import Foundation
import SwiftData

@Model
final class Program {
    @Attribute(.unique) var id: String
    var name: String
    var programDescription: String?
    var trainingDays: [TrainingDay]
    var createdAt: Date

    init(id: String = UUID().uuidString, name: String,
         programDescription: String? = nil,
         trainingDays: [TrainingDay] = [],
         createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.programDescription = programDescription
        self.trainingDays = trainingDays
        self.createdAt = createdAt
    }
}
