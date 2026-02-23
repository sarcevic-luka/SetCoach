import Foundation
import SwiftUI
import os

@MainActor
@Observable
final class ManualWorkoutEntryViewModel {
    var workoutSession: WorkoutSession
    var selectedDate: Date
    var duration: String = ""
    var bodyWeight: String = ""
    var waistCircumference: String = ""

    private let saveWorkoutSessionUseCase: SaveWorkoutSessionUseCase
    private let determineProgressUseCase: DetermineProgressDirectionUseCase
    private let onFinish: () -> Void

    var isValid: Bool {
        workoutSession.exercises.contains { exercise in
            exercise.sets.contains { $0.completed }
        }
    }

    var completedSets: Int {
        workoutSession.exercises.flatMap(\.sets).filter(\.completed).count
    }

    var totalSets: Int {
        workoutSession.exercises.flatMap(\.sets).count
    }

    var navigationTitle: String {
        String(localized: "Log Workout")
    }

    init(
        workoutSession: WorkoutSession,
        saveWorkoutSessionUseCase: SaveWorkoutSessionUseCase,
        determineProgressUseCase: DetermineProgressDirectionUseCase,
        onFinish: @escaping () -> Void
    ) {
        self.workoutSession = workoutSession
        self.selectedDate = workoutSession.date
        self.saveWorkoutSessionUseCase = saveWorkoutSessionUseCase
        self.determineProgressUseCase = determineProgressUseCase
        self.onFinish = onFinish
        if let bw = workoutSession.bodyWeight {
            self.bodyWeight = String(format: "%.1f", bw)
        }
        if let waist = workoutSession.waistCircumference {
            self.waistCircumference = String(format: "%.1f", waist)
        }
        if workoutSession.duration > 0 {
            self.duration = String(workoutSession.duration)
        }
    }

    func binding(forExerciseAt index: Int) -> Binding<WorkoutExercise> {
        Binding(
            get: { self.workoutSession.exercises[index] },
            set: { self.workoutSession.exercises[index] = $0 }
        )
    }

    func saveWorkout() {
        guard isValid else { return }
        updateProgressDirections()
        var finalSession = workoutSession
        finalSession.date = selectedDate
        finalSession.duration = parseDuration(from: duration)
        finalSession.bodyWeight = parseDouble(from: bodyWeight)
        finalSession.waistCircumference = parseDouble(from: waistCircumference)
        finalSession.completed = true
        do {
            try saveWorkoutSessionUseCase.execute(finalSession)
            onFinish()
        } catch {
            logger.error("Failed to save manual workout: \(error.localizedDescription)")
        }
    }

    private func updateProgressDirections() {
        workoutSession.exercises = determineProgressUseCase.execute(
            currentExercises: workoutSession.exercises,
            previousExercises: nil
        )
    }

    /// Parses duration string into minutes. "45" → 45, "1:30" → 90 (1h 30m).
    private func parseDuration(from string: String) -> Int {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return 0 }
        if trimmed.contains(":") {
            let parts = trimmed.split(separator: ":")
            guard parts.count >= 2,
                  let first = Int(parts[0]),
                  let second = Int(parts[1]) else {
                return Int(trimmed) ?? 0
            }
            return first * 60 + second
        }
        return Int(trimmed) ?? 0
    }

    private func parseDouble(from string: String) -> Double? {
        let trimmed = string.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }
        return Double(trimmed)
    }
}

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "ManualWorkoutEntry")
