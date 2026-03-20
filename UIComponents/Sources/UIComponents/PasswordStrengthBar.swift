import SwiftUI

// MARK: - PasswordStrength

public enum PasswordStrength: Equatable {
    case empty, weak, medium, strong

    var label: String {
        switch self {
        case .empty:  return ""
        case .weak:   return String(localized: "passwordStrengthWeak")
        case .medium: return String(localized: "passwordStrengthMedium")
        case .strong: return String(localized: "passwordStrengthStrong")
        }
    }

    var color: Color {
        switch self {
        case .empty:  return .clear
        case .weak:   return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }

    var filledBars: Int {
        switch self {
        case .empty:  return 0
        case .weak:   return 1
        case .medium: return 2
        case .strong: return 3
        }
    }
}

// MARK: - PasswordStrengthBar

public struct PasswordStrengthBar: View {

    let strength: PasswordStrength

    public init(strength: PasswordStrength) {
        self.strength = strength
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(index < strength.filledBars ? strength.color : Color(.systemGray5))
                        .frame(height: 4)
                        .animation(
                            .easeInOut(duration: 0.25).delay(Double(index) * 0.06),
                            value: strength
                        )
                }
            }
            HStack(spacing: 4) {
                Text("passwordStrengthLabel")
                    .foregroundColor(.secondary)
                Text(strength.label)
                    .foregroundColor(strength.color)
                    .fontWeight(.medium)
            }
            .font(.caption)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(String(format: String(localized: "passwordStrengthAccessibility"), strength.label))
    }
}
