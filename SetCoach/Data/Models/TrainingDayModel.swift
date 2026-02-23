import Foundation
import SwiftData

@Model
final class TrainingDayModel {
    @Attribute(.unique) var id: String
    var name: String
    @Relationship(deleteRule: .cascade) var exercises: [ExerciseTemplateModel]

    init(id: String = UUID().uuidString, name: String, exercises: [ExerciseTemplateModel] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}
