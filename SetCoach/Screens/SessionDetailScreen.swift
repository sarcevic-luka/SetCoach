import SwiftUI
import Combine

struct SessionDetailScreen: View {
    let session: WorkoutSession

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    CardView {
                        VStack(spacing: 16) {
                            HStack(spacing: 24) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(String(localized: "DATE"))
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Theme.muted)
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(Theme.primary)
                                        Text(formatDate(session.date))
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Theme.foreground)
                                    }
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(String(localized: "DURATION"))
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Theme.muted)
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(Theme.primary)
                                        Text(String(format: String(localized: "%d min"), session.duration))
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Theme.foreground)
                                    }
                                }
                                Spacer()
                            }

                            Rectangle()
                                .fill(Theme.border)
                                .frame(height: 1)

                            HStack(spacing: 24) {
                                if let weight = session.bodyWeight {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(String(localized: "BODY WEIGHT"))
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(Theme.muted)
                                        HStack {
                                            Image(systemName: "figure.stand")
                                                .foregroundColor(Theme.blue)
                                            Text(String(format: String(localized: "%.1f kg"), weight))
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(Theme.foreground)
                                        }
                                    }
                                }
                                if let waist = session.waistCircumference {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(String(localized: "WAIST"))
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(Theme.muted)
                                        HStack {
                                            Image(systemName: "ruler")
                                                .foregroundColor(Theme.blue)
                                            Text(String(format: String(localized: "%.1f cm"), waist))
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(Theme.foreground)
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("EXERCISES")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.muted)
                            .padding(.horizontal)
                        ForEach(session.exercises, id: \.id) { exercise in
                            NavigationLink(value: exercise.name) {
                                SessionExerciseCard(exercise: exercise)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(session.trainingDayName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: String.self) { exerciseName in
            ExerciseHistoryScreen(exerciseName: exerciseName)
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
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
        exercises: [
            WorkoutExercise(
                exerciseTemplateId: UUID().uuidString,
                name: "Bench Press",
                sets: [
                    ExerciseSet(setNumber: 1, weight: 60, reps: 8, completed: true),
                    ExerciseSet(setNumber: 2, weight: 60, reps: 8, completed: true)
                ],
                progressDirection: .up,
                difficulty: .ok
            )
        ],
        bodyWeight: 82,
        completed: true
    )
    return NavigationStack {
        SessionDetailScreen(session: session)
    }
}

