import Foundation
import SwiftData

@Model
final class WorkoutSessionModel {
    @Attribute(.unique) var id: String
    var programId: String
    var programName: String
    var trainingDayId: String
    var trainingDayName: String
    var date: Date
    var duration: Int
    @Relationship(deleteRule: .cascade) var exercises: [WorkoutExerciseModel]
    var bodyWeight: Double?
    var waistCircumference: Double?
    var completed: Bool

    init(
        id: String = UUID().uuidString,
        programId: String,
        programName: String,
        trainingDayId: String,
        trainingDayName: String,
        date: Date = Date(),
        duration: Int = 0,
        exercises: [WorkoutExerciseModel] = [],
        bodyWeight: Double? = nil,
        waistCircumference: Double? = nil,
        completed: Bool = false
    ) {
        self.id = id
        self.programId = programId
        self.programName = programName
        self.trainingDayId = trainingDayId
        self.trainingDayName = trainingDayName
        self.date = date
        self.duration = duration
        self.exercises = exercises
        self.bodyWeight = bodyWeight
        self.waistCircumference = waistCircumference
        self.completed = completed
    }

    convenience init(from entity: WorkoutSession) {
        self.init(
            id: entity.id,
            programId: entity.programId,
            programName: entity.programName,
            trainingDayId: entity.trainingDayId,
            trainingDayName: entity.trainingDayName,
            date: entity.date,
            duration: entity.duration,
            exercises: entity.exercises.map { WorkoutExerciseModel(from: $0) },
            bodyWeight: entity.bodyWeight,
            waistCircumference: entity.waistCircumference,
            completed: entity.completed
        )
    }

    func toDomain() -> WorkoutSession {
        WorkoutSession(
            id: id,
            programId: programId,
            programName: programName,
            trainingDayId: trainingDayId,
            trainingDayName: trainingDayName,
            date: date,
            duration: duration,
            exercises: exercises.map { $0.toDomain() },
            bodyWeight: bodyWeight,
            waistCircumference: waistCircumference,
            completed: completed
        )
    }
}
