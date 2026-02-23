import Foundation

/// Use Case: Determine progress direction by comparing current and previous exercise performance
/// Business Logic: Compare volumes to determine if progress is up, down, or same
struct DetermineProgressDirectionUseCase {
    
    private let calculateVolumeUseCase: CalculateTrainingVolumeUseCase
    
    init(calculateVolumeUseCase: CalculateTrainingVolumeUseCase = CalculateTrainingVolumeUseCase()) {
        self.calculateVolumeUseCase = calculateVolumeUseCase
    }
    
    /// Determine progress direction for a single exercise compared to previous session
    func execute(
        currentExercise: WorkoutExercise,
        previousExercise: WorkoutExercise?
    ) -> ProgressDirection {
        guard let previousExercise else {
            return .same
        }
        
        let currentVolume = calculateVolumeUseCase.execute(for: currentExercise)
        let previousVolume = calculateVolumeUseCase.execute(for: previousExercise)
        
        if currentVolume > previousVolume {
            return .up
        } else if currentVolume < previousVolume {
            return .down
        } else {
            return .same
        }
    }
    
    /// Update progress directions for all exercises in current workout
    func execute(
        currentExercises: [WorkoutExercise],
        previousExercises: [WorkoutExercise]?
    ) -> [WorkoutExercise] {
        guard let previousExercises else {
            return currentExercises
        }
        
        return currentExercises.map { currentExercise in
            var updatedExercise = currentExercise
            
            // Find matching previous exercise by template ID
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
