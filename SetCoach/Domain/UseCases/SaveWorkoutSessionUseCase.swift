import Foundation

@MainActor
struct SaveWorkoutSessionUseCase {
    private let workoutSessionRepository: WorkoutSessionRepositoryProtocol

    init(workoutSessionRepository: WorkoutSessionRepositoryProtocol) {
        self.workoutSessionRepository = workoutSessionRepository
    }

    func execute(_ session: WorkoutSession) throws {
        try workoutSessionRepository.save(session)
    }
}
