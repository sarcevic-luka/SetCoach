import Foundation

@MainActor
@Observable
final class HistoryViewModel {
    private(set) var completedSessions: [WorkoutSession] = []

    var isEmpty: Bool {
        completedSessions.isEmpty
    }

    var completedCount: Int {
        completedSessions.count
    }

    private let loadWorkoutSessionsUseCase: LoadWorkoutSessionsUseCase

    init(loadWorkoutSessionsUseCase: LoadWorkoutSessionsUseCase) {
        self.loadWorkoutSessionsUseCase = loadWorkoutSessionsUseCase
    }

    func loadSessions() {
        do {
            let sessions = try loadWorkoutSessionsUseCase.execute(sortByDateDescending: true)
            completedSessions = sessions.filter(\.completed)
        } catch {
            completedSessions = []
        }
    }
}
