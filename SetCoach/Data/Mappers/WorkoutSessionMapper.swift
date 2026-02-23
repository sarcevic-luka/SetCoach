import Foundation

/// Maps between WorkoutSession domain entity and WorkoutSessionModel DTO
struct WorkoutSessionMapper {

    static func toModel(from entity: WorkoutSession) -> WorkoutSessionModel {
        WorkoutSessionModel(
            id: entity.id,
            programId: entity.programId,
            programName: entity.programName,
            trainingDayId: entity.trainingDayId,
            trainingDayName: entity.trainingDayName,
            date: entity.date,
            duration: entity.duration,
            exercises: entity.exercises.map { WorkoutExerciseMapper.toModel(from: $0) },
            bodyWeight: entity.bodyWeight,
            waistCircumference: entity.waistCircumference,
            completed: entity.completed
        )
    }

    static func toDomain(from model: WorkoutSessionModel) -> WorkoutSession {
        WorkoutSession(
            id: model.id,
            programId: model.programId,
            programName: model.programName,
            trainingDayId: model.trainingDayId,
            trainingDayName: model.trainingDayName,
            date: model.date,
            duration: model.duration,
            exercises: model.exercises.map { WorkoutExerciseMapper.toDomain(from: $0) },
            bodyWeight: model.bodyWeight,
            waistCircumference: model.waistCircumference,
            completed: model.completed
        )
    }

    static func toDomain(from models: [WorkoutSessionModel]) -> [WorkoutSession] {
        models.map { toDomain(from: $0) }
    }
}
