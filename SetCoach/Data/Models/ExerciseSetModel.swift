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
}
