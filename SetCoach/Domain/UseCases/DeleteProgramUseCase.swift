import Foundation

@MainActor
struct DeleteProgramUseCase {
    private let programRepository: ProgramRepositoryProtocol

    init(programRepository: ProgramRepositoryProtocol) {
        self.programRepository = programRepository
    }

    func execute(programId: String) throws {
        try programRepository.delete(programId: programId)
    }
}
