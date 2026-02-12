import SwiftUI

struct ExercisePickerSheet: View {
    @Binding var isPresented: Bool
    let onSelect: (LibraryExercise) -> Void

    @State private var searchText = ""
    @State private var selectedCategory: MuscleGroup?

    private var results: [LibraryExercise] {
        if !searchText.isEmpty {
            return ExerciseLibrary.search(searchText)
        } else if let cat = selectedCategory {
            return ExerciseLibrary.exercises(for: cat)
        }
        return ExerciseLibrary.all
    }

    private var grouped: [(group: MuscleGroup, exercises: [LibraryExercise])] {
        if !searchText.isEmpty || selectedCategory != nil {
            let groups = Dictionary(grouping: results, by: { $0.muscleGroup })
            return MuscleGroup.allCases.compactMap { group in
                guard let list = groups[group], !list.isEmpty else { return nil }
                return (group, list)
            }
        }
        return MuscleGroup.allCases.map { group in
            (group, ExerciseLibrary.exercises(for: group))
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Search Bar
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Theme.muted)
                        TextField("Search exercises...", text: $searchText)
                            .font(.system(size: 16))
                            .foregroundColor(Theme.foreground)
                            .autocorrectionDisabled()
                    }
                    .padding(12)
                    .background(Theme.secondary)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    // Category Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            CategoryChip(
                                label: "All",
                                icon: "square.grid.2x2",
                                isSelected: selectedCategory == nil && searchText.isEmpty
                            ) {
                                selectedCategory = nil
                                searchText = ""
                            }
                            ForEach(MuscleGroup.allCases, id: \.self) { group in
                                CategoryChip(
                                    label: group.rawValue,
                                    icon: group.icon,
                                    isSelected: selectedCategory == group
                                ) {
                                    selectedCategory = selectedCategory == group ? nil : group
                                    searchText = ""
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }

                    Divider()
                        .background(Theme.border)

                    // Exercise List
                    if results.isEmpty {
                        emptyState
                    } else {
                        exerciseList
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(Theme.primary)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Theme.background)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(Theme.muted)
            Text("No exercises found")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Theme.foreground)
            Text("Try a different search or category")
                .font(.system(size: 14))
                .foregroundColor(Theme.muted)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var exerciseList: some View {
        List {
            ForEach(grouped, id: \.group) { section in
                Section {
                    ForEach(section.exercises) { exercise in
                        ExerciseLibraryRow(exercise: exercise) {
                            onSelect(exercise)
                            isPresented = false
                        }
                        .listRowBackground(Theme.card)
                        .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    }
                } header: {
                    HStack(spacing: 8) {
                        Image(systemName: section.group.icon)
                            .foregroundColor(Theme.primary)
                            .font(.system(size: 12))
                        Text(section.group.rawValue.uppercased())
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.muted)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Theme.background)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundColor(isSelected ? Theme.primaryForeground : Theme.foreground)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Theme.primary : Theme.secondary)
            .cornerRadius(20)
        }
    }
}

// MARK: - Exercise Row
struct ExerciseLibraryRow: View {
    let exercise: LibraryExercise
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(exercise.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Theme.foreground)
                    HStack(spacing: 12) {
                        Label("\(exercise.defaultSets) sets", systemImage: "square.stack.3d.up")
                        Label("\(exercise.defaultRepsMin)-\(exercise.defaultRepsMax) reps", systemImage: "repeat")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Theme.muted)
                    if let notes = exercise.defaultNotes {
                        Label(notes, systemImage: "text.bubble")
                            .font(.system(size: 11))
                            .foregroundColor(Theme.muted)
                            .lineLimit(1)
                    }
                }
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Theme.primary)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var isPresented = true

    ExercisePickerSheet(isPresented: $isPresented) { _ in }
}
