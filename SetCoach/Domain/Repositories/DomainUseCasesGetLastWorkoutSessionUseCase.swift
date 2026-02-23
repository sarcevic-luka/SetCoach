import Foundation

/// Use Case: Get the most recent workout session for a specific training day
/// Business Logic: Filter by training day and completed status, then sort by date
@MainActor
struct GetLastWorkoutSessionUseCase {
    
    private let loadWorkoutSessionsUseCase: LoadWorkoutSessionsUseCase
    
    init(loadWorkoutSessionsUseCase: LoadWorkoutSessionsUseCase) {
        self.loadWorkoutSessionsUseCase = loadWorkoutSessionsUseCase
    }
    
    /// Get the last completed session for a specific training day
    /// - Parameter trainingDayId: The ID of the training day
    /// - Returns: The most recent completed session, or nil if none exists
    /// - Throws: If fetching sessions fails
    func execute(for trainingDayId: String) throws -> WorkoutSession? {
        let sessions = try loadWorkoutSessionsUseCase.execute(sortByDateDescending: true)
        
        return sessions
            .filter { $0.trainingDayId == trainingDayId && $0.completed }
            .first // Already sorted by date descending
    }
    
    /// Get the last completed session for any training day in a program
    /// - Parameter programId: The ID of the program
    /// - Returns: The most recent completed session, or nil if none exists
    /// - Throws: If fetching sessions fails
    func executeForProgram(_ programId: String) throws -> WorkoutSession? {
        let sessions = try loadWorkoutSessionsUseCase.execute(sortByDateDescending: true)
        
        return sessions
            .filter { $0.programId == programId && $0.completed }
            .first
    }
}
