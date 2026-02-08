import SwiftUI
import SwiftData

struct TrainingDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var sessions: [WorkoutSession]
    let program: Program
    let trainingDay: TrainingDay

    private var lastSession: WorkoutSession? {
        sessions
            .filter { $0.trainingDayId == trainingDay.id && $0.completed }
            .sorted { $0.date > $1.date }
            .first
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                if let last = lastSession {
                    HStack(spacing: 16) {
                        Label(formatDate(last.date), systemImage: "calendar")
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
                        ForEach(trainingDay.exercises) { exercise in
                            ExerciseCard(
                                exercise: exercise,
                                lastSessionExercise: lastSession?.exercises.first { $0.exerciseTemplateId == exercise.id }
                            )
                        }
                    }
                    .padding()
                    .padding(.bottom, 80)
                }

                VStack {
                    NavigationLink(value: AppRoute.activeWorkout(program, trainingDay)) {
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
        .navigationTitle(trainingDay.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}

#Preview {
    let program = Program(name: "PPL", programDescription: nil, trainingDays: [])
    let day = TrainingDay(name: "Push Day", exercises: [
        ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, notes: "Pause at bottom")
    ])
    return NavigationStack {
        TrainingDetailScreen(program: program, trainingDay: day)
    }
    .modelContainer(for: [Program.self, TrainingDay.self, ExerciseTemplate.self, WorkoutSession.self, WorkoutExercise.self, ExerciseSet.self], inMemory: true)
}
