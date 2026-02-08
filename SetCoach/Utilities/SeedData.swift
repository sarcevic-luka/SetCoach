import Foundation
import SwiftData
import os

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "SeedData")

enum SeedData {
    static func createSeedPrograms(context: ModelContext) {
        let descriptor = FetchDescriptor<Program>()
        guard (try? context.fetchCount(descriptor)) == 0 else { return }

        let pplProgram = Program(
            name: "Push Pull Legs",
            programDescription: "Classic 3-day split for strength and hypertrophy"
        )

        let pushExercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, notes: "Pause at bottom"),
            ExerciseTemplate(name: "Overhead Press", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Incline DB Press", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Lateral Raises", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Tricep Pushdowns", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
        ]
        pushExercises.forEach { context.insert($0) }
        let pushDay = TrainingDay(name: "Push Day")
        pushDay.exercises = pushExercises

        let pullExercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Deadlift", targetSets: 3, targetRepsMin: 5, targetRepsMax: 6, notes: "Belt for top sets"),
            ExerciseTemplate(name: "Barbell Row", targetSets: 4, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Pull-ups", targetSets: 3, targetRepsMin: 6, targetRepsMax: 10),
            ExerciseTemplate(name: "Face Pulls", targetSets: 3, targetRepsMin: 15, targetRepsMax: 20),
            ExerciseTemplate(name: "Bicep Curls", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
        ]
        pullExercises.forEach { context.insert($0) }
        let pullDay = TrainingDay(name: "Pull Day")
        pullDay.exercises = pullExercises

        let legExercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Squat", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, notes: "ATG depth"),
            ExerciseTemplate(name: "Romanian Deadlift", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Leg Press", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Leg Curl", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Calf Raises", targetSets: 4, targetRepsMin: 12, targetRepsMax: 15),
        ]
        legExercises.forEach { context.insert($0) }
        let legDay = TrainingDay(name: "Leg Day")
        legDay.exercises = legExercises

        for day in [pushDay, pullDay, legDay] {
            context.insert(day)
        }
        pplProgram.trainingDays = [pushDay, pullDay, legDay]
        context.insert(pplProgram)

        do {
            try context.save()
        } catch {
            logger.error("Failed to save seed data: \(error.localizedDescription)")
        }
    }
}
