import SwiftUI

struct ExerciseEditor: View {
    @Binding var exercise: ExerciseEdit
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(Theme.muted)
                    .frame(width: 20)
                Text("Exercise")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Theme.muted)
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.destructive)
                        .font(.system(size: 20))
                }
            }

            TextField("Exercise name", text: $exercise.name)
                .font(.system(size: 14))
                .foregroundColor(Theme.foreground)
                .padding(10)
                .background(Theme.secondary)
                .cornerRadius(8)

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sets")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.muted)
                    HStack {
                        Button(action: {
                            if exercise.targetSets > 1 {
                                exercise.targetSets -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.foreground)
                                .frame(width: 32, height: 32)
                                .background(Theme.secondary)
                                .cornerRadius(6)
                        }
                        Text("\(exercise.targetSets)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.foreground)
                            .frame(width: 40)
                        Button(action: { exercise.targetSets += 1 }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.foreground)
                                .frame(width: 32, height: 32)
                                .background(Theme.secondary)
                                .cornerRadius(6)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Min Reps")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.muted)
                    HStack {
                        Button(action: {
                            if exercise.targetRepsMin > 1 {
                                exercise.targetRepsMin -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.foreground)
                                .frame(width: 32, height: 32)
                                .background(Theme.secondary)
                                .cornerRadius(6)
                        }
                        Text("\(exercise.targetRepsMin)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.foreground)
                            .frame(width: 40)
                        Button(action: { exercise.targetRepsMin += 1 }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.foreground)
                                .frame(width: 32, height: 32)
                                .background(Theme.secondary)
                                .cornerRadius(6)
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Max Reps")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.muted)
                    HStack {
                        Button(action: {
                            if exercise.targetRepsMax > exercise.targetRepsMin {
                                exercise.targetRepsMax -= 1
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.foreground)
                                .frame(width: 32, height: 32)
                                .background(Theme.secondary)
                                .cornerRadius(6)
                        }
                        Text("\(exercise.targetRepsMax)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.foreground)
                            .frame(width: 40)
                        Button(action: { exercise.targetRepsMax += 1 }) {
                            Image(systemName: "plus")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.foreground)
                                .frame(width: 32, height: 32)
                                .background(Theme.secondary)
                                .cornerRadius(6)
                        }
                    }
                }
            }

            TextField("Notes (optional)", text: $exercise.notes)
                .font(.system(size: 12))
                .foregroundColor(Theme.muted)
                .padding(8)
                .background(Theme.secondary)
                .cornerRadius(6)
        }
        .padding(12)
        .background(Theme.secondary.opacity(0.5))
        .cornerRadius(8)
    }
}
