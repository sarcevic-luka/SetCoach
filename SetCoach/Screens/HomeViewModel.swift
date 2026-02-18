import Foundation
import SwiftData

@MainActor
@Observable
final class HomeViewModel {
    private(set) var programs: [Program] = []

    var isEmpty: Bool {
        programs.isEmpty
    }

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func seedDataIfNeeded() {
        SeedData.createSeedPrograms(context: modelContext)
    }

    func updatePrograms(_ programs: [Program]) {
        self.programs = programs
    }
}
