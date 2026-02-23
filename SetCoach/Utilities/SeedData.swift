import Foundation
import SwiftData
import os

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "SeedData")

enum SeedData {
    static func createSeedPrograms(context: ModelContext) {
        let descriptor = FetchDescriptor<ProgramModel>()
        guard (try? context.fetchCount(descriptor)) == 0 else { return }

        let pushExercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, notes: "Pause at bottom"),
            ExerciseTemplate(name: "Overhead Press", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Incline DB Press", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Lateral Raises", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Tricep Pushdowns", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
        ]
        var pushDay = TrainingDay(name: "Push Day")
        pushDay.exercises = pushExercises

        let pullExercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Deadlift", targetSets: 3, targetRepsMin: 5, targetRepsMax: 6, notes: "Belt for top sets"),
            ExerciseTemplate(name: "Barbell Row", targetSets: 4, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Pull-ups", targetSets: 3, targetRepsMin: 6, targetRepsMax: 10),
            ExerciseTemplate(name: "Face Pulls", targetSets: 3, targetRepsMin: 15, targetRepsMax: 20),
            ExerciseTemplate(name: "Bicep Curls", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
        ]
        var pullDay = TrainingDay(name: "Pull Day")
        pullDay.exercises = pullExercises

        let legExercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Squat", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, notes: "ATG depth"),
            ExerciseTemplate(name: "Romanian Deadlift", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Leg Press", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Leg Curl", targetSets: 3, targetRepsMin: 10, targetRepsMax: 12),
            ExerciseTemplate(name: "Calf Raises", targetSets: 4, targetRepsMin: 12, targetRepsMax: 15),
        ]
        var legDay = TrainingDay(name: "Leg Day")
        legDay.exercises = legExercises

        var pplProgram = Program(
            name: "Push Pull Legs",
            programDescription: "Classic 3-day split for strength and hypertrophy"
        )
        pplProgram.trainingDays = [pushDay, pullDay, legDay]
        insertProgram(pplProgram, into: context)

        let trening1Exercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Čučanj", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "Nožna ekstenzija", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Kosi bench press na Smith mašini", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "Veslanje u pretklonu", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Rameni potisak bučicama", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Lat pulldown", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Triceps ekstenzija", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Pregib EZ šipkom", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Podizanje nogu za trbuh (ležeći)", targetSets: 3, targetRepsMin: 15, targetRepsMax: 25, notes: "MAX"),
        ]
        var trening1 = TrainingDay(name: "Trening 1")
        trening1.exercises = trening1Exercises

        let trening2Exercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Rumunjsko mrtvo dizanje", targetSets: 4, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Nožni pregib", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Ravni potisak bučicama", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "Veslanje bučicom u pretklonu", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
            ExerciseTemplate(name: "Odručenje bučicama", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Lat pulldown uskim hvatom", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Triceps ekstenzija iznad glave", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Hammer pregib", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Podizanje nogu za trbuh (viseći)", targetSets: 3, targetRepsMin: 15, targetRepsMax: 25, notes: "MAX"),
        ]
        var trening2 = TrainingDay(name: "Trening 2")
        trening2.exercises = trening2Exercises

        let trening3Exercises: [ExerciseTemplate] = [
            ExerciseTemplate(name: "Mrtvo dizanje", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "Face pulls", targetSets: 4, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Kosi bench press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "T-bar veslanje", targetSets: 3, targetRepsMin: 6, targetRepsMax: 8),
            ExerciseTemplate(name: "Propadanja", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Slijeganje bučicama", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Potisak sa čela EZ šipkom", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Pregib bučicama", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Cable crunch za trbuh", targetSets: 3, targetRepsMin: 12, targetRepsMax: 15),
            ExerciseTemplate(name: "Podizanje za listove - Smith mašina", targetSets: 4, targetRepsMin: 12, targetRepsMax: 15),
        ]
        var trening3 = TrainingDay(name: "Trening 3")
        trening3.exercises = trening3Exercises

        var fullBodyProgram = Program(
            name: "Full Body 3-Day",
            programDescription: "Trening 1, 2, 3 – puni tijelo u tri dana"
        )
        fullBodyProgram.trainingDays = [trening1, trening2, trening3]
        insertProgram(fullBodyProgram, into: context)

        do {
            try context.save()
        } catch {
            logger.error("Failed to save seed data: \(error.localizedDescription)")
        }
    }

    static func insertProgram(_ program: Program, into context: ModelContext) {
        let programModel = ProgramModel(from: program)
        for day in programModel.trainingDays {
            for ex in day.exercises {
                context.insert(ex)
            }
            context.insert(day)
        }
        context.insert(programModel)
    }
}
