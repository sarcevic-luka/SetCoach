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

    convenience init(from entity: Program) {
        self.init(
            id: entity.id,
            name: entity.name,
            programDescription: entity.programDescription,
            trainingDays: entity.trainingDays.map { TrainingDayModel(from: $0) },
            createdAt: entity.createdAt
        )
    }

    func toDomain() -> Program {
        Program(
            id: id,
            name: name,
            programDescription: programDescription,
            trainingDays: trainingDays.map { $0.toDomain() },
            createdAt: createdAt
        )
    }
}
