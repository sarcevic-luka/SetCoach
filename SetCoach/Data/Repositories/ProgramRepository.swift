import Foundation
import SwiftData

@MainActor
final class ProgramRepository: ProgramRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() throws -> [Program] {
        let descriptor = FetchDescriptor<ProgramModel>()
        let models = try context.fetch(descriptor)
        return models.map { $0.toDomain() }
    }

    func save(_ program: Program) throws {
        let id = program.id
        let descriptor = FetchDescriptor<ProgramModel>(predicate: #Predicate<ProgramModel> { $0.id == id })
        let results = try context.fetch(descriptor)
        if let existing = results.first {
            for day in existing.trainingDays {
                context.delete(day)
            }
            existing.name = program.name
            existing.programDescription = program.programDescription
            for domainDay in program.trainingDays {
                let dayModel = TrainingDayModel(from: domainDay)
                for ex in dayModel.exercises {
                    context.insert(ex)
                }
                context.insert(dayModel)
                existing.trainingDays.append(dayModel)
            }
        } else {
            SeedData.insertProgram(program, into: context)
        }
        try context.save()
    }

    func delete(programId: String) throws {
        let id = programId
        var descriptor = FetchDescriptor<ProgramModel>(predicate: #Predicate<ProgramModel> { $0.id == id })
        let results = try context.fetch(descriptor)
        if let toDelete = results.first {
            context.delete(toDelete)
            try context.save()
        }
    }

    func seedIfNeeded() throws {
        SeedData.createSeedPrograms(context: context)
    }
}
