import SwiftUI
// MARK: - Badge
 
/// A read-only badge showing the state of a booking.
///
/// This is **not** a control. It has no action and no selected state; it only
/// reflects the current `DSBookingStatusBadge`.
///
/// ```swift
/// DSStatusBadge(title: "Confirmed", status: .confirmed)
/// DSStatusBadge(title: "Cancelled by salon", status: .cancelled(by: .salon))
/// ```
///
/// ## Accessibility
/// The badge is a single element with the status spelled out. Colour never
/// carries the state on its own — the text is always present.
public struct DSStatusBadge: View {
 
    let title: String
    let status: DSBookingStatusBadge

    @Environment(\.dsTheme) private var theme

    /// When set (by a host ``DSStatusCard``), the badge drops its semantic
    /// colors in favor of these, so it stays legible on the card's colored
    /// surface instead of blending into it.
    @Environment(\.statusBadgeOnCard) private var onCardAppearance

    public init(
        title: String,
        status: DSBookingStatusBadge) {
        self.title = title
        self.status = status
    }

    public var body: some View {
        let appearance = DSStatusAppearance(status: status, theme: theme)
        let foreground = onCardAppearance?.foreground ?? appearance.foreground
        let background = onCardAppearance?.background ?? appearance.background

        HStack(spacing: DSSpacing.xs) {
            Circle()
                .fill(foreground)
                .frame(width: DSSize.small,
                       height: DSSize.small)

            Text(title)
        }
        .font(theme.badgeFont)
        .foregroundStyle(foreground)
        .padding(.horizontal, DSPadding.medium)
        .padding(.vertical, DSPadding.small)
        .background(background)
        .clipShape(Capsule())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
    }
}

// MARK: - On-card appearance

/// The colors a ``DSStatusBadge`` uses when it sits on a ``DSStatusCard``.
///
/// The card fills this from its own palette so the badge borrows the same
/// legible text color and a translucent tint of it for the background.
struct DSStatusBadgeOnCardAppearance {
    let foreground: Color
    let background: Color
}

extension EnvironmentValues {
    /// Set by a ``DSStatusCard`` on its status badge; `nil` everywhere else, so
    /// a standalone ``DSStatusBadge`` keeps its default semantic appearance.
    @Entry var statusBadgeOnCard: DSStatusBadgeOnCardAppearance? = nil
}
