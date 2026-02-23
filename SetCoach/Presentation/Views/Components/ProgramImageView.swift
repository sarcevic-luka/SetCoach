import SwiftUI

/// Displays program image - either built-in icon or custom photo
struct ProgramImageView: View {
    let program: Program
    var size: CGFloat = 60
    var cornerRadius: CGFloat = 12

    var body: some View {
        Group {
            if let customImageData = program.customImageData,
               let uiImage = UIImage(data: customImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else if let identifier = program.imageIdentifier,
                      let programImage = ProgramImage(rawValue: identifier) {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(programImage.color.opacity(0.2))

                    Image(systemName: programImage.symbolName)
                        .font(.system(size: size * 0.5))
                        .foregroundColor(programImage.color)
                }
                .frame(width: size, height: size)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Theme.secondary)

                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: size * 0.4))
                        .foregroundColor(Theme.muted)
                }
                .frame(width: size, height: size)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgramImageView(
            program: Program(
                name: "Strength",
                imageIdentifier: "figure.strengthtraining.traditional"
            ),
            size: 80
        )
        ProgramImageView(program: Program(name: "Test"), size: 80)
    }
    .padding()
}
