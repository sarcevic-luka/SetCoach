import Foundation

@MainActor
struct LoadWorkoutSessionsUseCase {
    private let workoutSessionRepository: WorkoutSessionRepositoryProtocol

    init(workoutSessionRepository: WorkoutSessionRepositoryProtocol) {
        self.workoutSessionRepository = workoutSessionRepository
    }

    func execute(sortByDateDescending: Bool = true) throws -> [WorkoutSession] {
        try workoutSessionRepository.fetchAll(sortByDateDescending: sortByDateDescending)
    }
}
