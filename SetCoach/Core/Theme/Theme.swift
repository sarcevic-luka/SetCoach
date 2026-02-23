import SwiftUI

struct Theme {
    // Colors - Dark Mode
    static let background = Color(hex: "0a0a0c")
    static let foreground = Color(hex: "fafafa")
    static let card = Color(hex: "18181b")
    static let cardForeground = Color(hex: "fafafa")
    static let primary = Color(hex: "22c55e") // Green
    static let primaryForeground = Color(hex: "0d0d0d")
    static let secondary = Color(hex: "27272a")
    static let secondaryForeground = Color(hex: "fafafa")
    static let muted = Color(hex: "a1a1aa")
    static let destructive = Color(hex: "ef4444") // Red
    static let border = Color(hex: "27272a")
    static let blue = Color(hex: "0ea5e9")

    // Corner Radius
    static let cornerRadius: CGFloat = 12

    // Touch Targets (Apple HIG)
    static let minTouchTarget: CGFloat = 44
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000ff) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
