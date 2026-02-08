import SwiftUI
import SwiftData

@main
struct SetCoachApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Program.self,
            TrainingDay.self,
            ExerciseTemplate.self,
            WorkoutSession.self,
            WorkoutExercise.self,
            ExerciseSet.self
        ])
    }
}
