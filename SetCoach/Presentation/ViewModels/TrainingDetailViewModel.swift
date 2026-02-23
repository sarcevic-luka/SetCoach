import Foundation
import os

@MainActor
@Observable
final class TrainingDetailViewModel {
    let program: Program
    let trainingDay: TrainingDay
    private(set) var sessions: [WorkoutSession] = []

    var lastSession: WorkoutSession? {
        sessions
            .filter { $0.trainingDayId == trainingDay.id && $0.completed }
            .sorted { $0.date > $1.date }
            .first
    }

    private let loadWorkoutSessionsUseCase: LoadWorkoutSessionsUseCase

    init(program: Program, trainingDay: TrainingDay, loadWorkoutSessionsUseCase: LoadWorkoutSessionsUseCase) {
        self.program = program
        self.trainingDay = trainingDay
        self.loadWorkoutSessionsUseCase = loadWorkoutSessionsUseCase
    }

    func loadSessions() {
        do {
            sessions = try loadWorkoutSessionsUseCase.execute(sortByDateDescending: true)
        } catch {
            logger.error("Failed to fetch sessions: \(error.localizedDescription)")
            sessions = []
        }
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "TrainingDetail")
