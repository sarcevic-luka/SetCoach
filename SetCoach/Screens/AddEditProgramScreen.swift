import SwiftUI
import SwiftData
import os

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "AddEditProgram")

struct AddEditProgramScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let editProgram: Program?
    @State private var programName = ""
    @State private var programDescription = ""
    @State private var trainingDays: [TrainingDayEdit] = []

    private var isValid: Bool {
        !programName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !trainingDays.isEmpty &&
        trainingDays.allSatisfy { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        CardView {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Program Name")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.muted)
                                    TextField("e.g., Push Pull Legs", text: $programName)
                                        .font(.system(size: 16))
                                        .foregroundColor(Theme.foreground)
                                        .padding(12)
                                        .background(Theme.secondary)
                                        .cornerRadius(8)
                                }
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Description (Optional)")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Theme.muted)
                                    TextField("e.g., 3-day split for strength", text: $programDescription)
                                        .font(.system(size: 16))
                                        .foregroundColor(Theme.foreground)
                                        .padding(12)
                                        .background(Theme.secondary)
                                        .cornerRadius(8)
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("TRAINING DAYS")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Theme.muted)
                            ForEach(trainingDays.indices, id: \.self) { index in
                                TrainingDayEditor(
                                    trainingDay: $trainingDays[index],
                                    onDelete: { trainingDays.removeAll { $0.id == trainingDays[index].id } }
                                )
                            }
                            Button(action: addTrainingDay) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Training Day")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .foregroundColor(Theme.primary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Theme.primary.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                        .stroke(Theme.primary, style: StrokeStyle(lineWidth: 2, dash: [5]))
                                )
                                .cornerRadius(Theme.cornerRadius)
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                }
                VStack {
                    Spacer()
                    PrimaryButton(editProgram == nil ? "Create Program" : "Save Changes") {
                        saveProgram()
                    }
                    .disabled(!isValid)
                    .opacity(isValid ? 1.0 : 0.5)
                    .padding()
                    .background(Theme.background.opacity(0.95))
                }
            }
            .navigationTitle(editProgram == nil ? "New Program" : "Edit Program")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                    .foregroundColor(Theme.primary)
                }
            }
            .onAppear {
                loadProgramData()
            }
        }
    }

    private func loadProgramData() {
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

    private func addTrainingDay() {
        trainingDays.append(TrainingDayEdit(
            id: UUID().uuidString,
            name: "",
            exercises: [ExerciseEdit(id: UUID().uuidString)]
        ))
    }

    private func saveProgram() {
        if let existing = editProgram {
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
        } else {
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
        do {
            try modelContext.save()
            dismiss()
        } catch {
            logger.error("Failed to save program: \(error.localizedDescription)")
        }
    }
}

struct TrainingDayEdit: Identifiable {
    let id: String
    var name: String
    var exercises: [ExerciseEdit]
}

struct ExerciseEdit: Identifiable {
    let id: String
    var name: String = ""
    var targetSets: Int = 3
    var targetRepsMin: Int = 8
    var targetRepsMax: Int = 12
    var notes: String = ""
}

#Preview("New") {
    AddEditProgramScreen(editProgram: nil)
        .modelContainer(for: [Program.self, TrainingDay.self, ExerciseTemplate.self], inMemory: true)
}
