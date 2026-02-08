import SwiftUI

struct TrainingDayCard: View {
    let program: Program
    let trainingDay: TrainingDay

    var body: some View {
        CardView {
            VStack(spacing: 16) {
                NavigationLink(value: AppRoute.trainingDetail(program, trainingDay)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(trainingDay.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.foreground)
                        Text(String(format: String(localized: "%d exercises"), trainingDay.exercises.count))
                            .font(.system(size: 14))
                            .foregroundColor(Theme.muted)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(PlainButtonStyle())

                Rectangle()
                    .fill(Theme.border)
                    .frame(height: 1)

                NavigationLink(value: AppRoute.activeWorkout(program, trainingDay)) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Workout")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Theme.primaryForeground)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Theme.primary)
                    .cornerRadius(Theme.cornerRadius)
                }
            }
        }
    }
}

#Preview {
    let program = Program(name: "PPL", programDescription: nil, trainingDays: [])
    let day = TrainingDay(name: "Push Day", exercises: [])
    return TrainingDayCard(program: program, trainingDay: day)
        .padding()
        .background(Theme.background)
}
