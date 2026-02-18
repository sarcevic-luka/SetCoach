import Foundation
import SwiftData

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

    func updateSessions(_ sessions: [WorkoutSession]) {
        completedSessions = sessions.filter(\.completed)
    }
}
