import Foundation

/// Use Case: Determine progress direction by comparing current and previous exercise performance
struct DetermineProgressDirectionUseCase {
    private let calculateVolumeUseCase: CalculateTrainingVolumeUseCase

    init(calculateVolumeUseCase: CalculateTrainingVolumeUseCase = CalculateTrainingVolumeUseCase()) {
        self.calculateVolumeUseCase = calculateVolumeUseCase
    }

    func execute(
        currentExercise: WorkoutExercise,
        previousExercise: WorkoutExercise?
    ) -> ProgressDirection {
        guard let previousExercise else { return .same }
        let currentVolume = calculateVolumeUseCase.execute(for: currentExercise)
        let previousVolume = calculateVolumeUseCase.execute(for: previousExercise)
        if currentVolume > previousVolume { return .up }
        if currentVolume < previousVolume { return .down }
        return .same
    }

    func execute(
        currentExercises: [WorkoutExercise],
        previousExercises: [WorkoutExercise]?
    ) -> [WorkoutExercise] {
        guard let previousExercises else { return currentExercises }
        return currentExercises.map { currentExercise in
            var updatedExercise = currentExercise
            let previousExercise = previousExercises.first {
                $0.exerciseTemplateId == currentExercise.exerciseTemplateId
            }
            updatedExercise.progressDirection = execute(
                currentExercise: currentExercise,
                previousExercise: previousExercise
            )
            return updatedExercise
        }
    }
}
