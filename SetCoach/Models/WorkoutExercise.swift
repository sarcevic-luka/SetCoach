import Foundation
import SwiftData

enum Difficulty: String, Codable {
    case prelagano = "Prelagano"
    case ok = "OK"
    case pretesko = "Preteško"
}

enum ProgressDirection: String, Codable {
    case up, down, same
}

@Model
final class WorkoutExercise {
    @Attribute(.unique) var id: String
    var exerciseTemplateId: String
    var name: String
    var sets: [ExerciseSet]
    var notes: String?
    var progressDirection: ProgressDirection?
    var difficulty: Difficulty?

    init(id: String = UUID().uuidString, exerciseTemplateId: String,
         name: String, sets: [ExerciseSet] = [], notes: String? = nil,
         progressDirection: ProgressDirection? = nil,
         difficulty: Difficulty? = nil) {
        self.id = id
        self.exerciseTemplateId = exerciseTemplateId
        self.name = name
        self.sets = sets
        self.notes = notes
        self.progressDirection = progressDirection
        self.difficulty = difficulty
    }
}
