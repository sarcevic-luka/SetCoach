import Foundation
import SwiftData

/// Repository implementation for Program persistence using SwiftData
/// Implements Clean Architecture Data Layer - uses Mappers to convert between Domain and DTO
@MainActor
final class ProgramRepository: ProgramRepositoryProtocol {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - ProgramRepositoryProtocol
    
    func fetchAll() throws -> [Program] {
        let descriptor = FetchDescriptor<ProgramModel>()
        let models = try context.fetch(descriptor)
        return ProgramMapper.toDomain(from: models)
    }
    
    func save(_ program: Program) throws {
        let id = program.id
        let descriptor = FetchDescriptor<ProgramModel>(
            predicate: #Predicate<ProgramModel> { $0.id == id }
        )
        let results = try context.fetch(descriptor)
        
        if let existing = results.first {
            // Update existing program
            updateExistingProgram(existing, with: program)
        } else {
            // Insert new program
            SeedData.insertProgram(program, into: context)
        }
        
        try context.save()
    }
    
    func delete(programId: String) throws {
        let id = programId
        let descriptor = FetchDescriptor<ProgramModel>(
            predicate: #Predicate<ProgramModel> { $0.id == id }
        )
        let results = try context.fetch(descriptor)
        
        if let toDelete = results.first {
            context.delete(toDelete)
            try context.save()
        }
    }
    
    func seedIfNeeded() throws {
        SeedData.createSeedPrograms(context: context)
    }
    
    // MARK: - Private Helpers
    
    private func updateExistingProgram(_ existing: ProgramModel, with program: Program) {
        // Delete old training days
        for day in existing.trainingDays {
            context.delete(day)
        }
        
        // Update basic properties
        existing.name = program.name
        existing.programDescription = program.programDescription
        
        // Add new training days
        for domainDay in program.trainingDays {
            let dayModel = TrainingDayMapper.toModel(from: domainDay)
            
            // Insert exercises first
            for exercise in dayModel.exercises {
                context.insert(exercise)
            }
            
            context.insert(dayModel)
            existing.trainingDays.append(dayModel)
        }
    }
}
