import SwiftUI
import SwiftData

struct AddEditProgramScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let editProgram: Program?

    @State private var viewModel: AddEditProgramViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    formContent(viewModel: viewModel)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle(viewModel?.navigationTitle ?? "Program")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(String(localized: "Cancel")) {
                        dismiss()
                    }
                    .foregroundColor(Theme.primary)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                let vm = AddEditProgramViewModel(
                    editProgram: editProgram,
                    modelContext: modelContext,
                    onFinish: { dismiss() }
                )
                vm.loadProgramData()
                viewModel = vm
            }
        }
    }

    @ViewBuilder
    private func formContent(viewModel: AddEditProgramViewModel) -> some View {
        ZStack {
                Theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        programFieldsSection(viewModel: viewModel)
                        trainingDaysSection(viewModel: viewModel)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 80)
                }
                VStack {
                    Spacer()
                    PrimaryButton(viewModel.saveButtonTitle) {
                        viewModel.saveProgram()
                    }
                    .disabled(!viewModel.isValid)
                    .opacity(viewModel.isValid ? 1.0 : 0.5)
                    .padding()
                    .background(Theme.background.opacity(0.95))
                }
            }
    }

    private func programFieldsSection(viewModel: AddEditProgramViewModel) -> some View {
        CardView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Program Name")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.muted)
                    TextField("e.g., Push Pull Legs", text: Binding(
                        get: { viewModel.programName },
                        set: { viewModel.programName = $0 }
                    ))
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
                    TextField("e.g., 3-day split for strength", text: Binding(
                        get: { viewModel.programDescription },
                        set: { viewModel.programDescription = $0 }
                    ))
                    .font(.system(size: 16))
                    .foregroundColor(Theme.foreground)
                    .padding(12)
                    .background(Theme.secondary)
                    .cornerRadius(8)
                }
            }
        }
    }

    private func trainingDaysSection(viewModel: AddEditProgramViewModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TRAINING DAYS")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.muted)
            ForEach(viewModel.trainingDays.indices, id: \.self) { index in
                let dayId = viewModel.trainingDays[index].id
                TrainingDayEditor(
                    trainingDay: viewModel.binding(forTrainingDayAt: index),
                    onDelete: { viewModel.removeTrainingDay(id: dayId) }
                )
                .frame(maxWidth: .infinity)
            }
            Button(action: { viewModel.addTrainingDay() }) {
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
