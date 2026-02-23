import Foundation

/// Maps between TrainingDay domain entity and TrainingDayModel DTO
struct TrainingDayMapper {

    static func toModel(from entity: TrainingDay) -> TrainingDayModel {
        TrainingDayModel(
            id: entity.id,
            name: entity.name,
            exercises: entity.exercises.map { ExerciseTemplateMapper.toModel(from: $0) }
        )
    }

    static func toDomain(from model: TrainingDayModel) -> TrainingDay {
        TrainingDay(
            id: model.id,
            name: model.name,
            exercises: model.exercises.map { ExerciseTemplateMapper.toDomain(from: $0) }
        )
    }
}
