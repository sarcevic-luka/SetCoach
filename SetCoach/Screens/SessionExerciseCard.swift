import SwiftUI

struct SessionExerciseCard: View {
    @StateObject private var viewModel: SessionExerciseCardViewModel

    init(exercise: WorkoutExercise) {
        _viewModel = StateObject(wrappedValue: SessionExerciseCardViewModel(exercise: exercise))
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(viewModel.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.foreground)
                    Spacer()
                    HStack(spacing: 8) {
                        if let progress = viewModel.progressDirection {
                            ProgressArrow(direction: progress)
                        }
                        if let difficulty = viewModel.difficulty {
                            DifficultyBadge(difficulty: difficulty)
                        }
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.muted)
                    }
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.sets, id: \.setNumber) { set in
                            SetChip(weight: set.weight, reps: set.reps)
                        }
                    }
                }

                if let notes = viewModel.notes, !notes.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "text.bubble")
                            .font(.system(size: 12))
                        Text(notes)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Theme.muted)
                }
            }
        }
    }
}
