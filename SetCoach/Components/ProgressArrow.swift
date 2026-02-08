import SwiftUI

struct ProgressArrow: View {
    let direction: ProgressDirection

    var body: some View {
        Image(systemName: arrowIcon)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(arrowColor)
    }

    private var arrowIcon: String {
        switch direction {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .same: return "minus"
        }
    }

    private var arrowColor: Color {
        switch direction {
        case .up: return Theme.primary
        case .down: return Theme.destructive
        case .same: return Theme.muted
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        ProgressArrow(direction: .up)
        ProgressArrow(direction: .down)
        ProgressArrow(direction: .same)
    }
    .padding()
    .background(Theme.background)
}
