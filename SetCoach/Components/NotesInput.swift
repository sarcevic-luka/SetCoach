import SwiftUI

struct NotesInput: View {
    @Binding var notes: String?
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Theme.muted)
            TextEditor(text: Binding(
                get: { notes ?? "" },
                set: { notes = $0.isEmpty ? nil : $0 }
            ))
            .font(.system(size: 14))
            .foregroundColor(Theme.foreground)
            .frame(height: 60)
            .padding(8)
            .background(Theme.secondary)
            .cornerRadius(8)
            .focused($isFocused)
        }
    }
}
