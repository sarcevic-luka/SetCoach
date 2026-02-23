import SwiftUI
import os
import SwiftData

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "ProgramDetail")

struct ProgramDetailScreen: View {
    @Environment(\.dependencies) private var dependencies
    let program: Program
    @State private var showDeleteAlert = false
    @State private var showEditSheet = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(program.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.foreground)
                        if let description = program.programDescription {
                            Text(description)
                                .font(.system(size: 14))
                                .foregroundColor(Theme.muted)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("TRAINING DAYS")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.muted)
                            .padding(.horizontal)
                        ForEach(program.trainingDays) { day in
                            TrainingDayCard(program: program, trainingDay: day)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                .padding(.bottom, 96)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: { showEditSheet = true }) {
                        Image(systemName: "pencil")
                            .foregroundColor(Theme.primary)
                    }
                    Button(action: { showDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .foregroundColor(Theme.destructive)
                    }
                }
            }
        }
        .alert(String(localized: "Delete Program"), isPresented: $showDeleteAlert) {
            Button(String(localized: "Cancel"), role: .cancel) {}
            Button(String(localized: "Delete"), role: .destructive) {
                guard let dependencies else { return }
                do {
                    let useCase = dependencies.makeDeleteProgramUseCase()
                    try useCase.execute(programId: program.id)
                    dependencies.router.pop()
                } catch {
                    logger.error("Failed to save after delete: \(error.localizedDescription)")
                }
            }
        } message: {
            Text(String(format: String(localized: "Are you sure you want to delete %@?"), program.name))
        }
        .sheet(isPresented: $showEditSheet) {
            AddEditProgramScreen(editProgram: program)
        }
    }
}

#Preview {
    var program = Program(name: "Push Pull Legs", programDescription: "Classic 3-day split for strength and hypertrophy", trainingDays: [])
    let pushDay = TrainingDay(name: "Push Day", exercises: [])
    let pullDay = TrainingDay(name: "Pull Day", exercises: [])
    let legDay = TrainingDay(name: "Leg Day", exercises: [])
    program.trainingDays = [pushDay, pullDay, legDay]
    return NavigationStack {
        ProgramDetailScreen(program: program)
    }
    .modelContainer(for: [ProgramModel.self, TrainingDayModel.self, ExerciseTemplateModel.self], inMemory: true)
}
