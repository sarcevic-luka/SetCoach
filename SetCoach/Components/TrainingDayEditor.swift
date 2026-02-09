import SwiftUI

struct TrainingDayEditor: View {
    @Binding var trainingDay: TrainingDayEdit
    let onDelete: () -> Void

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Training Day Name")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.muted)
                        TextField("e.g., Push Day", text: $trainingDay.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.foreground)
                            .padding(12)
                            .background(Theme.secondary)
                            .cornerRadius(8)
                    }
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(Theme.destructive)
                            .frame(width: 44, height: 44)
                    }
                }

                Rectangle()
                    .fill(Theme.border)
                    .frame(height: 1)

                VStack(alignment: .leading, spacing: 12) {
                    Text("EXERCISES")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.muted)
                    ForEach(trainingDay.exercises.indices, id: \.self) { index in
                        ExerciseEditor(
                            exercise: $trainingDay.exercises[index],
                            onDelete: {
                                trainingDay.exercises.removeAll { $0.id == trainingDay.exercises[index].id }
                            }
                        )
                    }
                    Button(action: {
                        trainingDay.exercises.append(ExerciseEdit(id: UUID().uuidString))
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Exercise")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(Theme.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Theme.secondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Theme.primary, style: StrokeStyle(lineWidth: 1, dash: [5]))
                        )
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}
