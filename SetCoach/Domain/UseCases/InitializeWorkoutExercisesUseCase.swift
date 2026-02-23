import Foundation

/// Use Case: Initialize workout exercises from training template using last session data
struct InitializeWorkoutExercisesUseCase {

    func execute(
        from trainingDay: TrainingDay,
        lastSession: WorkoutSession?
    ) -> [WorkoutExercise] {
        trainingDay.exercises.map { template in
            createWorkoutExercise(from: template, lastSession: lastSession)
        }
    }

    private func createWorkoutExercise(
        from template: ExerciseTemplate,
        lastSession: WorkoutSession?
    ) -> WorkoutExercise {
        let lastExercise = lastSession?.exercises.first { $0.exerciseTemplateId == template.id }
        let sets = (1...template.targetSets).map { setNumber in
            createExerciseSet(setNumber: setNumber, template: template, lastExercise: lastExercise)
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
        let lastSet = lastExercise?.sets.first { $0.setNumber == setNumber }
        return ExerciseSet(
            setNumber: setNumber,
            weight: lastSet?.weight ?? 0,
            reps: lastSet?.reps ?? template.targetRepsMin,
            completed: false
        )
    }
}
