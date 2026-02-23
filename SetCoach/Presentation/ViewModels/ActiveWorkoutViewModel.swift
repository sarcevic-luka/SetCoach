import Foundation
import SwiftUI
import os

/// ViewModel for active workout session
/// Manages workout state and coordinates between Use Cases
@MainActor
@Observable
final class ActiveWorkoutViewModel {

    // MARK: - Published State

    var workoutExercises: [WorkoutExercise] = []
    var elapsedSeconds = 0
    var bodyWeight: Double = 82.0
    var waistCircumference: Double = 84.0
    var restTimerEnabled = false
    var restDuration = 90
    var showRestTimer = false

    // MARK: - Dependencies

    private var timer: Timer?
    private let program: Program
    private let trainingDay: TrainingDay
    private let lastSession: WorkoutSession?
    private let saveWorkoutSessionUseCase: SaveWorkoutSessionUseCase
    private let idleTimerService: IdleTimerManaging
    private let determineProgressUseCase: DetermineProgressDirectionUseCase
    private let calculateStatsUseCase: CalculateWorkoutStatsUseCase
    private let formatDurationUseCase: FormatDurationUseCase
    private let initializeExercisesUseCase: InitializeWorkoutExercisesUseCase
    private let onFinish: () -> Void

    // MARK: - Constants

    static let restDurations = [30, 45, 60, 90, 120, 150, 180, 240]

    // MARK: - Computed Properties

    var completedSets: Int {
        calculateStatsUseCase.executeSetStats(for: workoutExercises).completed
    }

    var totalSets: Int {
        calculateStatsUseCase.executeSetStats(for: workoutExercises).total
    }

    var progressPercentage: Double {
        calculateStatsUseCase.executeProgressPercentage(for: workoutExercises)
    }

    var trainingDayName: String {
        trainingDay.name
    }

    // MARK: - Initialization

    init(
        program: Program,
        trainingDay: TrainingDay,
        lastSession: WorkoutSession?,
        saveWorkoutSessionUseCase: SaveWorkoutSessionUseCase,
        idleTimerService: IdleTimerManaging? = nil,
        determineProgressUseCase: DetermineProgressDirectionUseCase,
        calculateStatsUseCase: CalculateWorkoutStatsUseCase,
        formatDurationUseCase: FormatDurationUseCase,
        initializeExercisesUseCase: InitializeWorkoutExercisesUseCase,
        onFinish: @escaping () -> Void
    ) {
        self.program = program
        self.trainingDay = trainingDay
        self.lastSession = lastSession
        self.saveWorkoutSessionUseCase = saveWorkoutSessionUseCase
        self.idleTimerService = idleTimerService ?? LiveIdleTimerService()
        self.determineProgressUseCase = determineProgressUseCase
        self.calculateStatsUseCase = calculateStatsUseCase
        self.formatDurationUseCase = formatDurationUseCase
        self.initializeExercisesUseCase = initializeExercisesUseCase
        self.onFinish = onFinish
    }

    // MARK: - Public Methods

    func start() {
        initializeWorkout()
        startTimer()
        idleTimerService.setDisabled(true)
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        idleTimerService.setDisabled(false)
    }

    func binding(forExerciseAt index: Int) -> Binding<WorkoutExercise> {
        Binding(
            get: { self.workoutExercises[index] },
            set: { self.workoutExercises[index] = $0 }
        )
    }

    func finishWorkout() {
        updateProgressDirections()

        let session = WorkoutSession(
            programId: program.id,
            programName: program.name,
            trainingDayId: trainingDay.id,
            trainingDayName: trainingDay.name,
            date: Date(),
            duration: formatDurationUseCase.executeAsMinutes(seconds: elapsedSeconds),
            exercises: workoutExercises,
            bodyWeight: bodyWeight,
            waistCircumference: waistCircumference,
            completed: true
        )

        do {
            try saveWorkoutSessionUseCase.execute(session)
        } catch {
            logger.error("Failed to save workout session: \(error.localizedDescription)")
        }

        onFinish()
    }

    func formatRestDuration(_ seconds: Int) -> String {
        formatDurationUseCase.executeAsRestDuration(seconds: seconds)
    }

    func formatElapsedTime() -> String {
        formatDurationUseCase.executeAsElapsedTime(seconds: elapsedSeconds)
    }

    // MARK: - Private Methods

    private func initializeWorkout() {
        workoutExercises = initializeExercisesUseCase.execute(
            from: trainingDay,
            lastSession: lastSession
        )
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
        }
    }

    private func updateProgressDirections() {
        workoutExercises = determineProgressUseCase.execute(
            currentExercises: workoutExercises,
            previousExercises: lastSession?.exercises
        )
    }
}

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "ActiveWorkout")
