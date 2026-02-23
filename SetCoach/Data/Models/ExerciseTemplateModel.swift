import Foundation
import SwiftData

@Model
final class ExerciseTemplateModel {
    @Attribute(.unique) var id: String
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

    convenience init(from entity: ExerciseTemplate) {
        self.init(
            id: entity.id,
            name: entity.name,
            targetSets: entity.targetSets,
            targetRepsMin: entity.targetRepsMin,
            targetRepsMax: entity.targetRepsMax,
            notes: entity.notes
        )
    }

    func toDomain() -> ExerciseTemplate {
        ExerciseTemplate(
            id: id,
            name: name,
            targetSets: targetSets,
            targetRepsMin: targetRepsMin,
            targetRepsMax: targetRepsMax,
            notes: notes
        )
    }
}
