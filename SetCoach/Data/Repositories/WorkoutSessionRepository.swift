import Foundation
import SwiftData

@MainActor
final class WorkoutSessionRepository: WorkoutSessionRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll(sortByDateDescending: Bool) throws -> [WorkoutSession] {
        let order: SortOrder = sortByDateDescending ? .reverse : .forward
        var descriptor = FetchDescriptor<WorkoutSessionModel>(sortBy: [SortDescriptor(\.date, order: order)])
        let models = try context.fetch(descriptor)
        return models.map { $0.toDomain() }
    }

    func save(_ session: WorkoutSession) throws {
        let model = WorkoutSessionModel(from: session)
        context.insert(model)
        try context.save()
    }
}
