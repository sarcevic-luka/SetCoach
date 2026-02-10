import SwiftUI

struct ActiveExerciseCard: View {
    @Binding var exercise: WorkoutExercise
    let isExpanded: Bool
    let onToggleExpand: () -> Void
    var onSetComplete: () -> Void = {}

    private var completedCount: Int {
        exercise.sets.filter(\.completed).count
    }

    private var allCompleted: Bool {
        !exercise.sets.isEmpty && exercise.sets.allSatisfy(\.completed)
    }

    var body: some View {
        CardView {
            VStack(spacing: 0) {
                Button(action: onToggleExpand) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(allCompleted ? Theme.primary : Theme.secondary)
                                .frame(width: 40, height: 40)
                            if allCompleted {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Theme.primaryForeground)
                                    .font(.system(size: 16, weight: .bold))
                            } else {
                                Text("\(completedCount)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Theme.foreground)
                            }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Theme.foreground)
                            Text(String(format: String(localized: "%d/%d sets"), completedCount, exercise.sets.count))
                                .font(.system(size: 12))
                                .foregroundColor(Theme.muted)
                        }
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(Theme.muted)
                    }
                }
                .buttonStyle(PlainButtonStyle())

                if isExpanded {
                    VStack(spacing: 16) {
                        Rectangle()
                            .fill(Theme.border)
                            .frame(height: 1)
                            .padding(.vertical, 8)

                        HStack {
                            Text("Set")
                                .frame(width: 40)
                            Text("Weight (kg)")
                                .frame(maxWidth: .infinity)
                            Text("Reps")
                                .frame(maxWidth: .infinity)
                            Text("Done")
                                .frame(width: 44)
                        }
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.muted)

                        ForEach(exercise.sets.indices, id: \.self) { index in
                            SetRow(
                                set: Binding(
                                    get: { exercise.sets[index] },
                                    set: { exercise.sets[index] = $0 }
                                ),
                                onComplete: onSetComplete
                            )
                        }

                        Rectangle()
                            .fill(Theme.border)
                            .frame(height: 1)

                        DifficultySelector(difficulty: $exercise.difficulty)
                        NotesInput(notes: $exercise.notes)
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var exercise = WorkoutExercise(
        exerciseTemplateId: UUID().uuidString,
        name: "Bench Press",
        sets: [
            ExerciseSet(setNumber: 1, weight: 60, reps: 8, completed: false),
            ExerciseSet(setNumber: 2, weight: 60, reps: 8, completed: true)
        ]
    )
    return ActiveExerciseCard(exercise: $exercise, isExpanded: true, onToggleExpand: {}, onSetComplete: {})
        .padding()
        .background(Theme.background)
}
