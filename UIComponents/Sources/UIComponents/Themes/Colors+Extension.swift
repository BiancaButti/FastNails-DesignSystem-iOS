import SwiftUI

// MARK: - Background - Filter Chip
public extension Color {
    // Chip background colors
    public static let neutralBg = Color(hex: "F0EDF1")
    public static let confirmedBg = Color(hex: "E1F2ED")
    public static let inProgressBg = Color(hex: "FDF1DC")
    public static let canceledBg = Color(hex: "FCE3E3")
    
    // Corresponding text colors (for good contrast)
    public static let neutralText = Color(hex: "78727D")
    public static let confirmedText = Color(hex: "3B7A6A")
    public static let inProgressText = Color(hex: "825E1A")
    public static let canceledText = Color(hex: "A63232")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 1)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
