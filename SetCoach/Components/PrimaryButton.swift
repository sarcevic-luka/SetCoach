import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isDestructive: Bool = false

    init(_ title: String, icon: String? = nil, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(Theme.primaryForeground)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isDestructive ? Theme.destructive : Theme.primary)
            .cornerRadius(Theme.cornerRadius)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton("Start Workout", icon: "play.fill") {}
        PrimaryButton("Delete", icon: "trash", isDestructive: true) {}
    }
    .padding()
    .background(Theme.background)
}
