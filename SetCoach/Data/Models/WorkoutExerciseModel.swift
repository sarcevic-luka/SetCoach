import Foundation
import SwiftData

@Model
final class WorkoutExerciseModel {
    @Attribute(.unique) var id: String
    var exerciseTemplateId: String
    var name: String
    var sets: [ExerciseSetModel]
    var notes: String?
    var progressDirectionRaw: String?
    var difficultyRaw: String?

    var progressDirection: ProgressDirection? {
        get { progressDirectionRaw.flatMap(ProgressDirection.init(rawValue:)) }
        set { progressDirectionRaw = newValue?.rawValue }
    }

    var difficulty: Difficulty? {
        get { difficultyRaw.flatMap(Difficulty.init(rawValue:)) }
        set { difficultyRaw = newValue?.rawValue }
    }

    init(
        id: String = UUID().uuidString,
        exerciseTemplateId: String,
        name: String,
        sets: [ExerciseSetModel] = [],
        notes: String? = nil,
        progressDirection: ProgressDirection? = nil,
        difficulty: Difficulty? = nil
    ) {
        self.id = id
        self.exerciseTemplateId = exerciseTemplateId
        self.name = name
        self.sets = sets
        self.notes = notes
        self.progressDirectionRaw = progressDirection?.rawValue
        self.difficultyRaw = difficulty?.rawValue
    }

    convenience init(from entity: WorkoutExercise) {
        self.init(
            id: entity.id,
            exerciseTemplateId: entity.exerciseTemplateId,
            name: entity.name,
            sets: entity.sets.map { ExerciseSetModel(from: $0) },
            notes: entity.notes,
            progressDirection: entity.progressDirection,
            difficulty: entity.difficulty
        )
    }

    func toDomain() -> WorkoutExercise {
        WorkoutExercise(
            id: id,
            exerciseTemplateId: exerciseTemplateId,
            name: name,
            sets: sets.map { $0.toDomain() },
            notes: notes,
            progressDirection: progressDirection,
            difficulty: difficulty
        )
    }
}
