import SwiftUI

// MARK: - Badge

/// A read-only badge that displays the current state of a booking.
///
/// `DSStatusBadge` is a purely informational view. It does not perform an
/// action and does not maintain a selected state. Its visual appearance is
/// derived from the provided ``DSBookingStatusBadge``.
///
/// The badge can be rendered independently or inside a ``DSStatusCard``.
/// When hosted by a status card, the card can provide a contextual appearance
/// through the `statusBadgeOnCard` environment value.
///
/// ## Example
///
/// ```swift
/// DSStatusBadge(
///     title: "Confirmed",
///     status: .confirmed
/// )
///
/// DSStatusBadge(
///     title: "Cancelled by salon",
///     status: .cancelled(by: .salon)
/// )
/// ```
///
/// ## Accessibility
///
/// The badge is exposed as a single accessibility element and uses its title
/// as the accessibility label.
///
/// The booking state is not communicated through color alone. The textual
/// title is always present, ensuring that the status remains available to
/// assistive technologies.
///
/// - Important: `DSStatusBadge` should not be used as an interactive control.
///   If the status needs to perform an action, the surrounding component
///   should provide the appropriate interaction.
public struct DSStatusBadge: View {
    /// The Design System theme used to resolve typography and status colors.
    @Environment(\.dsTheme)
    private var theme

    /// An optional contextual appearance provided by ``DSStatusCard``.
    ///
    /// When present, these colors override the status's default foreground
    /// and background colors so the badge remains legible against the card's
    /// colored surface.
    @Environment(\.statusBadgeOnCard)
    private var onCardAppearance

    /// The text displayed inside the badge.
    let title: String

    /// The booking status represented by the badge.
    ///
    /// The status determines the badge's default semantic appearance.
    let status: DSBookingStatusBadge

    /// Creates a status badge.
    ///
    /// - Parameters:
    ///   - title: The text displayed inside the badge and announced by
    ///     accessibility technologies.
    ///   - status: The booking status represented by the badge.
    public init(
        title: String,
        status: DSBookingStatusBadge
    ) {
        self.title = title
        self.status = status
    }

    public var body: some View {
        let appearance = DSStatusAppearance(
            status: status,
            theme: theme
        )

        let foreground =
            onCardAppearance?.foreground
            ?? appearance.foreground

        let background =
            onCardAppearance?.background
            ?? appearance.background

        HStack(spacing: DSSpacing.xs) {
            Circle()
                .fill(foreground)
                .frame(
                    width: DSSize.small,
                    height: DSSize.small
                )

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

/// Defines the contextual colors used by a ``DSStatusBadge`` when displayed
/// on a ``DSStatusCard``.
///
/// The status card provides this appearance when the badge needs to adapt to
/// the card's surface. The foreground color is used for both the status
/// indicator and the badge text, while the background provides the
/// corresponding tinted surface.
///
/// A standalone ``DSStatusBadge`` does not require this value and continues
/// to use the default semantic appearance resolved from its status.
struct DSStatusBadgeOnCardAppearance {

    /// The foreground color used by the badge.
    let foreground: Color

    /// The background color used by the badge.
    let background: Color
}

extension EnvironmentValues {

    /// The contextual appearance supplied by a ``DSStatusCard`` to its
    /// contained status badge.
    ///
    /// When the value is `nil`, ``DSStatusBadge`` uses its default semantic
    /// appearance based on ``DSBookingStatusBadge``.
    @Entry var statusBadgeOnCard: DSStatusBadgeOnCardAppearance? = nil
}
