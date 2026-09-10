import SwiftUI

/// Design system button.
///
/// Appearance comes from `DSButtonAppearance` — this view only lays out.
public struct DSButton: View {
    @Environment(\.dsTheme) private var theme
    let title: String
    var style: DSButtonStyle = .primary
    var tone: DSButtonTone = .brand
    var isLoading: Bool = false
    var isEnabled: Bool = false
    var accessibilityHint: String?
    let action: () -> Void

    public init(
        title: String,
        style: DSButtonStyle = .primary,
        tone: DSButtonTone = .brand,
        isLoading: Bool = false,
        isEnabled: Bool = false,
        accessibilityHint: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.tone = tone
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.accessibilityHint = accessibilityHint
        self.action = action
    }

    public var body: some View {
        let appearance = DSButtonAppearance(style: style, tone: tone, theme: theme)
        let disabledFill = theme.secondaryColor.opacity(0.35)
        let background = !isEnabled
            ? disabledFill
            : (isLoading ? appearance.background.opacity(0.6) : appearance.background)
        let borderColor: Color? = !isEnabled
            ? nil
            : appearance.borderColor.map { isLoading ? $0.opacity(0.6) : $0 }
        let textColor = isEnabled ? appearance.textColor : theme.titleColor.opacity(0.45)

        Button(action: action) {
            Text(title)
            .font(theme.buttonFont)
            .foregroundStyle(textColor)
            .frame(maxWidth: style == .tertiary ? nil : .infinity)
            .frame(minHeight: 48)
            .padding(.horizontal, DSSpacing.lg)
            .background(background)
            .overlay {
                if let borderColor {
                    RoundedRectangle(cornerRadius: DSRadius.controle)
                        .strokeBorder(borderColor, lineWidth: 1.5)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.controle))
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .accessibilityLabel(title)
        .modifier(OptionalAccessibilityHint(hint: accessibilityHint))
    }
}

// MARK: - Helper

private struct OptionalAccessibilityHint: ViewModifier {
    let hint: String?

    func body(content: Content) -> some View {
        if let hint {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}



