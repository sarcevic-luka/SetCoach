import Foundation
import SwiftData
import SwiftUI
import os

@MainActor
@Observable
final class AddEditProgramViewModel {
    var programName = ""
    var programDescription = ""
    var trainingDays: [TrainingDayEdit] = []

    private let editProgram: Program?
    private let modelContext: ModelContext
    private let onFinish: () -> Void

    var isValid: Bool {
        !programName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !trainingDays.isEmpty &&
        trainingDays.allSatisfy { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var saveButtonTitle: String {
        editProgram == nil ? "Create Program" : "Save Changes"
    }

    var navigationTitle: String {
        editProgram == nil ? "New Program" : "Edit Program"
    }

    init(
        editProgram: Program?,
        modelContext: ModelContext,
        onFinish: @escaping () -> Void
    ) {
        self.editProgram = editProgram
        self.modelContext = modelContext
        self.onFinish = onFinish
    }

    func loadProgramData() {
        if let program = editProgram {
            programName = program.name
            programDescription = program.programDescription ?? ""
            trainingDays = program.trainingDays.map { day in
                TrainingDayEdit(
                    id: day.id,
                    name: day.name,
                    exercises: day.exercises.map { ex in
                        ExerciseEdit(
                            id: ex.id,
                            name: ex.name,
                            targetSets: ex.targetSets,
                            targetRepsMin: ex.targetRepsMin,
                            targetRepsMax: ex.targetRepsMax,
                            notes: ex.notes ?? ""
                        )
                    }
                )
            }
        } else {
            addTrainingDay()
        }
    }

    func addTrainingDay() {
        trainingDays.append(TrainingDayEdit(
            id: UUID().uuidString,
            name: "",
            exercises: [ExerciseEdit(id: UUID().uuidString)]
        ))
    }

    func removeTrainingDay(id: String) {
        trainingDays.removeAll { $0.id == id }
    }

    func binding(forTrainingDayAt index: Int) -> Binding<TrainingDayEdit> {
        Binding(
            get: { self.trainingDays[index] },
            set: { self.trainingDays[index] = $0 }
        )
    }

    func saveProgram() {
        if let existing = editProgram {
            updateExistingProgram(existing)
        } else {
            createNewProgram()
        }
        do {
            try modelContext.save()
            onFinish()
        } catch {
            logger.error("Failed to save program: \(error.localizedDescription)")
        }
    }

    private func updateExistingProgram(_ existing: Program) {
        let oldDays = Array(existing.trainingDays)
        for day in oldDays {
            for ex in day.exercises {
                modelContext.delete(ex)
            }
            modelContext.delete(day)
        }
        existing.trainingDays.removeAll()
        existing.name = programName
        existing.programDescription = programDescription.isEmpty ? nil : programDescription
        for dayEdit in trainingDays {
            let day = TrainingDay(id: dayEdit.id, name: dayEdit.name)
            for exEdit in dayEdit.exercises {
                let exercise = ExerciseTemplate(
                    id: exEdit.id,
                    name: exEdit.name,
                    targetSets: exEdit.targetSets,
                    targetRepsMin: exEdit.targetRepsMin,
                    targetRepsMax: exEdit.targetRepsMax,
                    notes: exEdit.notes.isEmpty ? nil : exEdit.notes
                )
                day.exercises.append(exercise)
                modelContext.insert(exercise)
            }
            existing.trainingDays.append(day)
            modelContext.insert(day)
        }
    }

    private func createNewProgram() {
        let program = Program(
            name: programName,
            programDescription: programDescription.isEmpty ? nil : programDescription
        )
        for dayEdit in trainingDays {
            let day = TrainingDay(id: dayEdit.id, name: dayEdit.name)
            for exEdit in dayEdit.exercises {
                let exercise = ExerciseTemplate(
                    id: exEdit.id,
                    name: exEdit.name,
                    targetSets: exEdit.targetSets,
                    targetRepsMin: exEdit.targetRepsMin,
                    targetRepsMax: exEdit.targetRepsMax,
                    notes: exEdit.notes.isEmpty ? nil : exEdit.notes
                )
                day.exercises.append(exercise)
                modelContext.insert(exercise)
            }
            program.trainingDays.append(day)
            modelContext.insert(day)
        }
        modelContext.insert(program)
    }
}

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "AddEditProgram")
