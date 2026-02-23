import SwiftUI

/// Image picker for program - allows selection of built-in images or custom photos
struct ProgramImagePicker: View {
    @Binding var imageIdentifier: String?
    @Binding var customImageData: Data?
    @State private var showImageSheet = false

    var body: some View {
        VStack(spacing: 16) {
            selectedImageView

            Button(action: { showImageSheet = true }) {
                Label(
                    hasImage ? "Change Image" : "Add Image",
                    systemImage: hasImage ? "photo.badge.plus" : "photo"
                )
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.secondary)
                .foregroundColor(Theme.foreground)
                .cornerRadius(12)
            }

            if hasImage {
                Button(action: removeImage) {
                    Label("Remove Image", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.destructive.opacity(0.1))
                        .foregroundColor(Theme.destructive)
                        .cornerRadius(12)
                }
            }
        }
        .sheet(isPresented: $showImageSheet) {
            ImageSelectionSheet(
                imageIdentifier: $imageIdentifier,
                customImageData: $customImageData
            )
        }
    }

    private var hasImage: Bool {
        imageIdentifier != nil || customImageData != nil
    }

    @ViewBuilder
    private var selectedImageView: some View {
        if let customImageData, let uiImage = UIImage(data: customImageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.border, lineWidth: 2)
                )
        } else if let identifier = imageIdentifier,
                  let programImage = ProgramImage(rawValue: identifier) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(programImage.color.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: programImage.symbolName)
                    .font(.system(size: 50))
                    .foregroundColor(programImage.color)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.border, lineWidth: 2)
            )
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.secondary)
                    .frame(width: 120, height: 120)

                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(Theme.muted)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Theme.border, lineWidth: 2)
            )
        }
    }

    private func removeImage() {
        imageIdentifier = nil
        customImageData = nil
    }
}

private struct ImageSelectionSheet: View {
    @Binding var imageIdentifier: String?
    @Binding var customImageData: Data?
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Source", selection: $selectedTab) {
                    Text("Built-in").tag(0)
                    Text("Photos").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()

                TabView(selection: $selectedTab) {
                    builtInImagesView.tag(0)
                    customPhotoView.tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Select Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .background(Theme.background)
        }
    }

    private var builtInImagesView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(ProgramImage.allCases) { image in
                    Button(action: { selectBuiltInImage(image) }) {
                        VStack(spacing: 8) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(image.color.opacity(0.2))
                                    .frame(height: 80)

                                Image(systemName: image.symbolName)
                                    .font(.system(size: 35))
                                    .foregroundColor(image.color)
                            }
                            Text(image.displayName)
                                .font(.caption)
                                .foregroundColor(Theme.foreground)
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Theme.background)
    }

    private var customPhotoView: some View {
        VStack(spacing: 20) {
            Spacer()
            if let imageData = customImageData, let uiImage = UIImage(data: imageData) {
                VStack(spacing: 16) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    Button(action: { dismiss() }) {
                        Text("Use This Photo")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.primary)
                            .foregroundColor(Theme.primaryForeground)
                            .cornerRadius(12)
                    }
                }
                .padding()
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 60))
                        .foregroundColor(Theme.muted)
                    Text("Choose a photo from your library")
                        .font(.headline)
                        .foregroundColor(Theme.foreground)
                    PhotoPickerView(selectedImageData: $customImageData)
                        .padding(.horizontal)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Theme.background)
        .onChange(of: customImageData) { _, newValue in
            if newValue != nil { imageIdentifier = nil }
        }
    }

    private func selectBuiltInImage(_ image: ProgramImage) {
        imageIdentifier = image.rawValue
        customImageData = nil
        dismiss()
    }
}

#Preview {
    @Previewable @State var imageId: String? = "figure.strengthtraining.traditional"
    @Previewable @State var imageData: Data? = nil
    return ProgramImagePicker(imageIdentifier: $imageId, customImageData: $imageData)
        .padding()
}
