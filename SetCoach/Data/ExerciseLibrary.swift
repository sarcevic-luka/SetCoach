import Foundation

enum MuscleGroup: String, CaseIterable {
    case chest = "Chest"
    case back = "Back"
    case legs = "Legs"
    case shoulders = "Shoulders"
    case arms = "Arms"
    case core = "Core"

    var icon: String {
        switch self {
        case .chest: return "lungs.fill"
        case .back: return "figure.strengthtraining.traditional"
        case .legs: return "figure.run"
        case .shoulders: return "figure.arms.open"
        case .arms: return "dumbbell.fill"
        case .core: return "figure.core.training"
        }
    }
}

struct LibraryExercise: Identifiable {
    let id = UUID()
    let name: String
    let muscleGroup: MuscleGroup
    let defaultSets: Int
    let defaultRepsMin: Int
    let defaultRepsMax: Int
    let defaultNotes: String?
}

struct ExerciseLibrary {
    static let all: [LibraryExercise] = chest + back + legs + shoulders + arms + core

    static func exercises(for group: MuscleGroup) -> [LibraryExercise] {
        all.filter { $0.muscleGroup == group }
    }

    static func search(_ query: String) -> [LibraryExercise] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return all }
        return all.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }

    // MARK: - CHEST (33 exercises)
    static let chest: [LibraryExercise] = [
        LibraryExercise(name: "Barbell Bench Press", muscleGroup: .chest, defaultSets: 4, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Incline Barbell Press", muscleGroup: .chest, defaultSets: 4, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Decline Barbell Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Dumbbell Bench Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Incline Dumbbell Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Decline Dumbbell Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Dumbbell Flyes", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Incline Dumbbell Flyes", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Cable Chest Fly", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "High Cable Fly", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Low Cable Fly", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Pec Deck Machine", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Push-Up", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Wide Grip Push-Up", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Diamond Push-Up", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Chest Dip", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Machine Chest Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Smith Machine Bench Press", muscleGroup: .chest, defaultSets: 4, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Svend Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Landmine Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Guillotine Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Floor Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Single Arm Cable Fly", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Hex Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Dumbbell Pullover", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Incline Machine Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Chest Press Machine", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Resistance Band Fly", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "TRX Push-Up", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Close Grip Bench Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Reverse Grip Bench Press", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Cable Crossover", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Archer Push-Up", muscleGroup: .chest, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
    ]

    // MARK: - BACK (35 exercises)
    static let back: [LibraryExercise] = [
        LibraryExercise(name: "Deadlift", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 8, defaultNotes: nil),
        LibraryExercise(name: "Romanian Deadlift", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Sumo Deadlift", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 8, defaultNotes: nil),
        LibraryExercise(name: "Barbell Row", muscleGroup: .back, defaultSets: 4, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Pendlay Row", muscleGroup: .back, defaultSets: 4, defaultRepsMin: 6, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "T-Bar Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Dumbbell Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Cable Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Pull-Up", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Chin-Up", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Wide Grip Pull-Up", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Lat Pulldown", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Close Grip Lat Pulldown", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Single Arm Lat Pulldown", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Face Pull", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Chest Supported Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Machine Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Seated Cable Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Meadows Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Straight Arm Pulldown", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Good Morning", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Hyperextension", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Rack Pull", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 8, defaultNotes: nil),
        LibraryExercise(name: "Block Pull", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 8, defaultNotes: nil),
        LibraryExercise(name: "Kroc Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Band Pull Apart", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 15, defaultRepsMax: 25, defaultNotes: nil),
        LibraryExercise(name: "Renegade Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Inverted Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Single Arm Cable Row", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Rope Pulldown", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Snatch Grip Deadlift", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 8, defaultNotes: nil),
        LibraryExercise(name: "Jefferson Curl", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "45-Degree Back Extension", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Superman Hold", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Muscle Up", muscleGroup: .back, defaultSets: 3, defaultRepsMin: 3, defaultRepsMax: 8, defaultNotes: nil),
    ]

    // MARK: - LEGS (37 exercises)
    static let legs: [LibraryExercise] = [
        LibraryExercise(name: "Back Squat", muscleGroup: .legs, defaultSets: 4, defaultRepsMin: 6, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Front Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Goblet Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Hack Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Bulgarian Split Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Romanian Deadlift", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Leg Press", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Leg Curl (Lying)", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Leg Curl (Seated)", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Leg Extension", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Hip Thrust", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Glute Bridge", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Calf Raise (Standing)", muscleGroup: .legs, defaultSets: 4, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Calf Raise (Seated)", muscleGroup: .legs, defaultSets: 4, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Donkey Calf Raise", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Lunge", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Walking Lunge", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Reverse Lunge", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Step Up", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Box Jump", muscleGroup: .legs, defaultSets: 4, defaultRepsMin: 5, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Sumo Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Nordic Hamstring Curl", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Good Morning", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Sissy Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Single Leg Press", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Cable Pull Through", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Pendulum Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Zercher Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Pistol Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Leg Press Calf Raise", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Hip Abduction Machine", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Hip Adduction Machine", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Kettlebell Swing", muscleGroup: .legs, defaultSets: 4, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Glute Kickback", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Single Leg Hip Thrust", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Smith Machine Squat", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Trap Bar Deadlift", muscleGroup: .legs, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 10, defaultNotes: nil),
    ]

    // MARK: - SHOULDERS (28 exercises)
    static let shoulders: [LibraryExercise] = [
        LibraryExercise(name: "Overhead Press (Barbell)", muscleGroup: .shoulders, defaultSets: 4, defaultRepsMin: 6, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Seated DB Shoulder Press", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Arnold Press", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Lateral Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Cable Lateral Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Machine Lateral Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Front Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Cable Front Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Rear Delt Fly", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Cable Rear Delt Fly", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Pec Deck Reverse Fly", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Upright Row", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Shrug", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Dumbbell Shrug", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Behind the Neck Press", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Push Press", muscleGroup: .shoulders, defaultSets: 4, defaultRepsMin: 5, defaultRepsMax: 8, defaultNotes: nil),
        LibraryExercise(name: "Landmine Press", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Z-Press", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Face Pull", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Band Pull Apart", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 15, defaultRepsMax: 25, defaultNotes: nil),
        LibraryExercise(name: "Handstand Push-Up", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Pike Push-Up", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Machine Shoulder Press", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Plate Front Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Cable Y-Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Single Arm DB Press", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Leaning Lateral Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Prone Y-T-W Raise", muscleGroup: .shoulders, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
    ]

    // MARK: - ARMS (35 exercises)
    static let arms: [LibraryExercise] = [
        LibraryExercise(name: "Barbell Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "EZ-Bar Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Dumbbell Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Hammer Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Incline Dumbbell Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Concentration Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Preacher Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Cable Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Reverse Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Spider Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Zottman Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Incline Cable Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Tricep Pushdown", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Overhead Tricep Extension", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Skull Crusher", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Close Grip Bench Press", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 6, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Tricep Dip", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Diamond Push-Up", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Kickback", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "JM Press", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Tate Press", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Cable Overhead Extension", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Wrist Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Reverse Wrist Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Farmer Carry", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 1, defaultRepsMax: 1, defaultNotes: "Time-based"),
        LibraryExercise(name: "21s Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 7, defaultRepsMax: 7, defaultNotes: nil),
        LibraryExercise(name: "Cross Body Hammer Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Machine Preacher Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Machine Tricep Dip", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Single Arm Pushdown", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Rope Pushdown", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Bench Dip", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Cable Hammer Curl", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Overhead DB Tricep Ext", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Bar Tricep Pushdown", muscleGroup: .arms, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
    ]

    // MARK: - CORE (32 exercises)
    static let core: [LibraryExercise] = [
        LibraryExercise(name: "Plank", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 30, defaultRepsMax: 60, defaultNotes: "Seconds"),
        LibraryExercise(name: "Side Plank", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 20, defaultRepsMax: 45, defaultNotes: "Seconds each side"),
        LibraryExercise(name: "Crunch", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 15, defaultRepsMax: 25, defaultNotes: nil),
        LibraryExercise(name: "Reverse Crunch", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Cable Crunch", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Ab Wheel Rollout", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Hanging Leg Raise", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Hanging Knee Raise", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "L-Sit Hold", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 15, defaultRepsMax: 45, defaultNotes: "Seconds"),
        LibraryExercise(name: "Dragon Flag", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 10, defaultNotes: nil),
        LibraryExercise(name: "Bicycle Crunch", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 15, defaultRepsMax: 25, defaultNotes: nil),
        LibraryExercise(name: "Russian Twist", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Woodchop", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Pallof Press", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Dead Bug", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Bird Dog", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Hollow Body Hold", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 20, defaultRepsMax: 45, defaultNotes: "Seconds"),
        LibraryExercise(name: "GHD Sit-Up", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Decline Sit-Up", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Toe to Bar", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Ab Machine Crunch", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Sit-Up", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 15, defaultRepsMax: 25, defaultNotes: nil),
        LibraryExercise(name: "Suitcase Carry", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 1, defaultRepsMax: 1, defaultNotes: "Time-based"),
        LibraryExercise(name: "Suitcase Deadlift", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Landmine Rotation", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Copenhagen Plank", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 15, defaultRepsMax: 30, defaultNotes: "Seconds each side"),
        LibraryExercise(name: "Stir the Pot", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 8, defaultRepsMax: 12, defaultNotes: nil),
        LibraryExercise(name: "Cable Oblique Crunch", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 12, defaultRepsMax: 20, defaultNotes: nil),
        LibraryExercise(name: "Turkish Get-Up", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 5, defaultRepsMax: 8, defaultNotes: nil),
        LibraryExercise(name: "Weighted Plank", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 30, defaultRepsMax: 60, defaultNotes: "Seconds"),
        LibraryExercise(name: "V-Up", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 15, defaultNotes: nil),
        LibraryExercise(name: "Mountain Climber", muscleGroup: .core, defaultSets: 3, defaultRepsMin: 10, defaultRepsMax: 20, defaultNotes: nil),
    ]
}
