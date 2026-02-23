import Foundation

@Observable
final class SessionExerciseCardViewModel {
    private(set) var exercise: WorkoutExercise

    init(exercise: WorkoutExercise) {
        self.exercise = exercise
    }

    var name: String { exercise.name }
    var sets: [ExerciseSet] { exercise.sets }
    var notes: String? { exercise.notes }
    var progressDirection: ProgressDirection? { exercise.progressDirection }
    var difficulty: Difficulty? { exercise.difficulty }
}
