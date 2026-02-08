import SwiftUI
import SwiftData
import os

private let logger = Logger(subsystem: "luka.sarcevic.SetCoach", category: "ProgramDetail")

struct ProgramDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let program: Program
    @State private var showDeleteAlert = false

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
                    Button(action: {}) {
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
        .alert("Delete Program", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                modelContext.delete(program)
                do {
                    try modelContext.save()
                } catch {
                    logger.error("Failed to save after delete: \(error.localizedDescription)")
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \(program.name)?")
        }
    }
}

#Preview {
    NavigationStack {
        ProgramDetailScreen(program: Program(name: "Push Pull Legs", programDescription: "3-day split", trainingDays: []))
    }
    .modelContainer(for: [Program.self, TrainingDay.self, ExerciseTemplate.self], inMemory: true)
}
