import SwiftUI
// MARK: - Badge
 
/// A read-only badge showing the state of a booking.
///
/// This is **not** a control. It has no action and no selected state; it only
/// reflects the current `DSBookingStatus`.
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
    let status: DSBookingStatus
 
    @Environment(\.dsTheme) private var theme
 
    public init(
        title: String,
        status: DSBookingStatus) {
        self.title = title
        self.status = status
    }
 
    public var body: some View {
        let appearance = DSStatusAppearance(status: status, theme: theme)
 
        HStack(spacing: DSSpacing.xs) {
            Circle()
                .fill(appearance.foreground)
                .frame(width: 6, height: 6)
 
            Text(title)
        }
        .font(theme.badgeFont)
        .foregroundStyle(appearance.foreground)
        .padding(.horizontal, DSSpacing.md)
        .padding(.vertical, DSSpacing.sm)
        .background(appearance.background)
        .clipShape(Capsule())
        // One element, not a dot plus a label.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
    }
}
