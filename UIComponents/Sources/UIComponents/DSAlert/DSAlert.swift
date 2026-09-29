import SwiftUI

// MARK: - DSAlert

/// Displays a modal dialog for confirmations and potentially destructive actions.
///
/// Use `DSAlert` when the user needs to review a message and choose between two actions.
/// The secondary action can be styled as destructive to highlight consequences such as deletion or logout.
///
/// ```swift
/// DSAlert(
///     title: "Log out?",
///     message: "You will need to sign in again to access your account.",
///     primaryButtonTitle: "Cancel",
///     secondaryButtonTitle: "Log Out",
///     primaryAction: { },
///     secondaryAction: { }
/// )
/// ```
public struct DSAlert: View {
    /// The main headline displayed at the top of the alert.
    let title: String

    /// The message describing the action or its consequences.
    let message: String

    /// The title displayed by the primary action button.
    let primaryButtonTitle: String

    /// The title displayed by the secondary action button.
    let secondaryButtonTitle: String

    /// A Boolean value that determines whether the secondary action uses the destructive style.
    ///
    /// Defaults to `true`.
    let isSecondaryDestructive: Bool

    /// The closure executed when the primary button is tapped.
    let primaryAction: () -> Void

    /// The closure executed when the secondary button is tapped.
    let secondaryAction: () -> Void

    /// Creates a `DSAlert`.
    /// - Parameters:
    ///   - title: The main headline displayed at the top of the alert.
    ///   - message: The message describing the action or its consequences.
    ///   - primaryButtonTitle: The title displayed by the primary action button.
    ///   - secondaryButtonTitle: The title displayed by the secondary action button.
    ///   - isSecondaryDestructive: Whether the secondary action uses the destructive style. Defaults to `true`.
    ///   - primaryAction: The closure executed when the primary button is tapped.
    ///   - secondaryAction: The closure executed when the secondary button is tapped.
    public init(
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String,
        isSecondaryDestructive: Bool = true,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.isSecondaryDestructive = isSecondaryDestructive
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: DSSpacing.md) {
                Text(title)
                    .font(DSFont.sectionHeader)
                    .foregroundColor(DSColor.ink)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(DSFont.fieldLabel)
                    .foregroundColor(DSColor.ink60)
                    .multilineTextAlignment(.center)
                    .lineSpacing(DSSpacing.xs)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, DSPadding.large)
            .padding(.horizontal, DSPadding.large)
            .padding(.bottom, DSPadding.large)

            DSColor.line
                .frame(height: 1)

            HStack(spacing: .zero) {
                Button(action: primaryAction) {
                    Text(primaryButtonTitle)
                        .font(DSFont.descriptionBold)
                        .foregroundColor(DSColor.ink)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)

                DSColor.line
                    .frame(width: 1)

                Button(action: secondaryAction) {
                    Text(secondaryButtonTitle)
                        .font(isSecondaryDestructive ? DSFont.description : DSFont.descriptionBold)
                        .foregroundColor(isSecondaryDestructive ? DSColor.alert : DSColor.enamel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
            }
            .frame(height: DSSize.xhuge)
        }
        .frame(width: DSSize.containerSmall)
        .background(DSColor.paper)
        .clipShape(
            RoundedRectangle(
                cornerRadius: DSRadius.mediumHuge,
                style: .continuous
            )
        )
        .shadow(
            color: DSColor.ink.opacity(0.15),
            radius: DSRadius.large,
            x: .zero,
            y: 8
        )
    }
}
