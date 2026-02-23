import Foundation

@MainActor
struct LoadProgramsUseCase {
    private let programRepository: ProgramRepositoryProtocol

    init(programRepository: ProgramRepositoryProtocol) {
        self.programRepository = programRepository
    }

    func execute() throws -> [Program] {
        try programRepository.seedIfNeeded()
        return try programRepository.fetchAll()
    }
}
