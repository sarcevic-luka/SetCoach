import SwiftUI

struct ProgramCard: View {
    let program: Program

    var body: some View {
        CardView {
            HStack(spacing: 16) {
                ProgramImageView(program: program, size: 56, cornerRadius: 12)
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
