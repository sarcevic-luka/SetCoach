import Foundation
import SwiftUI
import os

@MainActor
@Observable
final class AddEditProgramViewModel {
    var programName = ""
    var programDescription = ""
    var imageIdentifier: String?
    var customImageData: Data?
    var trainingDays: [TrainingDayEdit] = []

    private let editProgram: Program?
    private let saveProgramUseCase: SaveProgramUseCase
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
        saveProgramUseCase: SaveProgramUseCase,
        onFinish: @escaping () -> Void
    ) {
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
        Binding(
            get: { self.trainingDays[index] },
            set: { self.trainingDays[index] = $0 }
        )
    }

    func saveProgram() {
        do {
            let program = buildProgramFromForm()
            try saveProgramUseCase.execute(program)
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
            name: programName,
            programDescription: programDescription.isEmpty ? nil : programDescription,
            imageIdentifier: imageIdentifier,
            customImageData: customImageData,
            trainingDays: [],
            createdAt: createdAt
        )
        for dayEdit in trainingDays {
            let domainDay = TrainingDay(
                id: dayEdit.id,
                name: dayEdit.name,
                exercises: dayEdit.exercises.map { exEdit in
                    ExerciseTemplate(
                        id: exEdit.id,
                        name: exEdit.name,
                        targetSets: exEdit.targetSets,
                        targetRepsMin: exEdit.targetRepsMin,
                        targetRepsMax: exEdit.targetRepsMax,
                        notes: exEdit.notes.isEmpty ? nil : exEdit.notes
                    )
                }
            )
            program.trainingDays.append(domainDay)
        }
        return program
    }
}

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "AddEditProgram")
