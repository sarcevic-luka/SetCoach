import SwiftUI
import SwiftData

struct ActiveWorkoutScreen: View {
    @Environment(\.dependencies) private var dependencies
    @Environment(\.dismiss) private var dismiss
    let program: Program
    let trainingDay: TrainingDay

    @State private var viewModel: ActiveWorkoutViewModel?
    @State private var showMetrics = false
    @State private var expandedExerciseId: String?

    var body: some View {
        Group {
            if let viewModel {
                workoutContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Theme.foreground)
                }
            }
            ToolbarItem(placement: .principal) {
                if let viewModel {
                    VStack(spacing: 2) {
                        Text(viewModel.trainingDayName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.foreground)
                        Text(viewModel.formatElapsedTime())
                            .font(.system(size: 12))
                            .foregroundColor(Theme.muted)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if let viewModel {
                    Button(action: { viewModel.restTimerEnabled.toggle() }) {
                        Image(systemName: viewModel.restTimerEnabled ? "timer.circle.fill" : "timer.circle")
                            .foregroundColor(viewModel.restTimerEnabled ? Theme.primary : Theme.muted)
                    }
                }
            }
        }
        .onAppear {
            guard let dependencies, viewModel == nil else { return }
            let sessions = (try? dependencies.makeLoadWorkoutSessionsUseCase().execute(sortByDateDescending: true)) ?? []
            let lastSession = sessions
                .filter { $0.trainingDayId == trainingDay.id && $0.completed }
                .sorted { $0.date > $1.date }
                .first
            let vm = ActiveWorkoutViewModel(
                program: program,
                trainingDay: trainingDay,
                lastSession: lastSession,
                saveWorkoutSessionUseCase: dependencies.makeSaveWorkoutSessionUseCase(),
                onFinish: { dismiss() }
            )
            vm.start()
            viewModel = vm
        }
        .onDisappear {
            viewModel?.stop()
        }
    }

    @ViewBuilder
    private func workoutContent(viewModel: ActiveWorkoutViewModel) -> some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                headerView(viewModel: viewModel)
                progressBar(viewModel: viewModel)
                restDurationPicker(viewModel: viewModel)
                bodyMetricsSection(viewModel: viewModel)
                exerciseList(viewModel: viewModel)
                finishButton(viewModel: viewModel)
            }
        }
        .overlay {
            if viewModel.showRestTimer {
                RestTimerOverlay(isPresented: Binding(
                    get: { viewModel.showRestTimer },
                    set: { viewModel.showRestTimer = $0 }
                ), duration: viewModel.restDuration)
            }
        }
    }

    private func headerView(viewModel: ActiveWorkoutViewModel) -> some View {
        HStack {
            Text(String(format: String(localized: "%d/%d sets"), viewModel.completedSets, viewModel.totalSets))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Theme.muted)
        }
        .padding()
        .background(Theme.card)
    }

    private func progressBar(viewModel: ActiveWorkoutViewModel) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Theme.secondary)
                    .frame(height: 4)
                Rectangle()
                    .fill(Theme.primary)
                    .frame(width: geometry.size.width * viewModel.progressPercentage, height: 4)
            }
        }
        .frame(height: 4)
    }

    @ViewBuilder
    private func restDurationPicker(viewModel: ActiveWorkoutViewModel) -> some View {
        if viewModel.restTimerEnabled {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ActiveWorkoutViewModel.restDurations, id: \.self) { duration in
                        Button(action: { viewModel.restDuration = duration }) {
                            Text(viewModel.formatRestDuration(duration))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(viewModel.restDuration == duration ? Theme.primaryForeground : Theme.foreground)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(viewModel.restDuration == duration ? Theme.primary : Theme.secondary)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .background(Theme.card)
        }
    }

    private func bodyMetricsSection(viewModel: ActiveWorkoutViewModel) -> some View {
        VStack(spacing: 0) {
            Button(action: { showMetrics.toggle() }) {
                HStack {
                    Text("Body Metrics")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.foreground)
                    Spacer()
                    Image(systemName: showMetrics ? "chevron.up" : "chevron.down")
                        .foregroundColor(Theme.muted)
                }
                .padding()
            }
            if showMetrics {
                VStack(spacing: 16) {
                    HStack {
                        Text("Body Weight (kg)")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.foreground)
                        Spacer()
                        StepperView(value: Binding(
                            get: { viewModel.bodyWeight },
                            set: { viewModel.bodyWeight = $0 }
                        ), step: 0.1, minimum: 0)
                    }
                    HStack {
                        Text("Waist (cm)")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.foreground)
                        Spacer()
                        StepperView(value: Binding(
                            get: { viewModel.waistCircumference },
                            set: { viewModel.waistCircumference = $0 }
                        ), step: 0.5, minimum: 0)
                    }
                }
                .padding()
                .background(Theme.card)
            }
        }
    }

    private func exerciseList(viewModel: ActiveWorkoutViewModel) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.workoutExercises.indices, id: \.self) { index in
                    let exercise = viewModel.workoutExercises[index]
                    ActiveExerciseCard(
                        exercise: viewModel.binding(forExerciseAt: index),
                        isExpanded: expandedExerciseId == exercise.id,
                        onToggleExpand: {
                            expandedExerciseId = expandedExerciseId == exercise.id ? nil : exercise.id
                        },
                        onSetComplete: {
                            if viewModel.restTimerEnabled {
                                viewModel.showRestTimer = true
                            }
                        }
                    )
                }
            }
            .padding()
            .padding(.bottom, 80)
        }
    }

    private func finishButton(viewModel: ActiveWorkoutViewModel) -> some View {
        VStack {
            PrimaryButton("Finish Workout", icon: "checkmark") {
                viewModel.finishWorkout()
            }
            .padding()
        }
        .background(Theme.background.opacity(0.95))
    }
}

#Preview {
    var program = Program(name: "Preview", programDescription: nil, trainingDays: [])
    let day = TrainingDay(name: "Push Day", exercises: [
        ExerciseTemplate(name: "Bench Press", targetSets: 3, targetRepsMin: 8, targetRepsMax: 12),
        ExerciseTemplate(name: "Squat", targetSets: 3, targetRepsMin: 8, targetRepsMax: 10),
    ])
    program.trainingDays = [day]
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema([
        ProgramModel.self, TrainingDayModel.self, ExerciseTemplateModel.self,
        WorkoutSessionModel.self, WorkoutExerciseModel.self, ExerciseSetModel.self
    ])
    let container = try! ModelContainer(for: schema, configurations: [config])
    let ctx = ModelContext(container)
    let deps = Dependencies(context: ctx)
    return NavigationStack {
        ActiveWorkoutScreen(program: program, trainingDay: day)
            .environment(\.dependencies, deps)
    }
    .modelContainer(container)
}
