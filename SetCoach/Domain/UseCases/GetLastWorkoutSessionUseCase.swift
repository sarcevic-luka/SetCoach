import Foundation

/// Use Case: Get the most recent workout session for a specific training day
@MainActor
struct GetLastWorkoutSessionUseCase {
    private let loadWorkoutSessionsUseCase: LoadWorkoutSessionsUseCase

    init(loadWorkoutSessionsUseCase: LoadWorkoutSessionsUseCase) {
        self.loadWorkoutSessionsUseCase = loadWorkoutSessionsUseCase
    }

    func execute(for trainingDayId: String) throws -> WorkoutSession? {
        let sessions = try loadWorkoutSessionsUseCase.execute(sortByDateDescending: true)
        return sessions
            .filter { $0.trainingDayId == trainingDayId && $0.completed }
            .first
    }

    func executeForProgram(_ programId: String) throws -> WorkoutSession? {
        let sessions = try loadWorkoutSessionsUseCase.execute(sortByDateDescending: true)
        return sessions
            .filter { $0.programId == programId && $0.completed }
            .first
    }
}
