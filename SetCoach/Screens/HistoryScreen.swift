import SwiftUI
import SwiftData

struct HistoryScreen: View {
    @Query(sort: \WorkoutSession.date, order: .reverse)
    private var sessions: [WorkoutSession]

    private var completedSessions: [WorkoutSession] {
        sessions.filter(\.completed)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Training History")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.foreground)
                        Text(String(format: String(localized: "%d completed workouts"), completedSessions.count))
                            .font(.system(size: 14))
                            .foregroundColor(Theme.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.background.opacity(0.95))

                    if completedSessions.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "clock")
                                .font(.system(size: 60))
                                .foregroundColor(Theme.primary)
                            Text("No history yet")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Theme.foreground)
                            Text("Complete a workout to see it here")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.muted)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(completedSessions) { session in
                                    SessionCard(session: session)
                                }
                            }
                            .padding()
                            .padding(.bottom, 96)
                        }
                    }
                }
            }
            .navigationDestination(for: WorkoutSession.self) { session in
                SessionDetailScreen(session: session)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        BodyMetricsChartScreen()
                    } label: {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(Theme.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryScreen()
        .modelContainer(for: [WorkoutSession.self, WorkoutExercise.self, ExerciseSet.self], inMemory: true)
}
