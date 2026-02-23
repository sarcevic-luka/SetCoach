import Foundation

/// Maps between WorkoutExercise domain entity and WorkoutExerciseModel DTO
struct WorkoutExerciseMapper {

    static func toModel(from entity: WorkoutExercise) -> WorkoutExerciseModel {
        WorkoutExerciseModel(
            id: entity.id,
            exerciseTemplateId: entity.exerciseTemplateId,
            name: entity.name,
            sets: entity.sets.map { ExerciseSetMapper.toModel(from: $0) },
            notes: entity.notes,
            progressDirection: entity.progressDirection,
            difficulty: entity.difficulty
        )
    }

    static func toDomain(from model: WorkoutExerciseModel) -> WorkoutExercise {
        WorkoutExercise(
            id: model.id,
            exerciseTemplateId: model.exerciseTemplateId,
            name: model.name,
            sets: model.sets.map { ExerciseSetMapper.toDomain(from: $0) },
            notes: model.notes,
            progressDirection: model.progressDirection,
            difficulty: model.difficulty
        )
    }
}
