import SwiftUI
import PhotosUI

/// Photo picker for selecting images from user's photo library
struct PhotoPickerView: View {
    @Binding var selectedImageData: Data?
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Label("Choose from Photos", systemImage: "photo.on.rectangle")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.secondary)
                .foregroundColor(Theme.foreground)
                .cornerRadius(12)
        }
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }
}
