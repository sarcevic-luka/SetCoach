import SwiftUI
import SwiftData

struct HistoryScreen: View {
    @Query(sort: \WorkoutSession.date, order: .reverse)
    private var sessions: [WorkoutSession]

    @State private var viewModel: HistoryViewModel?

    var body: some View {
        Group {
            if let viewModel {
                historyContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            if viewModel == nil {
                let vm = HistoryViewModel()
                vm.updateSessions(sessions)
                viewModel = vm
            }
        }
        .onChange(of: sessions) { _, newSessions in
            viewModel?.updateSessions(newSessions)
        }
    }

    @ViewBuilder
    private func historyContent(viewModel: HistoryViewModel) -> some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    headerSection(viewModel: viewModel)
                    if viewModel.isEmpty {
                        emptyState
                    } else {
                        sessionsList(viewModel: viewModel)
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

    private func headerSection(viewModel: HistoryViewModel) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Training History")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Theme.foreground)
            Text(String(format: String(localized: "%d completed workouts"), viewModel.completedCount))
                .font(.system(size: 14))
                .foregroundColor(Theme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.background.opacity(0.95))
    }

    private func sessionsList(viewModel: HistoryViewModel) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.completedSessions) { session in
                    SessionCard(session: session)
                }
            }
            .padding()
            .padding(.bottom, 96)
        }
    }

    private var emptyState: some View {
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
    }
}

#Preview {
    HistoryScreen()
        .modelContainer(for: [WorkoutSession.self, WorkoutExercise.self, ExerciseSet.self], inMemory: true)
}
