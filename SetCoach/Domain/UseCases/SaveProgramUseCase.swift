import Foundation

@MainActor
struct SaveProgramUseCase {
    private let programRepository: ProgramRepositoryProtocol

    init(programRepository: ProgramRepositoryProtocol) {
        self.programRepository = programRepository
    }

    func execute(_ program: Program) throws {
        try programRepository.save(program)
    }
}
