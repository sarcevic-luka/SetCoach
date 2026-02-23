import Foundation

protocol ProgramRepositoryProtocol {
    func fetchAll() throws -> [Program]
    func save(_ program: Program) throws
    func delete(programId: String) throws
    func seedIfNeeded() throws
}
