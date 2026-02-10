import SwiftUI
import SwiftData
import Charts

struct BodyMetricsChartScreen: View {
    @Query(sort: \WorkoutSession.date) private var sessions: [WorkoutSession]

    private var sessionsWithWeight: [(date: Date, weight: Double)] {
        sessions
            .filter { $0.completed && $0.bodyWeight != nil }
            .map { ($0.date, $0.bodyWeight!) }
    }

    private var sessionsWithWaist: [(date: Date, waist: Double)] {
        sessions
            .filter { $0.completed && $0.waistCircumference != nil }
            .map { ($0.date, $0.waistCircumference!) }
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    if !sessionsWithWeight.isEmpty {
                        CardView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(String(localized: "Body Weight Trend"))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.foreground)
                                Chart {
                                    ForEach(Array(sessionsWithWeight.enumerated()), id: \.offset) { _, item in
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
                                        if let last = sessionsWithWeight.last?.weight {
                                            Text(String(format: "%.1f kg", last))
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(Theme.foreground)
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(String(localized: "CHANGE"))
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(Theme.muted)
                                        if let first = sessionsWithWeight.first?.weight,
                                           let last = sessionsWithWeight.last?.weight {
                                            let change = last - first
                                            Text(String(format: "%+.1f kg", change))
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(change >= 0 ? Theme.primary : Theme.destructive)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if !sessionsWithWaist.isEmpty {
                        CardView {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(String(localized: "Waist Circumference Trend"))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.foreground)
                                Chart {
                                    ForEach(Array(sessionsWithWaist.enumerated()), id: \.offset) { _, item in
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
                                        if let last = sessionsWithWaist.last?.waist {
                                            Text(String(format: "%.1f cm", last))
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(Theme.foreground)
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(String(localized: "CHANGE"))
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(Theme.muted)
                                        if let first = sessionsWithWaist.first?.waist,
                                           let last = sessionsWithWaist.last?.waist {
                                            let change = last - first
                                            Text(String(format: "%+.1f cm", change))
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(change <= 0 ? Theme.primary : Theme.destructive)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if sessionsWithWeight.isEmpty && sessionsWithWaist.isEmpty {
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
                .padding()
            }
        }
        .navigationTitle(String(localized: "Body Metrics"))
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        BodyMetricsChartScreen()
            .modelContainer(for: [WorkoutSession.self], inMemory: true)
    }
}
