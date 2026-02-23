import Foundation
import SwiftData
import os

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "SeedData")

enum SeedData {

    static func createSeedPrograms(context: ModelContext) {
        let descriptor = FetchDescriptor<ProgramModel>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        if existingCount == 0 {
            for program in buildDefaultPrograms() {
                insertProgram(program, into: context)
            }
        } else {
            let existing = (try? context.fetch(descriptor)) ?? []
            let existingNames = Set(existing.map(\.name))
            for program in buildDefaultPrograms() where !existingNames.contains(program.name) {
                insertProgram(program, into: context)
            }
        }

        do {
            try context.save()
        } catch {
            logger.error("Failed to save seed data: \(error.localizedDescription)")
        }
    }

    private static func buildDefaultPrograms() -> [Program] {
        // MARK: - 1. Push Pull Legs
        var pushDay = TrainingDay(name: "Push Day")
        pushDay.exercises = [
            ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "Overhead Press", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Incline DB Press", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Lateral Raises", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Tricep Pushdowns", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
        ]

        var pullDay = TrainingDay(name: "Pull Day")
        pullDay.exercises = [
            ExerciseTemplate(name: "Deadlift", targetSets: 3, targetRepsMin: 5, targetRepsMax: 6),
            ExerciseTemplate(name: "Barbell Row", targetSets: 4, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Pull-ups", targetSets: 3, targetRepsMin: 6, targetRepsMax: 10),
            ExerciseTemplate(name: "Face Pulls", targetSets: 3, targetRepsMin: 15, targetRepsMax: 20),
            ExerciseTemplate(name: "Bicep Curls", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
        ]

        var legDay = TrainingDay(name: "Leg Day")
        legDay.exercises = [
            ExerciseTemplate(name: "Squat", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "Romanian Deadlift", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Leg Press", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Leg Curl", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Calf Raises", targetSets: 4, targetRepsMin: 12, targetRepsMax: 15),
        ]

        var ppl = Program(name: "Push Pull Legs",
                          programDescription: "Classic 3-day split for strength & hypertrophy")
        ppl.trainingDays = [pushDay, pullDay, legDay]

        // MARK: - 2. Upper / Lower 4-Day

        var upper1 = TrainingDay(name: "Upper A")
        upper1.exercises = [
            ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 5, targetRepsMax: 8),
            ExerciseTemplate(name: "Barbell Row", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "Overhead Press", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Pull-ups", targetSets: 3, targetRepsMin: 8, targetRepsMax: 12),
            ExerciseTemplate(name: "Tricep Pushdown", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
        ]

        var lower1 = TrainingDay(name: "Lower A")
        lower1.exercises = [
            ExerciseTemplate(name: "Squat", targetSets: 4, targetRepsMin: 5, targetRepsMax: 8),
            ExerciseTemplate(name: "Romanian Deadlift", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Walking Lunges", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Calf Raises", targetSets: 4, targetRepsMin: 12, targetRepsMax: 15),
        ]

        var upperLower = Program(name: "Upper Lower 4-Day",
                                 programDescription: "Balanced 4-day strength & hypertrophy split")
        upperLower.trainingDays = [upper1, lower1]

        // MARK: - 3. Beginner Full Body

        var beginnerDay = TrainingDay(name: "Full Body")
        beginnerDay.exercises = [
            ExerciseTemplate(name: "Goblet Squat", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Push-ups", targetSets: 3, targetRepsMin: 8, targetRepsMax: 15),
            ExerciseTemplate(name: "Lat Pulldown", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Hip Thrust", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Plank Hold", targetSets: 3, targetRepsMin: 30, targetRepsMax: 60, notes: "seconds"),
        ]

        var beginner = Program(name: "Beginner Full Body",
                               programDescription: "Perfect start for gym beginners")
        beginner.trainingDays = [beginnerDay]

        // MARK: - 4. Strength 5x5

        var strengthDay = TrainingDay(name: "5x5 Day")
        strengthDay.exercises = [
            ExerciseTemplate(name: "Squat", targetSets: 5, targetRepsMin: 5, targetRepsMax: 5),
            ExerciseTemplate(name: "Bench Press", targetSets: 5, targetRepsMin: 5, targetRepsMax: 5),
            ExerciseTemplate(name: "Barbell Row", targetSets: 5, targetRepsMin: 5, targetRepsMax: 5),
        ]

        var strength = Program(name: "Strength 5x5",
                               programDescription: "Pure strength focused program")
        strength.trainingDays = [strengthDay]

        // MARK: - 5. Glute Focus

        var gluteDay = TrainingDay(name: "Glute Day")
        gluteDay.exercises = [
            ExerciseTemplate(name: "Hip Thrust", targetSets: 4, targetRepsMin: 8, targetRepsMax: 12),
            ExerciseTemplate(name: "Bulgarian Split Squat", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Romanian Deadlift", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Cable Kickbacks", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
        ]

        var glute = Program(name: "Glute Focus",
                            programDescription: "Lower body & glute hypertrophy focus")
        glute.trainingDays = [gluteDay]

        // MARK: - 6. Fat Loss Conditioning

        var fatLossDay = TrainingDay(name: "Conditioning")
        fatLossDay.exercises = [
            ExerciseTemplate(name: "Kettlebell Swings", targetSets: 4, targetRepsMin: 15, targetRepsMax: 20),
            ExerciseTemplate(name: "Burpees", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Battle Ropes", targetSets: 3, targetRepsMin: 30, targetRepsMax: 45, notes: "seconds"),
            ExerciseTemplate(name: "Box Jumps", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
        ]

        var fatLoss = Program(name: "Fat Loss Conditioning",
                              programDescription: "High intensity fat burning workout")
        fatLoss.trainingDays = [fatLossDay]

        // MARK: - 7. Powerbuilding

        var powerDay = TrainingDay(name: "Power Day")
        powerDay.exercises = [
            ExerciseTemplate(name: "Deadlift", targetSets: 4, targetRepsMin: 3, targetRepsMax: 5),
            ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 5, targetRepsMax: 8),
            ExerciseTemplate(name: "Squat", targetSets: 4, targetRepsMin: 5, targetRepsMax: 8),
            ExerciseTemplate(name: "Incline DB Press", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
        ]

        var powerbuilding = Program(name: "Powerbuilding",
                                    programDescription: "Strength + hypertrophy hybrid")
        powerbuilding.trainingDays = [powerDay]

        return [ppl, upperLower, beginner, strength, glute, fatLoss, powerbuilding]
    }


    static func insertProgram(_ program: Program, into context: ModelContext) {
        let programModel = ProgramMapper.toModel(from: program)
        for day in programModel.trainingDays {
            for ex in day.exercises {
                context.insert(ex)
            }
            context.insert(day)
        }
        context.insert(programModel)
    }
}
