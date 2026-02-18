import Foundation
import SwiftData

@MainActor
@Observable
final class BodyMetricsChartViewModel {
    private(set) var sessionsWithWeight: [(date: Date, weight: Double)] = []
    private(set) var sessionsWithWaist: [(date: Date, waist: Double)] = []

    var hasWeightData: Bool {
        !sessionsWithWeight.isEmpty
    }

    var hasWaistData: Bool {
        !sessionsWithWaist.isEmpty
    }

    var isEmpty: Bool {
        !hasWeightData && !hasWaistData
    }

    var currentWeight: Double? {
        sessionsWithWeight.last?.weight
    }

    var weightChange: Double? {
        guard let first = sessionsWithWeight.first?.weight,
              let last = sessionsWithWeight.last?.weight else { return nil }
        return last - first
    }

    var currentWaist: Double? {
        sessionsWithWaist.last?.waist
    }

    var waistChange: Double? {
        guard let first = sessionsWithWaist.first?.waist,
              let last = sessionsWithWaist.last?.waist else { return nil }
        return last - first
    }

    func updateSessions(_ sessions: [WorkoutSession]) {
        sessionsWithWeight = sessions
            .filter { $0.completed && $0.bodyWeight != nil }
            .map { ($0.date, $0.bodyWeight!) }
        sessionsWithWaist = sessions
            .filter { $0.completed && $0.waistCircumference != nil }
            .map { ($0.date, $0.waistCircumference!) }
    }
}
