import Foundation

/// Maps between Program domain entity and ProgramModel DTO
struct ProgramMapper {

    static func toModel(from entity: Program) -> ProgramModel {
        ProgramModel(
            id: entity.id,
            name: entity.name,
            programDescription: entity.programDescription,
            trainingDays: entity.trainingDays.map { TrainingDayMapper.toModel(from: $0) },
            createdAt: entity.createdAt
        )
    }

    static func toDomain(from model: ProgramModel) -> Program {
        Program(
            id: model.id,
            name: model.name,
            programDescription: model.programDescription,
            trainingDays: model.trainingDays.map { TrainingDayMapper.toDomain(from: $0) },
            createdAt: model.createdAt
        )
    }

    static func toDomain(from models: [ProgramModel]) -> [Program] {
        models.map { toDomain(from: $0) }
    }
}
