import SwiftUI

struct ExerciseCard: View {
    let exercise: ExerciseTemplate
    let lastSessionExercise: WorkoutExercise?

    var body: some View {
        NavigationLink(value: AppRoute.exerciseHistory(exercise.name)) {
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(exercise.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.foreground)
                        Spacer()
                        if let last = lastSessionExercise {
                            HStack(spacing: 8) {
                                if let progress = last.progressDirection {
                                    ProgressArrow(direction: progress)
                                }
                                if let difficulty = last.difficulty {
                                    DifficultyBadge(difficulty: difficulty)
                                }
                            }
                        }
                    }

                    Text(String(format: String(localized: "%d sets x %d-%d reps"), exercise.targetSets, exercise.targetRepsMin, exercise.targetRepsMax))
                        .font(.system(size: 14))
                        .foregroundColor(Theme.muted)

                    if let last = lastSessionExercise, !last.sets.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(last.sets, id: \.setNumber) { set in
                                    SetChip(weight: set.weight, reps: set.reps)
                                }
                            }
                        }
                    }

                    if let notes = exercise.notes {
                        HStack(spacing: 8) {
                            Image(systemName: "text.bubble")
                                .font(.system(size: 12))
                            Text(notes)
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Theme.muted)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SetChip: View {
    let weight: Double
    let reps: Int

    var body: some View {
        Text(String(format: String(localized: "%.1fkg x %d"), weight, reps))
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(Theme.foreground)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Theme.secondary)
            .cornerRadius(6)
    }
}

#Preview {
    let exercise = ExerciseTemplate(name: "Bench Press", targetSets: 4, targetRepsMin: 6, targetRepsMax: 8, notes: "Pause at bottom")
    return ExerciseCard(exercise: exercise, lastSessionExercise: nil)
        .padding()
        .background(Theme.background)
}
