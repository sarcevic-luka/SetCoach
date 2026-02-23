import Foundation

struct Program: Identifiable, Equatable, Hashable {
    let id: String
    var name: String
    var programDescription: String?
    var imageIdentifier: String? // Built-in image (e.g., "strength", "cardio")
    var customImageData: Data? // User's photo from library
    var trainingDays: [TrainingDay]
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        name: String,
        programDescription: String? = nil,
        imageIdentifier: String? = nil,
        customImageData: Data? = nil,
        trainingDays: [TrainingDay] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.programDescription = programDescription
        self.imageIdentifier = imageIdentifier
        self.customImageData = customImageData
        self.trainingDays = trainingDays
        self.createdAt = createdAt
    }
}
