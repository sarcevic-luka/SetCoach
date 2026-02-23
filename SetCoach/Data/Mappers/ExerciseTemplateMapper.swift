import Foundation

/// Maps between ExerciseTemplate domain entity and ExerciseTemplateModel DTO
struct ExerciseTemplateMapper {

    static func toModel(from entity: ExerciseTemplate) -> ExerciseTemplateModel {
        ExerciseTemplateModel(
            id: entity.id,
            name: entity.name,
            targetSets: entity.targetSets,
            targetRepsMin: entity.targetRepsMin,
            targetRepsMax: entity.targetRepsMax,
            notes: entity.notes
        )
    }

    static func toDomain(from model: ExerciseTemplateModel) -> ExerciseTemplate {
        ExerciseTemplate(
            id: model.id,
            name: model.name,
            targetSets: model.targetSets,
            targetRepsMin: model.targetRepsMin,
            targetRepsMax: model.targetRepsMax,
            notes: model.notes
        )
    }
}
