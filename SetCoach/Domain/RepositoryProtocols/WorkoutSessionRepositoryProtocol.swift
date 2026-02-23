import Foundation

protocol WorkoutSessionRepositoryProtocol {
    func fetchAll(sortByDateDescending: Bool) throws -> [WorkoutSession]
    func save(_ session: WorkoutSession) throws
}
