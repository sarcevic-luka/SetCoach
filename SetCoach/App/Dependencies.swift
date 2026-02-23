import Foundation
import SwiftData
import SwiftUI

private struct DependenciesKey: EnvironmentKey {
    static let defaultValue: Dependencies? = nil
}

extension EnvironmentValues {
    var dependencies: Dependencies? {
        get { self[DependenciesKey.self] }
        set { self[DependenciesKey.self] = newValue }
    }
}

@MainActor
final class Dependencies {
    let router: Router
    private let programRepository: ProgramRepository
    private let workoutSessionRepository: WorkoutSessionRepository

    init(context: ModelContext) {
        self.router = Router()
        self.programRepository = ProgramRepository(context: context)
        self.workoutSessionRepository = WorkoutSessionRepository(context: context)
    }

    // MARK: - Program Use Cases
    
    func makeLoadProgramsUseCase() -> LoadProgramsUseCase {
        LoadProgramsUseCase(programRepository: programRepository)
    }

    func makeSaveProgramUseCase() -> SaveProgramUseCase {
        SaveProgramUseCase(programRepository: programRepository)
    }

    func makeDeleteProgramUseCase() -> DeleteProgramUseCase {
        DeleteProgramUseCase(programRepository: programRepository)
    }

    // MARK: - Workout Session Use Cases
    
    func makeLoadWorkoutSessionsUseCase() -> LoadWorkoutSessionsUseCase {
        LoadWorkoutSessionsUseCase(workoutSessionRepository: workoutSessionRepository)
    }

    func makeSaveWorkoutSessionUseCase() -> SaveWorkoutSessionUseCase {
        SaveWorkoutSessionUseCase(workoutSessionRepository: workoutSessionRepository)
    }

    func makeGetLastWorkoutSessionUseCase() -> GetLastWorkoutSessionUseCase {
        GetLastWorkoutSessionUseCase(loadWorkoutSessionsUseCase: makeLoadWorkoutSessionsUseCase())
    }
    
    func makeCreateManualWorkoutSessionUseCase() -> CreateManualWorkoutSessionUseCase {
        CreateManualWorkoutSessionUseCase(
            initializeExercisesUseCase: makeInitializeWorkoutExercisesUseCase()
        )
    }

    // MARK: - Business Logic Use Cases
    
    func makeCalculateTrainingVolumeUseCase() -> CalculateTrainingVolumeUseCase {
        CalculateTrainingVolumeUseCase()
    }

    func makeDetermineProgressDirectionUseCase() -> DetermineProgressDirectionUseCase {
        DetermineProgressDirectionUseCase()
    }

    func makeInitializeWorkoutExercisesUseCase() -> InitializeWorkoutExercisesUseCase {
        InitializeWorkoutExercisesUseCase()
    }

    func makeCalculateWorkoutStatsUseCase() -> CalculateWorkoutStatsUseCase {
        CalculateWorkoutStatsUseCase()
    }

    func makeFormatDurationUseCase() -> FormatDurationUseCase {
        FormatDurationUseCase()
    }
}
