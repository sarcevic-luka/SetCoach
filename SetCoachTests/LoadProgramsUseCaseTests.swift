import XCTest
@testable import SetCoach

@MainActor
final class LoadProgramsUseCaseTests: XCTestCase {

    func testExecuteReturnsProgramsFromRepository() throws {
        let expected = [
            Program(name: "PPL", programDescription: nil, trainingDays: [])
        ]
        let mock = MockProgramRepository(programs: expected)
        let useCase = LoadProgramsUseCase(programRepository: mock)

        let result = try useCase.execute()

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "PPL")
        XCTAssertTrue(mock.seedIfNeededCalled)
        XCTAssertTrue(mock.fetchAllCalled)
    }

    func testExecutePropagatesRepositoryError() {
        let mock = MockProgramRepository(programs: [], shouldThrow: true)
        let useCase = LoadProgramsUseCase(programRepository: mock)

        XCTAssertThrowsError(try useCase.execute())
    }
}

@MainActor
private final class MockProgramRepository: ProgramRepositoryProtocol {
    var programs: [Program]
    var shouldThrow: Bool
    var seedIfNeededCalled = false
    var fetchAllCalled = false

    init(programs: [Program], shouldThrow: Bool = false) {
        self.programs = programs
        self.shouldThrow = shouldThrow
    }

    func fetchAll() throws -> [Program] {
        fetchAllCalled = true
        if shouldThrow { throw NSError(domain: "test", code: -1, userInfo: nil) }
        return programs
    }

    func save(_ program: Program) throws {
        if shouldThrow { throw NSError(domain: "test", code: -1, userInfo: nil) }
    }

    func delete(programId: String) throws {
        if shouldThrow { throw NSError(domain: "test", code: -1, userInfo: nil) }
    }

    func seedIfNeeded() throws {
        seedIfNeededCalled = true
        if shouldThrow { throw NSError(domain: "test", code: -1, userInfo: nil) }
    }
}
