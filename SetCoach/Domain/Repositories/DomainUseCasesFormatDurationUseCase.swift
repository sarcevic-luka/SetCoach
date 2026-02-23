import Foundation

/// Use Case: Format time duration in various formats
/// Business Logic: Convert seconds to human-readable formats
struct FormatDurationUseCase {
    
    /// Format elapsed seconds as MM:SS
    func executeAsElapsedTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    /// Format rest duration in short format (e.g., "90s", "2m", "2m 30s")
    func executeAsRestDuration(seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds)s"
        } else if seconds % 60 == 0 {
            return "\(seconds / 60)m"
        } else {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            return "\(minutes)m \(remainingSeconds)s"
        }
    }
    
    /// Format duration in minutes (for session duration)
    func executeAsMinutes(seconds: Int) -> Int {
        seconds / 60
    }
    
    /// Format duration in long format (e.g., "1 hour 30 minutes")
    func executeAsLongFormat(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
}
