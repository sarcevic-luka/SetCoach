import Foundation

/// Use Case: Calculate training volume for a set of exercises
/// Business Logic: Volume = Weight × Reps for all sets
struct CalculateTrainingVolumeUseCase {

    /// Calculate total volume for a single exercise
    func execute(for exercise: WorkoutExercise) -> Double {
        exercise.sets.reduce(0.0) { total, set in
            total + (set.weight * Double(set.reps))
        }
    }

    /// Calculate total volume for multiple exercises
    func execute(for exercises: [WorkoutExercise]) -> Double {
        exercises.reduce(0.0) { total, exercise in
            total + execute(for: exercise)
        }
    }

    /// Calculate volume for specific sets only
    func execute(for sets: [ExerciseSet]) -> Double {
        sets.reduce(0.0) { total, set in
            total + (set.weight * Double(set.reps))
        }
    }
}
