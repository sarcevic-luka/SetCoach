import SwiftUI

struct StepperView: View {
    @Binding var value: Double
    let step: Double
    let minimum: Double

    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                if value > minimum {
                    value -= step
                }
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.foreground)
                    .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                    .background(Theme.secondary)
                    .cornerRadius(8)
            }
            Text(String(format: "%.1f", value))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.foreground)
                .frame(minWidth: 60)
            Button(action: { value += step }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.foreground)
                    .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                    .background(Theme.secondary)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    StepperView(value: .constant(82.0), step: 0.5, minimum: 0)
        .padding()
        .background(Theme.background)
}
