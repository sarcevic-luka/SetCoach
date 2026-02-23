import SwiftUI
import SwiftData

@main
struct SetCoachApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            ProgramModel.self,
            TrainingDayModel.self,
            ExerciseTemplateModel.self,
            WorkoutSessionModel.self,
            WorkoutExerciseModel.self,
            ExerciseSetModel.self
        ])
    }
}
