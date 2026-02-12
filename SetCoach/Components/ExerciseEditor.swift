import SwiftUI

struct ExerciseEditor: View {
    @Binding var exercise: ExerciseEdit
    let onDelete: () -> Void

    @State private var showPicker = false

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

            Button(action: { showPicker = true }) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(exercise.name.isEmpty ? "Tap to select exercise" : exercise.name)
                            .font(.system(size: 15, weight: exercise.name.isEmpty ? .regular : .semibold))
                            .foregroundColor(exercise.name.isEmpty ? Theme.muted : Theme.foreground)
                        if !exercise.name.isEmpty {
                            Text("\(exercise.targetSets) sets · \(exercise.targetRepsMin)-\(exercise.targetRepsMax) reps")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.muted)
                        }
                    }
                    Spacer()
                    Image(systemName: exercise.name.isEmpty ? "chevron.down" : "pencil")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.muted)
                }
                .padding(12)
                .background(Theme.secondary)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            exercise.name.isEmpty ? Color.clear : Theme.primary.opacity(0.4),
                            lineWidth: 1.5
                        )
                )
            }
            .sheet(isPresented: $showPicker) {
                ExercisePickerSheet(isPresented: $showPicker) { selected in
                    exercise.name = selected.name
                    exercise.targetSets = selected.defaultSets
                    exercise.targetRepsMin = selected.defaultRepsMin
                    exercise.targetRepsMax = selected.defaultRepsMax
                    exercise.notes = selected.defaultNotes ?? ""
                }
            }

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
