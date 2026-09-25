import SwiftUI

/// A flexible, text-driven alert banner for displaying inline system states using Design System tokens.
///
/// `DSInlineMessageCard` provides consistent layout for informational blocks, warnings,
/// and error feedback states inline within screens.
public struct DSInlineMessageCard<IconContent: View>: View {
    private let title: String
    private let description: String
    private let actionTitle: String?
    private let style: DSInlineMessageStyle
    private let iconContent: IconContent
    private let action: (() -> Void)?
    
    /// Initializes a new `DSInlineMessageCard`.
    /// - Parameters:
    ///   - title: The bold title text describing the event state.
    ///   - description: Main body paragraph explaining details or feedback.
    ///   - actionTitle: Optional link text to present at the bottom of the card.
    ///   - style: The custom background/border layout palette selector (.info, .warning, .error).
    ///   - iconContent: A `@ViewBuilder` slot to receive any system symbol or custom visual branding element.
    ///   - action: Triggers code completion execution asynchronously when the interactive text is tapped.
    public init(
        title: String,
        description: String,
        actionTitle: String? = nil,
        style: DSInlineMessageStyle = .info,
        @ViewBuilder iconContent: () -> IconContent,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.style = style
        self.iconContent = iconContent()
        self.action = action
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.md) {
            iconContent
                .font(DSFont.title)
                .foregroundStyle(style.titleColor)
                .frame(width: 24, alignment: .top)

            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text(title)
                    .font(DSFont.descriptionBold)
                    .foregroundStyle(style.titleColor)
                    .fixedSize(horizontal: false, vertical: true)

                Text(description)
                    .font(DSFont.inputSupport)
                    .foregroundStyle(DSColor.ink60)
                    .lineSpacing(DSPadding.xsmall)
                    .fixedSize(horizontal: false, vertical: true)

                if let actionTitle {
                    Button(action: { action?() }) {
                        Text(actionTitle)
                            .font(DSFont.fieldLabel)
                            .underline()
                            .foregroundStyle(style.actionColor)
                    }
                    .padding(.top, DSPadding.xsmall)
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(DSPadding.regular)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.control, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: DSRadius.control, style: .continuous)
                .stroke(style.borderColor, lineWidth: 1)
        )
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
    }
}
