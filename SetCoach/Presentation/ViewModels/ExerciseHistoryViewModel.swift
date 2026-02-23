import Foundation
import SwiftData

struct VolumeChartPoint: Identifiable {
    let id: String
    let volume: Double
}

struct MaxWeightChartPoint: Identifiable {
    let id: String
    let weight: Double
}

@MainActor
@Observable
final class ExerciseHistoryViewModel {
    let exerciseName: String
    private(set) var exerciseSessions: [(session: WorkoutSession, exercise: WorkoutExercise)] = []
    private(set) var volumeChartData: [VolumeChartPoint] = []
    private(set) var maxWeightChartData: [MaxWeightChartPoint] = []

    var personalBest: (weight: Double, reps: Int)? {
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

    var hasSessions: Bool {
        !exerciseSessions.isEmpty
    }

    var isEmpty: Bool {
        exerciseSessions.isEmpty
    }

    var totalCount: Int {
        exerciseSessions.count
    }

    init(exerciseName: String) {
        self.exerciseName = exerciseName
    }

    func updateSessions(_ sessions: [WorkoutSession]) {
        exerciseSessions = sessions
            .filter(\.completed)
            .compactMap { session in
                if let exercise = session.exercises.first(where: { $0.name == exerciseName }) {
                    return (session, exercise)
                }
                return nil
            }
            .sorted { $0.session.date > $1.session.date }

        let reversed = Array(exerciseSessions.reversed())
        volumeChartData = reversed.map { item in
            let totalVolume = item.exercise.sets.reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
            return VolumeChartPoint(id: item.session.id, volume: totalVolume)
        }
        maxWeightChartData = reversed.map { item in
            let maxWeight = item.exercise.sets.map(\.weight).max() ?? 0
            return MaxWeightChartPoint(id: item.session.id, weight: maxWeight)
        }
    }

    func displayedSessions(showAll: Bool) -> [(session: WorkoutSession, exercise: WorkoutExercise)] {
        showAll ? exerciseSessions : Array(exerciseSessions.prefix(3))
    }

    func isPersonalBestSession(_ exercise: WorkoutExercise) -> Bool {
        guard let pb = personalBest else { return false }
        return exercise.sets.contains { $0.weight == pb.weight && $0.reps == pb.reps }
    }
}
