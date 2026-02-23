import Foundation

struct ExerciseTemplate: Identifiable, Equatable, Hashable {
    let id: String
    var name: String
    var targetSets: Int
    var targetRepsMin: Int
    var targetRepsMax: Int
    var notes: String?

    init(
        id: String = UUID().uuidString,
        name: String,
        targetSets: Int,
        targetRepsMin: Int,
        targetRepsMax: Int,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.targetSets = targetSets
        self.targetRepsMin = targetRepsMin
        self.targetRepsMax = targetRepsMax
        self.notes = notes
    }
}
