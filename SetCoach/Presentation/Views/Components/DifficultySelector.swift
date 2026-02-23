import SwiftUI

struct DifficultySelector: View {
    @Binding var difficulty: Difficulty?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Difficulty")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.muted)
            HStack(spacing: 8) {
                ForEach([Difficulty.prelagano, .ok, .pretesko], id: \.self) { diff in
                    DifficultyButton(
                        diff: diff,
                        isSelected: difficulty == diff,
                        action: { difficulty = diff }
                    )
                }
            }
        }
    }
}

private struct DifficultyButton: View {
    let diff: Difficulty
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(diff.localizedString)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(isSelected ? color(for: diff) : Theme.muted)
                .frame(maxWidth: .infinity)
                .frame(height: Theme.minTouchTarget)
                .background(isSelected ? color(for: diff).opacity(0.2) : Theme.secondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? color(for: diff) : Color.clear, lineWidth: 2)
                )
                .cornerRadius(8)
        }
    }

    private func color(for diff: Difficulty) -> Color {
        switch diff {
        case .prelagano: return Theme.primary
        case .ok: return Theme.blue
        case .pretesko: return Theme.destructive
        }
    }
}
