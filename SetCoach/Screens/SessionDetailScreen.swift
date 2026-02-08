import SwiftUI

struct SessionDetailScreen: View {
    let session: WorkoutSession

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(session.trainingDayName)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Theme.foreground)
                        Text(session.programName)
                            .font(.system(size: 14))
                            .foregroundColor(Theme.muted)
                    }
                    .padding(.horizontal)

                    HStack(spacing: 16) {
                        Label(formatDate(session.date), systemImage: "calendar")
                        Label(String(format: String(localized: "%d min"), session.duration), systemImage: "clock")
                        if let weight = session.bodyWeight {
                            Label(String(format: String(localized: "%.1f kg"), weight), systemImage: "figure.stand")
                        }
                        if let waist = session.waistCircumference {
                            Label(String(format: String(localized: "%.1f cm"), waist), systemImage: "ruler")
                        }
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Theme.muted)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("EXERCISES")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.muted)
                            .padding(.horizontal)

                        ForEach(session.exercises, id: \.id) { exercise in
                            SessionExerciseCard(exercise: exercise)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Session")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
}

private struct SessionExerciseCard: View {
    let exercise: WorkoutExercise

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(exercise.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.foreground)
                    Spacer()
                    if let difficulty = exercise.difficulty {
                        DifficultyBadge(difficulty: difficulty)
                    }
                    if let progress = exercise.progressDirection {
                        ProgressArrow(direction: progress)
                    }
                }

                ForEach(exercise.sets, id: \.setNumber) { set in
                    HStack {
                        Text(String(format: String(localized: "Set %d"), set.setNumber))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.muted)
                            .frame(width: 50, alignment: .leading)
                        Text(String(format: String(localized: "%.1f kg × %d"), set.weight, set.reps))
                            .font(.system(size: 14))
                            .foregroundColor(Theme.foreground)
                        if set.completed {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Theme.primary)
                        }
                        Spacer()
                    }
                }

                if let notes = exercise.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.muted)
                }
            }
        }
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
        exercises: [
            WorkoutExercise(
                exerciseTemplateId: UUID().uuidString,
                name: "Bench Press",
                sets: [
                    ExerciseSet(setNumber: 1, weight: 60, reps: 8, completed: true),
                    ExerciseSet(setNumber: 2, weight: 60, reps: 8, completed: true)
                ],
                progressDirection: .up, difficulty: .ok
            )
        ],
        bodyWeight: 82,
        completed: true
    )
    return NavigationStack {
        SessionDetailScreen(session: session)
    }
}
