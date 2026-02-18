import SwiftUI
import SwiftData
import Charts

struct ExerciseHistoryScreen: View {
    @Query private var allSessions: [WorkoutSession]
    let exerciseName: String

    @State private var viewModel: ExerciseHistoryViewModel?
    @State private var showAllSessions = false

    var body: some View {
        Group {
            if let viewModel {
                historyContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(exerciseName)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if viewModel == nil {
                let vm = ExerciseHistoryViewModel(exerciseName: exerciseName)
                vm.updateSessions(allSessions)
                viewModel = vm
            }
        }
        .onChange(of: allSessions) { _, newSessions in
            viewModel?.updateSessions(newSessions)
        }
    }

    @ViewBuilder
    private func historyContent(viewModel: ExerciseHistoryViewModel) -> some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    if let pb = viewModel.personalBest {
                        personalBestCard(weight: pb.weight, reps: pb.reps)
                    }
                    if viewModel.hasSessions {
                        volumeChartCard(viewModel: viewModel)
                        maxWeightChartCard(viewModel: viewModel)
                    }
                    sessionsSection(viewModel: viewModel)
                }
                .padding(.vertical)
            }
        }
    }

    private func personalBestCard(weight: Double, reps: Int) -> some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text(String(localized: "Personal Best"))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.muted)
                    .textCase(.uppercase)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(String(format: "%.1f", weight))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Theme.primary)
                    Text("kg")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Theme.primary)
                    Text("×")
                        .font(.system(size: 24))
                        .foregroundColor(Theme.muted)
                        .padding(.horizontal, 4)
                    Text("\(reps)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Theme.primary)
                    Text(String(localized: "reps"))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Theme.primary)
                }
            }
        }
    }

    private func volumeChartCard(viewModel: ExerciseHistoryViewModel) -> some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(localized: "Volume Over Time"))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.muted)
                    .textCase(.uppercase)
                Chart {
                    ForEach(Array(viewModel.volumeChartData.enumerated()), id: \.element.id) { index, item in
                        LineMark(
                            x: .value(String(localized: "Session"), index),
                            y: .value(String(localized: "Volume"), item.volume)
                        )
                        .foregroundStyle(Theme.primary)
                        .interpolationMethod(.catmullRom)
                        PointMark(
                            x: .value(String(localized: "Session"), index),
                            y: .value(String(localized: "Volume"), item.volume)
                        )
                        .foregroundStyle(Theme.primary)
                    }
                }
                .frame(height: 180)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel()
                            .foregroundStyle(Theme.muted)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                            .foregroundStyle(Theme.border)
                        AxisValueLabel()
                            .foregroundStyle(Theme.muted)
                    }
                }
                HStack(spacing: 20) {
                    Label {
                        Text(String(localized: "Total Volume (kg × reps)"))
                            .font(.system(size: 12))
                            .foregroundColor(Theme.muted)
                    } icon: {
                        Circle()
                            .fill(Theme.primary)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
    }

    private func maxWeightChartCard(viewModel: ExerciseHistoryViewModel) -> some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(localized: "Max Weight Per Session"))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.muted)
                    .textCase(.uppercase)
                Chart {
                    ForEach(Array(viewModel.maxWeightChartData.enumerated()), id: \.element.id) { index, item in
                        BarMark(
                            x: .value(String(localized: "Session"), index),
                            y: .value(String(localized: "Weight"), item.weight)
                        )
                        .foregroundStyle(Theme.blue)
                        .cornerRadius(4)
                    }
                }
                .frame(height: 180)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel()
                            .foregroundStyle(Theme.muted)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                            .foregroundStyle(Theme.border)
                        AxisValueLabel {
                            if let weight = value.as(Double.self) {
                                Text(String(format: "%.0f kg", weight))
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.muted)
                            }
                        }
                    }
                }
                HStack(spacing: 20) {
                    Label {
                        Text(String(localized: "Heaviest Set"))
                            .font(.system(size: 12))
                            .foregroundColor(Theme.muted)
                    } icon: {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Theme.blue)
                            .frame(width: 12, height: 8)
                    }
                }
            }
        }
    }

    private func sessionsSection(viewModel: ExerciseHistoryViewModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(showAllSessions ? "ALL SESSIONS" : "LAST 3 SESSIONS")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.muted)
                Spacer()
                Text(String(format: String(localized: "%d total"), viewModel.totalCount))
                    .font(.system(size: 12))
                    .foregroundColor(Theme.muted)
            }
            .padding(.horizontal)

            let displayed = viewModel.displayedSessions(showAll: showAllSessions)
            if displayed.isEmpty {
                emptyState
            } else {
                ForEach(displayed, id: \.session.id) { item in
                    ExerciseHistoryCard(
                        session: item.session,
                        exercise: item.exercise,
                        isPersonalBest: viewModel.isPersonalBestSession(item.exercise)
                    )
                }
                .padding(.horizontal)

                if viewModel.totalCount > 3 {
                    Button(action: { showAllSessions.toggle() }) {
                        HStack {
                            Image(systemName: showAllSessions ? "chevron.up" : "chevron.down")
                            Text(showAllSessions ? String(localized: "Show Less") : String(format: String(localized: "Show All (%d)"), viewModel.totalCount))
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

    private var emptyState: some View {
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
    }
}

#Preview {
    NavigationStack {
        ExerciseHistoryScreen(exerciseName: "Bench Press")
            .modelContainer(for: [WorkoutSession.self, WorkoutExercise.self, ExerciseSet.self], inMemory: true)
    }
}
