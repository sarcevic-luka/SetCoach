import SwiftUI
import SwiftData

struct ManualWorkoutEntryScreen: View {
    @Environment(\.dependencies) private var dependencies
    @Environment(\.dismiss) private var dismiss

    let program: Program
    let trainingDay: TrainingDay

    @State private var viewModel: ManualWorkoutEntryViewModel?

    var body: some View {
        Group {
            if let viewModel {
                workoutEntryContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(viewModel?.navigationTitle ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "Cancel")) { dismiss() }
                    .foregroundColor(Theme.primary)
            }
            ToolbarItem(placement: .confirmationAction) {
                if let vm = viewModel {
                    Button(String(localized: "Save")) { vm.saveWorkout() }
                        .disabled(!vm.isValid)
                        .fontWeight(.semibold)
                }
            }
        }
        .onAppear { initializeViewModel() }
    }

    @ViewBuilder
    private func workoutEntryContent(viewModel: ManualWorkoutEntryViewModel) -> some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            Form {
                Section(String(localized: "Workout Details")) {
                    LabeledContent(String(localized: "Program"), value: program.name)
                    LabeledContent(String(localized: "Training Day"), value: trainingDay.name)
                    DatePicker(
                        String(localized: "Date"),
                        selection: Binding(get: { viewModel.selectedDate }, set: { viewModel.selectedDate = $0 }),
                        displayedComponents: [.date]
                    )
                    TextField(String(localized: "Duration (minutes)"), text: Binding(
                        get: { viewModel.duration },
                        set: { viewModel.duration = $0 }
                    ))
                    .keyboardType(.numberPad)
                }
                Section(String(localized: "Exercises")) {
                    ForEach(viewModel.workoutSession.exercises.indices, id: \.self) { index in
                        NavigationLink {
                            ManualExerciseEntryView(exercise: viewModel.binding(forExerciseAt: index))
                        } label: {
                            ManualExerciseRowView(exercise: viewModel.workoutSession.exercises[index])
                        }
                    }
                }
                Section(String(localized: "Body Metrics (Optional)")) {
                    TextField(String(localized: "Body Weight (kg)"), text: Binding(
                        get: { viewModel.bodyWeight },
                        set: { viewModel.bodyWeight = $0 }
                    ))
                    .keyboardType(.decimalPad)
                    TextField(String(localized: "Waist Circumference (cm)"), text: Binding(
                        get: { viewModel.waistCircumference },
                        set: { viewModel.waistCircumference = $0 }
                    ))
                    .keyboardType(.decimalPad)
                }
                Section {
                    HStack {
                        Text(String(localized: "Completed Sets"))
                        Spacer()
                        Text("\(viewModel.completedSets) / \(viewModel.totalSets)")
                            .foregroundColor(viewModel.isValid ? Theme.primary : Theme.muted)
                            .fontWeight(.semibold)
                    }
                    if !viewModel.isValid {
                        Text(String(localized: "Complete at least one set to save workout"))
                            .font(.caption)
                            .foregroundColor(Theme.destructive.opacity(0.9))
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }

    private func initializeViewModel() {
        guard viewModel == nil, let dependencies else { return }
        let lastSession = try? dependencies.makeGetLastWorkoutSessionUseCase().execute(for: trainingDay.id)
        let session = dependencies.makeCreateManualWorkoutSessionUseCase().execute(
            from: program,
            trainingDay: trainingDay,
            date: Date(),
            lastSession: lastSession
        )
        viewModel = ManualWorkoutEntryViewModel(
            workoutSession: session,
            saveWorkoutSessionUseCase: dependencies.makeSaveWorkoutSessionUseCase(),
            determineProgressUseCase: dependencies.makeDetermineProgressDirectionUseCase(),
            onFinish: { dismiss() }
        )
    }
}

private struct ManualExerciseRowView: View {
    let exercise: WorkoutExercise

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(exercise.name)
                .font(.headline)
                .foregroundColor(Theme.foreground)
            Text(String(format: String(localized: "%d / %d sets completed"), exercise.sets.filter(\.completed).count, exercise.sets.count))
                .font(.caption)
                .foregroundColor(exercise.sets.contains(where: \.completed) ? Theme.primary : Theme.muted)
        }
    }
}

private struct ManualExerciseEntryView: View {
    @Binding var exercise: WorkoutExercise

    var body: some View {
        Form {
            Section {
                Text(exercise.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.foreground)
                if let notes = exercise.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(Theme.muted)
                }
            }
            Section(String(localized: "Sets")) {
                ForEach(exercise.sets.indices, id: \.self) { index in
                    ManualSetRow(setBinding: Binding(
                        get: { exercise.sets[index] },
                        set: { newSet in
                            var updated = exercise
                            if updated.sets.indices.contains(index) {
                                updated.sets[index] = newSet
                                exercise = updated
                            }
                        }
                    ))
                }
            }
        }
        .navigationTitle(String(localized: "Enter Sets"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ManualSetRow: View {
    @Binding var setBinding: ExerciseSet
    @FocusState private var focusedField: Field?

    enum Field { case weight, reps }

    var body: some View {
        HStack(spacing: 16) {
            Text("\(setBinding.setNumber)")
                .font(.headline)
                .foregroundColor(Theme.muted)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: "Weight"))
                    .font(.caption2)
                    .foregroundColor(Theme.muted)
                TextField("0", value: Binding(
                    get: { setBinding.weight },
                    set: { setBinding.weight = $0 }
                ), format: .number)
                .keyboardType(.decimalPad)
                .focused($focusedField, equals: .weight)
                .textFieldStyle(.roundedBorder)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: "Reps"))
                    .font(.caption2)
                    .foregroundColor(Theme.muted)
                TextField("0", value: Binding(
                    get: { setBinding.reps },
                    set: { setBinding.reps = $0 }
                ), format: .number)
                .keyboardType(.numberPad)
                .focused($focusedField, equals: .reps)
                .textFieldStyle(.roundedBorder)
            }
            Button(action: {
                var updated = setBinding
                updated.completed.toggle()
                setBinding = updated
            }) {
                Image(systemName: setBinding.completed ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(setBinding.completed ? Theme.primary : Theme.muted)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        ManualWorkoutEntryScreen(
            program: Program(name: "Push Pull Legs", programDescription: "3-day split"),
            trainingDay: TrainingDay(
                name: "Push Day",
                exercises: [
                    ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8)
                ]
            )
        )
    }
}
