import SwiftUI

struct SetRow: View {
    @Binding var set: ExerciseSet
    var onComplete: (() -> Void)?

    var body: some View {
        HStack(spacing: 8) {
            Text("\(set.setNumber)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Theme.foreground)
                .frame(width: 40)

            HStack(spacing: 4) {
                Button(action: {
                    if set.weight >= 2.5 {
                        set.weight -= 2.5
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.foreground)
                        .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                        .background(Theme.secondary)
                        .cornerRadius(8)
                }
                Text(String(format: "%.1f", set.weight))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.foreground)
                    .frame(minWidth: 50)
                Button(action: { set.weight += 2.5 }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.foreground)
                        .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                        .background(Theme.secondary)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)

            HStack(spacing: 4) {
                Button(action: {
                    if set.reps > 1 {
                        set.reps -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.foreground)
                        .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                        .background(Theme.secondary)
                        .cornerRadius(8)
                }
                Text("\(set.reps)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.foreground)
                    .frame(minWidth: 40)
                Button(action: { set.reps += 1 }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Theme.foreground)
                        .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
                        .background(Theme.secondary)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)

            Button(action: {
                set.completed.toggle()
                if set.completed {
                    onComplete?()
                }
            }) {
                Image(systemName: set.completed ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(set.completed ? Theme.primary : Theme.muted)
                    .frame(width: Theme.minTouchTarget, height: Theme.minTouchTarget)
            }
        }
    }
}
