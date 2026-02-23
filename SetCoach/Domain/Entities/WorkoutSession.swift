import Foundation

struct WorkoutSession: Identifiable, Equatable, Hashable {
    let id: String
    var programId: String
    var programName: String
    var trainingDayId: String
    var trainingDayName: String
    var date: Date
    var duration: Int
    var exercises: [WorkoutExercise]
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
        exercises: [WorkoutExercise] = [],
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
}
