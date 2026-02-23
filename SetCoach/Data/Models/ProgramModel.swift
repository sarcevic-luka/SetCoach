import Foundation
import SwiftData

@Model
final class ProgramModel {
    @Attribute(.unique) var id: String
    var name: String
    var programDescription: String?
    @Relationship(deleteRule: .cascade) var trainingDays: [TrainingDayModel]
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        name: String,
        programDescription: String? = nil,
        trainingDays: [TrainingDayModel] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.programDescription = programDescription
        self.trainingDays = trainingDays
        self.createdAt = createdAt
    }
}
