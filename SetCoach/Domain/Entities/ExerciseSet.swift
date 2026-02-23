import Foundation

struct ExerciseSet: Identifiable, Equatable, Hashable {
    let id: UUID
    var setNumber: Int
    var weight: Double
    var reps: Int
    var completed: Bool

    init(id: UUID = UUID(), setNumber: Int, weight: Double = 0, reps: Int = 0, completed: Bool = false) {
        self.id = id
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.completed = completed
    }
}
