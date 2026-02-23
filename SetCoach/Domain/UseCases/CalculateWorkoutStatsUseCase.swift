import Foundation

/// Use Case: Calculate workout statistics and metrics
struct CalculateWorkoutStatsUseCase {
    private let calculateVolumeUseCase: CalculateTrainingVolumeUseCase

    init(calculateVolumeUseCase: CalculateTrainingVolumeUseCase = CalculateTrainingVolumeUseCase()) {
        self.calculateVolumeUseCase = calculateVolumeUseCase
    }

    func executeSetStats(for exercises: [WorkoutExercise]) -> (completed: Int, total: Int) {
        let allSets = exercises.flatMap { $0.sets }
        let completedSets = allSets.filter { $0.completed }
        return (completed: completedSets.count, total: allSets.count)
    }

    func executeProgressPercentage(for exercises: [WorkoutExercise]) -> Double {
        let stats = executeSetStats(for: exercises)
        guard stats.total > 0 else { return 0 }
        return Double(stats.completed) / Double(stats.total)
    }

    func executeTotalVolume(for session: WorkoutSession) -> Double {
        calculateVolumeUseCase.execute(for: session.exercises)
    }

    func executeAverageVolumePerExercise(for session: WorkoutSession) -> Double {
        guard !session.exercises.isEmpty else { return 0 }
        return executeTotalVolume(for: session) / Double(session.exercises.count)
    }

    func executeTotalReps(for exercises: [WorkoutExercise]) -> Int {
        exercises.flatMap { $0.sets }.reduce(0) { $0 + $1.reps }
    }

    func executeAverageRepsPerSet(for exercises: [WorkoutExercise]) -> Double {
        let allSets = exercises.flatMap { $0.sets }
        guard !allSets.isEmpty else { return 0 }
        return Double(allSets.reduce(0) { $0 + $1.reps }) / Double(allSets.count)
    }
}
