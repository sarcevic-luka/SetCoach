import SwiftUI
import AudioToolbox

struct RestTimerOverlay: View {
    @Binding var isPresented: Bool
    let duration: Int
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    @State private var hasPlayedSound = false

    init(isPresented: Binding<Bool>, duration: Int) {
        _isPresented = isPresented
        self.duration = duration
        _timeRemaining = State(initialValue: duration)
    }

    private var isComplete: Bool {
        timeRemaining <= 0
    }

    private var progress: CGFloat {
        guard duration > 0 else { return 0 }
        return CGFloat(timeRemaining) / CGFloat(duration)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                ZStack {
                    Circle()
                        .stroke(Theme.primary.opacity(0.3), lineWidth: 8)
                        .frame(width: 200, height: 200)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            isComplete ? Theme.primary : Theme.blue,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: timeRemaining)
                    Image(systemName: isComplete ? "checkmark.circle.fill" : "timer")
                        .font(.system(size: 64))
                        .foregroundColor(isComplete ? Theme.primary : Theme.blue)
                }

                Text(formatTime(timeRemaining))
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(Theme.foreground)
                    .monospacedDigit()

                Text(isComplete ? String(localized: "Time's up!") : String(localized: "Rest timer"))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isComplete ? Theme.primary : Theme.muted)

                Button(action: {
                    isPresented = false
                    stopTimer()
                }) {
                    Text(isComplete ? String(localized: "Continue") : String(localized: "Skip"))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.primaryForeground)
                        .frame(width: 200, height: 56)
                        .background(isComplete ? Theme.primary : Theme.secondary)
                        .cornerRadius(Theme.cornerRadius)
                }
            }
        }
        .onAppear {
            hasPlayedSound = false
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                if !hasPlayedSound {
                    hasPlayedSound = true
                    playCompletionSound()
                }
                timer?.invalidate()
                timer = nil
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func playCompletionSound() {
        AudioServicesPlaySystemSound(1013)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    RestTimerOverlay(isPresented: .constant(true), duration: 90)
}
