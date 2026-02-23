import SwiftUI

struct ProgramCard: View {
    let program: Program

    var body: some View {
        CardView {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Theme.primary.opacity(0.2))
                        .frame(width: 56, height: 56)
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Theme.primary)
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text(program.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.foreground)
                    if let description = program.programDescription {
                        Text(description)
                            .font(.system(size: 14))
                            .foregroundColor(Theme.muted)
                            .lineLimit(1)
                    }
                    HStack(spacing: 12) {
                        Label(String(format: String(localized: "%d days"), program.trainingDays.count), systemImage: "calendar")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Theme.muted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.muted)
            }
        }
    }
}

#Preview {
    let program = Program(
        name: "Push Pull Legs",
        programDescription: "Classic 3-day split",
        trainingDays: []
    )
    return ProgramCard(program: program)
        .padding()
        .background(Theme.background)
}
