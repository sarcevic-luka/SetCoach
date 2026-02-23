import Foundation

/// Maps between ExerciseSet domain entity and ExerciseSetModel DTO
struct ExerciseSetMapper {

    static func toModel(from entity: ExerciseSet) -> ExerciseSetModel {
        ExerciseSetModel(
            setNumber: entity.setNumber,
            weight: entity.weight,
            reps: entity.reps,
            completed: entity.completed
        )
    }

    static func toDomain(from model: ExerciseSetModel) -> ExerciseSet {
        ExerciseSet(
            id: UUID(),
            setNumber: model.setNumber,
            weight: model.weight,
            reps: model.reps,
            completed: model.completed
        )
    }
}
