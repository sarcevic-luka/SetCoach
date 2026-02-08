import SwiftUI

struct ExerciseHistoryPlaceholderScreen: View {
    let exerciseName: String

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 16) {
                Text(exerciseName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.foreground)
                Text("Exercise history – coming in a future phase")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.muted)
            }
        }
        .navigationTitle(exerciseName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
