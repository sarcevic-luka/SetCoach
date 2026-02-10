import SwiftUI

struct ExerciseHistoryCard: View {
    let session: WorkoutSession
    let exercise: WorkoutExercise
    let isPersonalBest: Bool

    private var bestSet: ExerciseSet? {
        exercise.sets.max { ($0.weight * Double($0.reps)) < ($1.weight * Double($1.reps)) }
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatDate(session.date))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Theme.foreground)
                        Text(session.trainingDayName)
                            .font(.system(size: 12))
                            .foregroundColor(Theme.muted)
                    }
                    Spacer()
                    HStack(spacing: 8) {
                        if let progress = exercise.progressDirection {
                            ProgressArrow(direction: progress)
                        }
                        if let difficulty = exercise.difficulty {
                            DifficultyBadge(difficulty: difficulty)
                        }
                    }
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(exercise.sets, id: \.setNumber) { set in
                            let isBest = bestSet?.setNumber == set.setNumber
                            SetChip(weight: set.weight, reps: set.reps)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(isBest ? Theme.primary : Color.clear, lineWidth: 2)
                                )
                                .background(isBest ? Theme.primary.opacity(0.15) : Color.clear)
                                .cornerRadius(6)
                        }
                    }
                }

                if isPersonalBest {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(Theme.primary)
                        Text(String(localized: "Personal Best in this session"))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Theme.primary)
                    }
                    .padding(.vertical, 6)
                }

                if let notes = exercise.notes, !notes.isEmpty {
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

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}

#Preview {
    let session = WorkoutSession(
        programId: UUID().uuidString,
        programName: "PPL",
        trainingDayId: UUID().uuidString,
        trainingDayName: "Push Day",
        date: Date(),
        duration: 45,
        exercises: [],
        bodyWeight: 82,
        completed: true
    )
    let exercise = WorkoutExercise(
        exerciseTemplateId: UUID().uuidString,
        name: "Bench Press",
        sets: [
            ExerciseSet(setNumber: 1, weight: 60, reps: 8, completed: true),
            ExerciseSet(setNumber: 2, weight: 62.5, reps: 6, completed: true)
        ],
        progressDirection: .up, difficulty: .ok
    )
    ExerciseHistoryCard(session: session, exercise: exercise, isPersonalBest: true)
        .padding()
        .background(Theme.background)
}
