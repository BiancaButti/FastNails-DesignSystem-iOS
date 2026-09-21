import SwiftUI

/// A flexible, text-driven alert banner for displaying inline system states using Design System tokens.
///
/// `DSInlineMessageCard` provides consistent layout for informational blocks, warnings,
/// and error feedback states inline within screens.
public struct DSInlineMessageCard<IconContent: View>: View {
    private let title: String
    private let description: String
    private let actionTitle: String?
    private let style: DSInlineAlertStyle
    private let iconContent: IconContent
    private let action: (() -> Void)?
    
    /// Initializes a new `DSInlineAlertCard`.
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
        style: DSInlineAlertStyle = .info,
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
        HStack(alignment: .top, spacing: 14) {
            iconContent
                .font(.system(size: 20))
                .foregroundColor(style.titleColor)
                .frame(width: 24, alignment: .top)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(style.titleColor)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(Color.ink60)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let actionTitle = actionTitle {
                    Button(action: { action?() }) {
                        Text(actionTitle)
                            .font(.system(size: 14, weight: .semibold))
                            .underline()
                            .foregroundColor(style.actionColor)
                    }
                    .padding(.top, 4)
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(style.backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style.borderColor, lineWidth: 1)
        )
    }
}
