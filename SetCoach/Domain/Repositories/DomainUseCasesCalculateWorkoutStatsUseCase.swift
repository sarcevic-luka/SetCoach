import Foundation

/// Use Case: Calculate workout statistics and metrics
/// Business Logic: Compute various workout performance metrics
struct CalculateWorkoutStatsUseCase {
    
    private let calculateVolumeUseCase: CalculateTrainingVolumeUseCase
    
    init(calculateVolumeUseCase: CalculateTrainingVolumeUseCase = CalculateTrainingVolumeUseCase()) {
        self.calculateVolumeUseCase = calculateVolumeUseCase
    }
    
    // MARK: - Set Statistics
    
    /// Calculate completed and total sets for exercises
    func executeSetStats(for exercises: [WorkoutExercise]) -> (completed: Int, total: Int) {
        let allSets = exercises.flatMap { $0.sets }
        let completedSets = allSets.filter { $0.completed }
        return (completed: completedSets.count, total: allSets.count)
    }
    
    /// Calculate progress percentage
    func executeProgressPercentage(for exercises: [WorkoutExercise]) -> Double {
        let stats = executeSetStats(for: exercises)
        guard stats.total > 0 else { return 0 }
        return Double(stats.completed) / Double(stats.total)
    }
    
    // MARK: - Volume Statistics
    
    /// Calculate total training volume for a workout session
    func executeTotalVolume(for session: WorkoutSession) -> Double {
        calculateVolumeUseCase.execute(for: session.exercises)
    }
    
    /// Calculate average volume per exercise
    func executeAverageVolumePerExercise(for session: WorkoutSession) -> Double {
        guard !session.exercises.isEmpty else { return 0 }
        let totalVolume = executeTotalVolume(for: session)
        return totalVolume / Double(session.exercises.count)
    }
    
    // MARK: - Rep Statistics
    
    /// Calculate total reps for a workout
    func executeTotalReps(for exercises: [WorkoutExercise]) -> Int {
        exercises.flatMap { $0.sets }.reduce(0) { $0 + $1.reps }
    }
    
    /// Calculate average reps per set
    func executeAverageRepsPerSet(for exercises: [WorkoutExercise]) -> Double {
        let allSets = exercises.flatMap { $0.sets }
        guard !allSets.isEmpty else { return 0 }
        let totalReps = allSets.reduce(0) { $0 + $1.reps }
        return Double(totalReps) / Double(allSets.count)
    }
}
