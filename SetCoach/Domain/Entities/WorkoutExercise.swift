import Foundation

enum Difficulty: String, Codable, CaseIterable, Hashable {
    case prelagano = "Prelagano"
    case ok = "OK"
    case pretesko = "Preteško"

    var localizedString: String {
        String(localized: String.LocalizationValue(rawValue))
    }
}

enum ProgressDirection: String, Codable, Hashable {
    case up, down, same
}

struct WorkoutExercise: Identifiable, Equatable, Hashable {
    let id: String
    var exerciseTemplateId: String
    var name: String
    var sets: [ExerciseSet]
    var notes: String?
    var progressDirection: ProgressDirection?
    var difficulty: Difficulty?

    init(
        id: String = UUID().uuidString,
        exerciseTemplateId: String,
        name: String,
        sets: [ExerciseSet] = [],
        notes: String? = nil,
        progressDirection: ProgressDirection? = nil,
        difficulty: Difficulty? = nil
    ) {
        self.id = id
        self.exerciseTemplateId = exerciseTemplateId
        self.name = name
        self.sets = sets
        self.notes = notes
        self.progressDirection = progressDirection
        self.difficulty = difficulty
    }
}
