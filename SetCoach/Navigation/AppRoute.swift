import Foundation

enum AppRoute: Hashable {
    case programDetail(Program)
    case trainingDetail(Program, TrainingDay)
    case activeWorkout(Program, TrainingDay)
    case history
    case sessionDetail(WorkoutSession)
    case exerciseHistory(String)
    case addProgram(Program?)
}
