import Foundation
import SwiftData

/// Repository implementation for WorkoutSession persistence using SwiftData
/// Implements Clean Architecture Data Layer - uses Mappers to convert between Domain and DTO
@MainActor
final class WorkoutSessionRepository: WorkoutSessionRepositoryProtocol {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - WorkoutSessionRepositoryProtocol
    
    func fetchAll(sortByDateDescending: Bool) throws -> [WorkoutSession] {
        let order: SortOrder = sortByDateDescending ? .reverse : .forward
        let descriptor = FetchDescriptor<WorkoutSessionModel>(
            sortBy: [SortDescriptor(\.date, order: order)]
        )
        let models = try context.fetch(descriptor)
        return WorkoutSessionMapper.toDomain(from: models)
    }
    
    func save(_ session: WorkoutSession) throws {
        let model = WorkoutSessionMapper.toModel(from: session)
        context.insert(model)
        try context.save()
    }
}
