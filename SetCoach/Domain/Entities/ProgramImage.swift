import SwiftUI

/// Built-in program images that users can choose from
enum ProgramImage: String, CaseIterable, Identifiable {
    case strength = "figure.strengthtraining.traditional"
    case cardio = "figure.run"
    case yoga = "figure.yoga"
    case cycling = "figure.indoor.cycle"
    case swimming = "figure.pool.swim"
    case boxing = "figure.boxing"
    case climbing = "figure.climbing"
    case hiking = "figure.hiking"
    case dumbbell = "dumbbell.fill"
    case heart = "heart.fill"
    case flame = "flame.fill"
    case bolt = "bolt.fill"
    case star = "star.fill"
    case trophy = "trophy.fill"
    case target = "target"
    case timer = "timer"

    var id: String { rawValue }

    /// SF Symbol name
    var symbolName: String {
        rawValue
    }

    /// Display name for the image
    var displayName: String {
        switch self {
        case .strength: return "Strength"
        case .cardio: return "Cardio"
        case .yoga: return "Yoga"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .boxing: return "Boxing"
        case .climbing: return "Climbing"
        case .hiking: return "Hiking"
        case .dumbbell: return "Dumbbell"
        case .heart: return "Heart"
        case .flame: return "Flame"
        case .bolt: return "Energy"
        case .star: return "Star"
        case .trophy: return "Trophy"
        case .target: return "Target"
        case .timer: return "Timer"
        }
    }

    /// Color associated with the image
    var color: Color {
        switch self {
        case .strength: return .blue
        case .cardio: return .red
        case .yoga: return .purple
        case .cycling: return .green
        case .swimming: return .cyan
        case .boxing: return .orange
        case .climbing: return .brown
        case .hiking: return .teal
        case .dumbbell: return .indigo
        case .heart: return .pink
        case .flame: return .orange
        case .bolt: return .yellow
        case .star: return .yellow
        case .trophy: return .yellow
        case .target: return .red
        case .timer: return .blue
        }
    }
}
