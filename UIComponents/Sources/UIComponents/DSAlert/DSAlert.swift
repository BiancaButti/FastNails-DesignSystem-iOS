import SwiftUI

// MARK: - DSAlert

/// A custom structural modal dialog overlay used for critical user confirmations,
/// such as logging out or destructive actions.
///
/// It layers a white container (`Color.paper`) over a dimmed background, featuring
/// a semantic line divider configuration to isolate choice boundaries.
public struct DSAlert: View {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    let isSecondaryDestructive: Bool
    let primaryAction: () -> Void
    let secondaryAction: () -> Void

    /// Creates a `DSAlert`.
    /// - Parameters:
    ///   - title: The main bold headline text.
    ///   - message: The body text explaining the consequence.
    ///   - primaryButtonTitle: The text for the main/neutral button (e.g., "Cancelar").
    ///   - secondaryButtonTitle: The text for the confirm/action button (e.g., "Sair").
    ///   - isSecondaryDestructive: When `true`, paints the secondary text with `Color.alert` (default `true`).
    ///   - primaryAction: Closure to run when the primary button is tapped.
    ///   - secondaryAction: Closure to run when the secondary button is tapped.
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
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text(title)
                    .font(DSFont.sectionHeader)
                    .foregroundColor(DSColor.ink)
                    .multilineTextAlignment(.center)
                
                Text(message)
                    .font(DSFont.fieldLabel)
                    .foregroundColor(DSColor.ink60)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            
            DSColor.line
                .frame(height: 1)
            
            HStack(spacing: 0) {
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
                        .font(.body)
                        .font(isSecondaryDestructive ? DSFont.description : DSFont.descriptionBold)
                        .foregroundColor(isSecondaryDestructive ? DSColor.alert : DSColor.enamel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .buttonStyle(.plain)
            }
            .frame(height: 52)
        }
        .frame(width: 290)
        .background(DSColor.paper)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: DSColor.ink.opacity(0.15),
                radius: 16, x: 0, y: 8)
    }
}
