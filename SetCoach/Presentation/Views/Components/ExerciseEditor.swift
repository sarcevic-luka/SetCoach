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

            HStack(spacing: 8) {
                stepperView(label: "Sets", value: $exercise.targetSets, min: 1)
                    .frame(maxWidth: .infinity)
                stepperView(label: "Min Reps", value: $exercise.targetRepsMin, min: 1)
                    .frame(maxWidth: .infinity)
                stepperView(label: "Max Reps", value: $exercise.targetRepsMax, min: exercise.targetRepsMin + 1)
                    .frame(maxWidth: .infinity)
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

    private func stepperView(label: String, value: Binding<Int>, min: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Theme.muted)
            HStack(spacing: 4) {
                Button(action: {
                    if value.wrappedValue > min {
                        value.wrappedValue -= 1
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.foreground)
                        .frame(width: 28, height: 28)
                        .background(Theme.secondary)
                        .cornerRadius(6)
                }
                Text("\(value.wrappedValue)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.foreground)
                    .frame(maxWidth: .infinity)
                Button(action: { value.wrappedValue += 1 }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.foreground)
                        .frame(width: 28, height: 28)
                        .background(Theme.secondary)
                        .cornerRadius(6)
                }
            }
        }
    }
}
