import SwiftUI
import SwiftData

struct ExerciseHistoryScreen: View {
    @Query private var allSessions: [WorkoutSession]
    let exerciseName: String
    @State private var showAllSessions = false

    private var exerciseSessions: [(session: WorkoutSession, exercise: WorkoutExercise)] {
        allSessions
            .filter(\.completed)
            .compactMap { session in
                if let exercise = session.exercises.first(where: { $0.name == exerciseName }) {
                    return (session, exercise)
                }
                return nil
            }
            .sorted { $0.session.date > $1.session.date }
    }

    private var displayedSessions: [(session: WorkoutSession, exercise: WorkoutExercise)] {
        showAllSessions ? exerciseSessions : Array(exerciseSessions.prefix(3))
    }

    private var personalBest: (weight: Double, reps: Int)? {
        var best: (weight: Double, reps: Int)?
        for (_, exercise) in exerciseSessions {
            for set in exercise.sets {
                if let current = best {
                    if set.weight > current.weight ||
                        (set.weight == current.weight && set.reps > current.reps) {
                        best = (set.weight, set.reps)
                    }
                } else {
                    best = (set.weight, set.reps)
                }
            }
        }
        return best
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    if let pb = personalBest {
                        CardView {
                            VStack(alignment: .leading, spacing: 12) {
                                Text(String(localized: "Personal Best"))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Theme.muted)
                                    .textCase(.uppercase)
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    Text(String(format: "%.1f", pb.weight))
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(Theme.primary)
                                    Text("kg")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Theme.primary)
                                    Text("×")
                                        .font(.system(size: 24))
                                        .foregroundColor(Theme.muted)
                                        .padding(.horizontal, 4)
                                    Text("\(pb.reps)")
                                        .font(.system(size: 48, weight: .bold))
                                        .foregroundColor(Theme.primary)
                                    Text(String(localized: "reps"))
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(Theme.primary)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(showAllSessions ? "ALL SESSIONS" : "LAST 3 SESSIONS")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Theme.muted)
                            Spacer()
                            Text(String(format: String(localized: "%d total"), exerciseSessions.count))
                                .font(.system(size: 12))
                                .foregroundColor(Theme.muted)
                        }
                        .padding(.horizontal)

                        if displayedSessions.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "chart.bar")
                                    .font(.system(size: 48))
                                    .foregroundColor(Theme.muted)
                                Text(String(localized: "No history yet"))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Theme.foreground)
                                Text(String(localized: "Complete a workout with this exercise to see history"))
                                    .font(.system(size: 14))
                                    .foregroundColor(Theme.muted)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            ForEach(displayedSessions, id: \.session.id) { item in
                                ExerciseHistoryCard(
                                    session: item.session,
                                    exercise: item.exercise,
                                    isPersonalBest: isPersonalBestSession(item.exercise)
                                )
                            }
                            .padding(.horizontal)

                            if exerciseSessions.count > 3 {
                                Button(action: { showAllSessions.toggle() }) {
                                    HStack {
                                        Image(systemName: showAllSessions ? "chevron.up" : "chevron.down")
                                        Text(showAllSessions ? String(localized: "Show Less") : String(format: String(localized: "Show All (%d)"), exerciseSessions.count))
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .foregroundColor(Theme.primary)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(Theme.primary.opacity(0.1))
                                    .cornerRadius(Theme.cornerRadius)
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle(exerciseName)
        .navigationBarTitleDisplayMode(.large)
    }

    private func isPersonalBestSession(_ exercise: WorkoutExercise) -> Bool {
        guard let pb = personalBest else { return false }
        return exercise.sets.contains { $0.weight == pb.weight && $0.reps == pb.reps }
    }
}

#Preview {
    NavigationStack {
        ExerciseHistoryScreen(exerciseName: "Bench Press")
            .modelContainer(for: [WorkoutSession.self, WorkoutExercise.self, ExerciseSet.self], inMemory: true)
    }
}
