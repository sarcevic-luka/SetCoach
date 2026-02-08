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
                    Button(action: { difficulty = diff }) {
                        Text(diff.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(difficulty == diff ? buttonColor(diff) : Theme.muted)
                            .frame(maxWidth: .infinity)
                            .frame(height: Theme.minTouchTarget)
                            .background(difficulty == diff ? buttonColor(diff).opacity(0.2) : Theme.secondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(difficulty == diff ? buttonColor(diff) : Color.clear, lineWidth: 2)
                            )
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    private func buttonColor(_ diff: Difficulty) -> Color {
        switch diff {
        case .prelagano: return Theme.primary
        case .ok: return Theme.blue
        case .pretesko: return Theme.destructive
        }
    }
}
