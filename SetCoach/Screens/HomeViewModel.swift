import Foundation
import os

@MainActor
@Observable
final class HomeViewModel {
    private(set) var programs: [Program] = []
    private(set) var loadError: String?

    var isEmpty: Bool {
        programs.isEmpty
    }

    private let loadProgramsUseCase: LoadProgramsUseCase

    init(loadProgramsUseCase: LoadProgramsUseCase) {
        self.loadProgramsUseCase = loadProgramsUseCase
    }

    func loadPrograms() {
        loadError = nil
        do {
            programs = try loadProgramsUseCase.execute()
        } catch {
            logger.error("Failed to load programs: \(error.localizedDescription)")
            loadError = error.localizedDescription
            programs = []
        }
    }
}

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "Home")
