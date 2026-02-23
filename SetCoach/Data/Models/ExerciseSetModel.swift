import Foundation
import SwiftData

@Model
final class ExerciseSetModel {
    var setNumber: Int
    var weight: Double
    var reps: Int
    var completed: Bool

    init(setNumber: Int, weight: Double = 0, reps: Int = 0, completed: Bool = false) {
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.completed = completed
    }

    convenience init(from entity: ExerciseSet) {
        self.init(
            setNumber: entity.setNumber,
            weight: entity.weight,
            reps: entity.reps,
            completed: entity.completed
        )
    }

    func toDomain() -> ExerciseSet {
        ExerciseSet(
            id: UUID(),
            setNumber: setNumber,
            weight: weight,
            reps: reps,
            completed: completed
        )
    }
}
