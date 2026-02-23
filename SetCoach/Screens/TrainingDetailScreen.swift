import SwiftUI
import SwiftData

struct TrainingDetailScreen: View {
    @Environment(\.dependencies) private var dependencies
    let program: Program
    let trainingDay: TrainingDay
    @State private var viewModel: TrainingDetailViewModel?

    var body: some View {
        Group {
            if let viewModel {
                trainingContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(trainingDay.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard let dependencies, viewModel == nil else { return }
            let vm = TrainingDetailViewModel(
                program: program,
                trainingDay: trainingDay,
                loadWorkoutSessionsUseCase: dependencies.makeLoadWorkoutSessionsUseCase()
            )
            vm.loadSessions()
            viewModel = vm
        }
    }

    @ViewBuilder
    private func trainingContent(viewModel: TrainingDetailViewModel) -> some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                if let last = viewModel.lastSession {
                    HStack(spacing: 16) {
                        Label(viewModel.formatDate(last.date), systemImage: "calendar")
                        Label(String(format: String(localized: "%d min"), last.duration), systemImage: "clock")
                        Spacer()
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.muted)
                    .padding()
                    .background(Theme.card)
                }

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.trainingDay.exercises) { exercise in
                            ExerciseCard(
                                exercise: exercise,
                                lastSessionExercise: viewModel.lastSession?.exercises.first { $0.exerciseTemplateId == exercise.id }
                            )
                        }
                    }
                    .padding()
                    .padding(.bottom, 80)
                }

                VStack {
                    NavigationLink(value: AppRoute.activeWorkout(viewModel.program, viewModel.trainingDay)) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Workout")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(Theme.primaryForeground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Theme.primary)
                        .cornerRadius(Theme.cornerRadius)
                    }
                    .padding()
                }
                .background(Theme.background.opacity(0.95))
            }
        }
    }
}

#Preview {
    let program = Program(name: "PPL", programDescription: nil, trainingDays: [])
    let day = TrainingDay(name: "Push Day", exercises: [
        ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, notes: "Pause at bottom")
    ])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let schema = Schema([
        ProgramModel.self, TrainingDayModel.self, ExerciseTemplateModel.self,
        WorkoutSessionModel.self, WorkoutExerciseModel.self, ExerciseSetModel.self
    ])
    let container = try! ModelContainer(for: schema, configurations: [config])
    let ctx = ModelContext(container)
    let deps = Dependencies(context: ctx)
    return NavigationStack {
        TrainingDetailScreen(program: program, trainingDay: day)
            .environment(\.dependencies, deps)
    }
    .modelContainer(container)
}
