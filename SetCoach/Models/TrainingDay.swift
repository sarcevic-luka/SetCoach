import Foundation
import SwiftData

@Model
final class TrainingDay {
    @Attribute(.unique) var id: String
    var name: String
    @Relationship(deleteRule: .cascade) var exercises: [ExerciseTemplate]
    var program: Program?  // Back-reference (optional)
    
    init(id: String = UUID().uuidString, name: String,
         exercises: [ExerciseTemplate] = []) {
        self.id = id
        self.name = name
        self.exercises = exercises
    }
}
