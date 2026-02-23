import Foundation

/// Use Case: Format time duration in various formats
struct FormatDurationUseCase {

    func executeAsElapsedTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    func executeAsRestDuration(seconds: Int) -> String {
        if seconds < 60 { return "\(seconds)s" }
        if seconds % 60 == 0 { return "\(seconds / 60)m" }
        return "\(seconds / 60)m \(seconds % 60)s"
    }

    func executeAsMinutes(seconds: Int) -> Int {
        seconds / 60
    }

    func executeAsLongFormat(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        if hours > 0 && minutes > 0 { return "\(hours)h \(minutes)m" }
        if hours > 0 { return "\(hours)h" }
        return "\(minutes)m"
    }
}
