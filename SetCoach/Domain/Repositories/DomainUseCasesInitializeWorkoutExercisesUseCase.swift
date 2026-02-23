import Foundation

/// Use Case: Initialize workout exercises from training template using last session data
/// Business Logic: Pre-populate exercise sets with previous session's weights and reps
struct InitializeWorkoutExercisesUseCase {
    
    /// Initialize workout exercises from a training day template
    /// - Parameters:
    ///   - trainingDay: The template training day
    ///   - lastSession: Previous session to pull data from (optional)
    /// - Returns: Array of initialized workout exercises
    func execute(
        from trainingDay: TrainingDay,
        lastSession: WorkoutSession?
    ) -> [WorkoutExercise] {
        trainingDay.exercises.map { template in
            createWorkoutExercise(from: template, lastSession: lastSession)
        }
    }
    
    // MARK: - Private Helpers
    
    private func createWorkoutExercise(
        from template: ExerciseTemplate,
        lastSession: WorkoutSession?
    ) -> WorkoutExercise {
        // Find matching exercise from last session
        let lastExercise = lastSession?.exercises.first {
            $0.exerciseTemplateId == template.id
        }
        
        // Create sets based on template target
        let sets = (1...template.targetSets).map { setNumber in
            createExerciseSet(
                setNumber: setNumber,
                template: template,
                lastExercise: lastExercise
            )
        }
        
        return WorkoutExercise(
            exerciseTemplateId: template.id,
            name: template.name,
            sets: sets,
            notes: template.notes
        )
    }
    
    private func createExerciseSet(
        setNumber: Int,
        template: ExerciseTemplate,
        lastExercise: WorkoutExercise?
    ) -> ExerciseSet {
        // Find matching set from last session
        let lastSet = lastExercise?.sets.first { $0.setNumber == setNumber }
        
        return ExerciseSet(
            setNumber: setNumber,
            weight: lastSet?.weight ?? 0,
            reps: lastSet?.reps ?? template.targetRepsMin,
            completed: false
        )
    }
}
