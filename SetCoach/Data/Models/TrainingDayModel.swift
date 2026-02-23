import Foundation
import SwiftData

@Model
final class TrainingDayModel {
    @Attribute(.unique) var id: String
    var name: String
    @Relationship(deleteRule: .cascade) var exercises: [ExerciseTemplateModel]

    init(id: String = UUID().uuidString, name: String, exercises: [ExerciseTemplateModel] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }

    convenience init(from entity: TrainingDay) {
        self.init(
            id: entity.id,
            name: entity.name,
            exercises: entity.exercises.map { ExerciseTemplateModel(from: $0) }
        )
    }

    func toDomain() -> TrainingDay {
        TrainingDay(
            id: id,
            name: name,
            exercises: exercises.map { $0.toDomain() }
        )
    }
}
