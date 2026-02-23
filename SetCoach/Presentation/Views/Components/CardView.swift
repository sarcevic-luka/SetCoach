import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(Theme.card)
            .cornerRadius(Theme.cornerRadius)
    }
}

#Preview {
    CardView {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Title")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.foreground)
            Text("Sample card content")
                .font(.system(size: 14))
                .foregroundColor(Theme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding()
    .background(Theme.background)
}
