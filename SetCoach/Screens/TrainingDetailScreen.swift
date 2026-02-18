import SwiftUI
import SwiftData

struct TrainingDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: TrainingDetailViewModel

    init(program: Program, trainingDay: TrainingDay) {
        _viewModel = StateObject(wrappedValue: TrainingDetailViewModel(program: program, trainingDay: trainingDay))
    }

    var body: some View {
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
        .navigationTitle(viewModel.trainingDay.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.configure(with: modelContext)
        }
    }
}

#Preview {
    let program = Program(name: "PPL", programDescription: nil, trainingDays: [])
    let day = TrainingDay(name: "Push Day", exercises: [
        ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, notes: "Pause at bottom")
    ])
    let container = try! ModelContainer(for: Program.self, TrainingDay.self, ExerciseTemplate.self, WorkoutSession.self, WorkoutExercise.self, ExerciseSet.self)
    NavigationStack {
        TrainingDetailScreen(program: program, trainingDay: day)
    }
    .modelContainer(container)
}
