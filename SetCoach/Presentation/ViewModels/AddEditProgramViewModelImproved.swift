import Foundation
import SwiftUI
import os

/// Alternate AddEditProgram ViewModel with extra validation and debug logging
@MainActor
@Observable
final class AddEditProgramViewModelImproved {
    var programName = ""
    var programDescription = ""
    var imageIdentifier: String?
    var customImageData: Data?
    var trainingDays: [TrainingDayEdit] = []

    private let editProgram: Program?
    private let saveProgramUseCase: SaveProgramUseCase
    private let onFinish: () -> Void

    var isValid: Bool {
        let nameValid = !programName.trimmingCharacters(in: .whitespaces).isEmpty
        let hasTrainingDays = !trainingDays.isEmpty
        let allDaysHaveNames = trainingDays.allSatisfy {
            !$0.name.trimmingCharacters(in: .whitespaces).isEmpty
        }
        #if DEBUG
        logger.debug("Validation: name=\(nameValid), days=\(hasTrainingDays), names=\(allDaysHaveNames)")
        #endif
        return nameValid && hasTrainingDays && allDaysHaveNames
    }

    var validationMessage: String? {
        if programName.trimmingCharacters(in: .whitespaces).isEmpty { return "Program name is required" }
        if trainingDays.isEmpty { return "At least one training day is required" }
        if !trainingDays.allSatisfy({ !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }) {
            return "All training days must have names"
        }
        return nil
    }

    var saveButtonTitle: String { editProgram == nil ? "Create Program" : "Save Changes" }
    var navigationTitle: String { editProgram == nil ? "New Program" : "Edit Program" }

    init(editProgram: Program?, saveProgramUseCase: SaveProgramUseCase, onFinish: @escaping () -> Void) {
        self.editProgram = editProgram
        self.saveProgramUseCase = saveProgramUseCase
        self.onFinish = onFinish
    }

    func loadProgramData() {
        if let program = editProgram {
            programName = program.name
            programDescription = program.programDescription ?? ""
            imageIdentifier = program.imageIdentifier
            customImageData = program.customImageData
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
        Binding(get: { self.trainingDays[index] }, set: { self.trainingDays[index] = $0 })
    }

    func saveProgram() {
        guard isValid else { return }
        do {
            try saveProgramUseCase.execute(buildProgramFromForm())
            onFinish()
        } catch {
            logger.error("Failed to save program: \(error.localizedDescription)")
        }
    }

    private func buildProgramFromForm() -> Program {
        let id = editProgram?.id ?? UUID().uuidString
        let createdAt = editProgram?.createdAt ?? Date()
        var program = Program(
            id: id,
            name: programName.trimmingCharacters(in: .whitespaces),
            programDescription: programDescription.isEmpty ? nil : programDescription,
            imageIdentifier: imageIdentifier,
            customImageData: customImageData,
            trainingDays: [],
            createdAt: createdAt
        )
        for dayEdit in trainingDays {
            program.trainingDays.append(TrainingDay(
                id: dayEdit.id,
                name: dayEdit.name.trimmingCharacters(in: .whitespaces),
                exercises: dayEdit.exercises.map { exEdit in
                    ExerciseTemplate(
                        id: exEdit.id,
                        name: exEdit.name.trimmingCharacters(in: .whitespaces),
                        targetSets: exEdit.targetSets,
                        targetRepsMin: exEdit.targetRepsMin,
                        targetRepsMax: exEdit.targetRepsMax,
                        notes: exEdit.notes.isEmpty ? nil : exEdit.notes
                    )
                }
            ))
        }
        return program
    }
}

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "AddEditProgram")
