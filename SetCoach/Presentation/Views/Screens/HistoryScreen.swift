import SwiftUI
import SwiftData

private struct WorkoutSelection: Identifiable {
    let id = UUID()
    let program: Program
    let trainingDay: TrainingDay
}

struct HistoryScreen: View {
    @Environment(\.dependencies) private var dependencies

    @State private var viewModel: HistoryViewModel?
    @State private var showProgramSelector = false
    @State private var selectedProgram: Program?
    @State private var selectedTrainingDay: TrainingDay?

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
            guard let dependencies else { return }
            if viewModel == nil {
                let vm = HistoryViewModel(loadWorkoutSessionsUseCase: dependencies.makeLoadWorkoutSessionsUseCase())
                vm.loadSessions()
                viewModel = vm
            } else {
                viewModel?.loadSessions()
            }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showProgramSelector = true }) {
                        Label(String(localized: "Add Workout"), systemImage: "plus.circle.fill")
                            .foregroundColor(Theme.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        BodyMetricsChartScreen()
                    } label: {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundColor(Theme.primary)
                    }
                }
            }
            .sheet(isPresented: $showProgramSelector) {
                ProgramSelectorSheet { program, trainingDay in
                    selectedProgram = program
                    selectedTrainingDay = trainingDay
                }
            }
            .sheet(item: Binding(
                get: {
                    guard let p = selectedProgram, let d = selectedTrainingDay else { return nil }
                    return WorkoutSelection(program: p, trainingDay: d)
                },
                set: { (_: WorkoutSelection?) in
                    selectedProgram = nil
                    selectedTrainingDay = nil
                    viewModel.loadSessions()
                }
            )) { selection in
                NavigationStack {
                    ManualWorkoutEntryScreen(
                        program: selection.program,
                        trainingDay: selection.trainingDay
                    )
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
            Text(String(localized: "No history yet"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.foreground)
            Text(String(localized: "Complete a workout or add one manually"))
                .font(.system(size: 14))
                .foregroundColor(Theme.muted)
            Button(action: { showProgramSelector = true }) {
                Label(String(localized: "Add Workout"), systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    HistoryScreen()
        .modelContainer(for: [WorkoutSessionModel.self, WorkoutExerciseModel.self, ExerciseSetModel.self], inMemory: true)
}
