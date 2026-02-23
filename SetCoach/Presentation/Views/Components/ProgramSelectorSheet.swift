import SwiftUI

/// Sheet for selecting a program and training day when adding a manual workout.
struct ProgramSelectorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dependencies) private var dependencies

    let onSelect: (Program, TrainingDay) -> Void

    @State private var programs: [Program] = []
    @State private var loadError: String?

    var body: some View {
        NavigationStack {
            Group {
                if let error = loadError {
                    errorView(message: error)
                } else if programs.isEmpty && loadError == nil {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if programs.isEmpty {
                    emptyStateView
                } else {
                    programListView
                }
            }
            .navigationTitle(String(localized: "Select Workout"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { dismiss() }
                        .foregroundColor(Theme.primary)
                }
            }
            .onAppear { loadPrograms() }
        }
    }

    private var programListView: some View {
        List {
            ForEach(programs) { program in
                Section {
                    ForEach(program.trainingDays) { trainingDay in
                        Button(action: {
                            onSelect(program, trainingDay)
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                ProgramImageView(program: program, size: 44, cornerRadius: 8)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(trainingDay.name)
                                        .font(.headline)
                                        .foregroundColor(Theme.foreground)
                                    Text(String(format: String(localized: "%d exercises"), trainingDay.exercises.count))
                                        .font(.caption)
                                        .foregroundColor(Theme.muted)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(Theme.muted)
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    HStack(spacing: 8) {
                        ProgramImageView(program: program, size: 24, cornerRadius: 6)
                        Text(program.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.foreground)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell")
                .font(.system(size: 60))
                .foregroundColor(Theme.muted)
            Text(String(localized: "No Programs Found"))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Theme.foreground)
            Text(String(localized: "Create a program first to log workouts"))
                .font(.body)
                .foregroundColor(Theme.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(Theme.destructive)
            Text(String(localized: "Error Loading Programs"))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Theme.foreground)
            Text(message)
                .font(.body)
                .foregroundColor(Theme.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button(String(localized: "Try Again")) { loadPrograms() }
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
    }

    private func loadPrograms() {
        loadError = nil
        guard let dependencies else { return }
        do {
            programs = try dependencies.makeLoadProgramsUseCase().execute()
        } catch {
            loadError = error.localizedDescription
        }
    }
}

#Preview {
    ProgramSelectorSheet { _, _ in }
        .environment(\.dependencies, nil)
}
