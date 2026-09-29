import SwiftUI

// MARK: - DSInlineMessageCard

/// Displays an inline message with an icon, contextual text, and an optional action.
///
/// Use `DSInlineMessageCard` to communicate informational, warning, or error states within a screen.
/// The visual treatment is determined by `DSInlineMessageStyle`, while the icon and optional action remain customizable.
///
/// ```swift
/// DSInlineMessageCard(
///     title: "Payment pending",
///     description: "Your payment is still being processed.",
///     style: .info,
///     iconContent: {
///         Image(systemName: "info.circle")
///     }
/// )
/// ```
///
/// ## Accessibility
/// The message contents are exposed as contained accessibility elements, including the optional action.
public struct DSInlineMessageCard<IconContent: View>: View {
    /// The title displayed at the top of the message.
    private let title: String

    /// The descriptive text displayed below the title.
    private let description: String

    /// The optional action title displayed below the message description.
    private let actionTitle: String?

    /// The visual style that determines the card's colors and semantic appearance.
    private let style: DSInlineMessageStyle

    /// The custom view displayed alongside the message content as its leading icon.
    @ViewBuilder private let iconContent: IconContent

    /// The optional closure executed when the action is activated.
    private let action: (() -> Void)?

    /// Creates a `DSInlineMessageCard`.
    /// - Parameters:
    ///   - title: The title displayed at the top of the message.
    ///   - description: The descriptive text displayed below the title.
    ///   - actionTitle: The optional text displayed for the message action. Defaults to `nil`.
    ///   - style: The visual style that determines the card's semantic appearance. Defaults to `.info`.
    ///   - iconContent: A view builder that provides the leading icon or custom visual content.
    ///   - action: An optional closure executed when the action is activated. Defaults to `nil`.
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
                .frame(
                    width: DSSize.large,
                    alignment: .top
                )

            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Text(title)
                    .font(DSFont.descriptionBold)
                    .foregroundStyle(style.titleColor)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                Text(description)
                    .font(DSFont.inputSupport)
                    .foregroundStyle(DSColor.ink60)
                    .lineSpacing(DSPadding.xsmall)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )

                if let actionTitle {
                    Button(action: {
                        action?()
                    }) {
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
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(style.backgroundColor)
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.control,
                style: .continuous
            )
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: DSRadius.control,
                style: .continuous
            )
            .stroke(
                style.borderColor,
                lineWidth: 1
            )
        )
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
    }
}
