import Foundation

/// Creates a workout session for manual entry (logging past workouts).
struct CreateManualWorkoutSessionUseCase {
    private let initializeExercisesUseCase: InitializeWorkoutExercisesUseCase

    init(initializeExercisesUseCase: InitializeWorkoutExercisesUseCase) {
        self.initializeExercisesUseCase = initializeExercisesUseCase
    }

    /// Creates an incomplete WorkoutSession from a program and training day, ready for manual entry.
    func execute(
        from program: Program,
        trainingDay: TrainingDay,
        date: Date = Date(),
        lastSession: WorkoutSession? = nil
    ) -> WorkoutSession {
        let exercises = initializeExercisesUseCase.execute(
            from: trainingDay,
            lastSession: lastSession
        )
        return WorkoutSession(
            programId: program.id,
            programName: program.name,
            trainingDayId: trainingDay.id,
            trainingDayName: trainingDay.name,
            date: date,
            duration: 0,
            exercises: exercises,
            bodyWeight: nil,
            waistCircumference: nil,
            completed: false
        )
    }
}
