import Foundation
import SwiftData
import SwiftUI
import os

@MainActor
@Observable
final class ActiveWorkoutViewModel {
    var workoutExercises: [WorkoutExercise] = []
    var elapsedSeconds = 0
    var bodyWeight: Double = 82.0
    var waistCircumference: Double = 84.0
    var restTimerEnabled = false
    var restDuration = 90
    var showRestTimer = false

    private var timer: Timer?
    private let program: Program
    private let trainingDay: TrainingDay
    private let lastSession: WorkoutSession?
    private let modelContext: ModelContext
    private let idleTimerService: IdleTimerManaging
    private let onFinish: () -> Void

    static let restDurations = [30, 45, 60, 90, 120, 150, 180, 240]

    var completedSets: Int {
        workoutExercises.flatMap(\.sets).filter(\.completed).count
    }

    var totalSets: Int {
        workoutExercises.flatMap(\.sets).count
    }

    var progressPercentage: Double {
        guard totalSets > 0 else { return 0 }
        return Double(completedSets) / Double(totalSets)
    }

    var trainingDayName: String {
        trainingDay.name
    }

    init(
        program: Program,
        trainingDay: TrainingDay,
        lastSession: WorkoutSession?,
        modelContext: ModelContext,
        idleTimerService: IdleTimerManaging = LiveIdleTimerService(),
        onFinish: @escaping () -> Void
    ) {
        self.program = program
        self.trainingDay = trainingDay
        self.lastSession = lastSession
        self.modelContext = modelContext
        self.idleTimerService = idleTimerService
        self.onFinish = onFinish
    }

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
            duration: elapsedSeconds / 60,
            exercises: workoutExercises,
            bodyWeight: bodyWeight,
            waistCircumference: waistCircumference,
            completed: true
        )
        modelContext.insert(session)
        do {
            try modelContext.save()
        } catch {
            logger.error("Failed to save workout session: \(error.localizedDescription)")
        }
        onFinish()
    }

    func formatRestDuration(_ seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds)s"
        } else if seconds % 60 == 0 {
            return "\(seconds / 60)m"
        } else {
            return "\(seconds / 60)m \(seconds % 60)s"
        }
    }

    func formatElapsedTime() -> String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func initializeWorkout() {
        workoutExercises = trainingDay.exercises.map { template in
            let lastExercise = lastSession?.exercises.first { $0.exerciseTemplateId == template.id }
            let sets = (1...template.targetSets).map { setNum in
                let lastSet = lastExercise?.sets.first { $0.setNumber == setNum }
                return ExerciseSet(
                    setNumber: setNum,
                    weight: lastSet?.weight ?? 0,
                    reps: lastSet?.reps ?? template.targetRepsMin,
                    completed: false
                )
            }
            return WorkoutExercise(
                exerciseTemplateId: template.id,
                name: template.name,
                sets: sets,
                notes: template.notes
            )
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
        }
    }

    private func updateProgressDirections() {
        for i in workoutExercises.indices {
            let currentVolume = workoutExercises[i].sets.reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
            if let lastExercise = lastSession?.exercises.first(where: { $0.exerciseTemplateId == workoutExercises[i].exerciseTemplateId }) {
                let lastVolume = lastExercise.sets.reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
                if currentVolume > lastVolume {
                    workoutExercises[i].progressDirection = .up
                } else if currentVolume < lastVolume {
                    workoutExercises[i].progressDirection = .down
                } else {
                    workoutExercises[i].progressDirection = .same
                }
            }
        }
    }
}

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "ActiveWorkout")
