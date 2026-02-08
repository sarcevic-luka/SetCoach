import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        HomeScreen()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Program.self, TrainingDay.self, ExerciseTemplate.self, WorkoutSession.self, WorkoutExercise.self, ExerciseSet.self], inMemory: true)
}
