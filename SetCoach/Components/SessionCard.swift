import SwiftUI

struct SessionCard: View {
    let session: WorkoutSession

    var body: some View {
        NavigationLink(value: session) {
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.trainingDayName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Theme.foreground)
                            Text(session.programName)
                                .font(.system(size: 14))
                                .foregroundColor(Theme.muted)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Theme.muted)
                    }

                    HStack(spacing: 16) {
                        Label(formatDate(session.date), systemImage: "calendar")
                        Label("\(session.duration)min", systemImage: "clock")
                        Label("\(session.exercises.count) exercises", systemImage: "list.bullet")
                        if let weight = session.bodyWeight {
                            Label(String(format: "%.1fkg", weight), systemImage: "figure.stand")
                        }
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Theme.muted)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(session.exercises.prefix(5), id: \.id) { exercise in
                                Text(exercise.name)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Theme.foreground)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Theme.secondary)
                                    .cornerRadius(6)
                            }
                            if session.exercises.count > 5 {
                                Text("+\(session.exercises.count - 5)")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Theme.muted)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Theme.secondary)
                                    .cornerRadius(6)
                            }
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    let session = WorkoutSession(
        programId: UUID().uuidString,
        programName: "Push Pull Legs",
        trainingDayId: UUID().uuidString,
        trainingDayName: "Push Day",
        date: Date(),
        duration: 45,
        exercises: [],
        bodyWeight: 82,
        completed: true
    )
    return SessionCard(session: session)
        .padding()
        .background(Theme.background)
}
