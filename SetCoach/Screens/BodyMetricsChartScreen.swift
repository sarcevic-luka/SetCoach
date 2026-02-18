import SwiftUI
import SwiftData
import Charts

struct BodyMetricsChartScreen: View {
    @Query(sort: \WorkoutSession.date) private var sessions: [WorkoutSession]
    @State private var viewModel: BodyMetricsChartViewModel?

    var body: some View {
        Group {
            if let viewModel {
                chartContent(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(String(localized: "Body Metrics"))
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if viewModel == nil {
                let vm = BodyMetricsChartViewModel()
                vm.updateSessions(sessions)
                viewModel = vm
            }
        }
        .onChange(of: sessions) { _, newSessions in
            viewModel?.updateSessions(newSessions)
        }
    }

    @ViewBuilder
    private func chartContent(viewModel: BodyMetricsChartViewModel) -> some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.hasWeightData {
                        weightChartCard(viewModel: viewModel)
                    }
                    if viewModel.hasWaistData {
                        waistChartCard(viewModel: viewModel)
                    }
                    if viewModel.isEmpty {
                        emptyState
                    }
                }
                .padding()
            }
        }
    }

    private func weightChartCard(viewModel: BodyMetricsChartViewModel) -> some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(localized: "Body Weight Trend"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.foreground)
                Chart {
                    ForEach(Array(viewModel.sessionsWithWeight.enumerated()), id: \.offset) { _, item in
                        LineMark(
                            x: .value(String(localized: "Date"), item.date),
                            y: .value(String(localized: "Weight"), item.weight)
                        )
                        .foregroundStyle(Theme.primary)
                        .interpolationMethod(.catmullRom)
                        PointMark(
                            x: .value(String(localized: "Date"), item.date),
                            y: .value(String(localized: "Weight"), item.weight)
                        )
                        .foregroundStyle(Theme.primary)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel(format: .dateTime.month().day())
                            .foregroundStyle(Theme.muted)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                            .foregroundStyle(Theme.border)
                        AxisValueLabel {
                            if let weight = value.as(Double.self) {
                                Text(String(format: "%.1f kg", weight))
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.muted)
                            }
                        }
                    }
                }
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "CURRENT"))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Theme.muted)
                        if let last = viewModel.currentWeight {
                            Text(String(format: "%.1f kg", last))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Theme.foreground)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "CHANGE"))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Theme.muted)
                        if let change = viewModel.weightChange {
                            Text(String(format: "%+.1f kg", change))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(change >= 0 ? Theme.primary : Theme.destructive)
                        }
                    }
                }
            }
        }
    }

    private func waistChartCard(viewModel: BodyMetricsChartViewModel) -> some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text(String(localized: "Waist Circumference Trend"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.foreground)
                Chart {
                    ForEach(Array(viewModel.sessionsWithWaist.enumerated()), id: \.offset) { _, item in
                        LineMark(
                            x: .value(String(localized: "Date"), item.date),
                            y: .value(String(localized: "Waist"), item.waist)
                        )
                        .foregroundStyle(Theme.blue)
                        .interpolationMethod(.catmullRom)
                        PointMark(
                            x: .value(String(localized: "Date"), item.date),
                            y: .value(String(localized: "Waist"), item.waist)
                        )
                        .foregroundStyle(Theme.blue)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel(format: .dateTime.month().day())
                            .foregroundStyle(Theme.muted)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                            .foregroundStyle(Theme.border)
                        AxisValueLabel {
                            if let waist = value.as(Double.self) {
                                Text(String(format: "%.1f cm", waist))
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.muted)
                            }
                        }
                    }
                }
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "CURRENT"))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Theme.muted)
                        if let last = viewModel.currentWaist {
                            Text(String(format: "%.1f cm", last))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Theme.foreground)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "CHANGE"))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Theme.muted)
                        if let change = viewModel.waistChange {
                            Text(String(format: "%+.1f cm", change))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(change <= 0 ? Theme.primary : Theme.destructive)
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(Theme.muted)
            Text(String(localized: "No metrics data yet"))
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.foreground)
            Text(String(localized: "Enter body weight and waist during workouts to track trends"))
                .font(.system(size: 14))
                .foregroundColor(Theme.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
}

#Preview {
    NavigationStack {
        BodyMetricsChartScreen()
            .modelContainer(for: [WorkoutSession.self], inMemory: true)
    }
}
