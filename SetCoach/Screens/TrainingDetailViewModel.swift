import SwiftUI
import SwiftData
import Foundation
import Combine

@MainActor
final class TrainingDetailViewModel: ObservableObject {
    let program: Program
    let trainingDay: TrainingDay
    
    @Published var sessions: [WorkoutSession] = []
    
    var lastSession: WorkoutSession? {
        sessions
            .filter { $0.trainingDayId == trainingDay.id && $0.completed }
            .sorted { $0.date > $1.date }
            .first
    }
    
    private var modelContext: ModelContext?
    
    init(program: Program, trainingDay: TrainingDay) {
        self.program = program
        self.trainingDay = trainingDay
    }
    
    func configure(with modelContext: ModelContext) {
        self.modelContext = modelContext
        refresh()
    }
    
    func refresh() {
        guard let ctx = modelContext else { return }
        do {
            let fetchDescriptor = FetchDescriptor<WorkoutSession>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            let fetchedSessions = try ctx.fetch(fetchDescriptor)
            sessions = fetchedSessions
        } catch {
            print("Failed to fetch WorkoutSessions: \(error)")
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
