import SwiftUI

struct DifficultyBadge: View {
    let difficulty: Difficulty

    var body: some View {
        Text(difficulty.localizedString)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(badgeColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(badgeColor.opacity(0.2))
            .cornerRadius(8)
    }

    private var badgeColor: Color {
        switch difficulty {
        case .prelagano: return Theme.primary
        case .ok: return Theme.blue
        case .pretesko: return Theme.destructive
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        DifficultyBadge(difficulty: .prelagano)
        DifficultyBadge(difficulty: .ok)
        DifficultyBadge(difficulty: .pretesko)
    }
    .padding()
    .background(Theme.background)
}
