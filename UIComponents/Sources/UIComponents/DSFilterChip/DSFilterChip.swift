import SwiftUI

// MARK: - DSFilterChipView

/// Displays a selectable filter option as a compact chip.
///
/// Use `DSFilterChipView` for filters that can be toggled independently.
/// The chip changes its visual treatment according to `isActive` and can optionally display an SF Symbol before its label.
///
/// ```swift
/// DSFilterChipView(
///     label: "Mãos",
///     isActive: true
/// ) {
///     toggleHandsFilter()
/// }
/// ```
///
/// ## Accessibility
/// Exposes the chip as a button and adds the `.isSelected` trait when `isActive` is `true`.
public struct DSFilterChipView: View {
    @Environment(\.dsTheme)
    private var theme

    /// The text displayed inside the chip.
    let label: String

    /// A Boolean value indicating whether the filter is currently selected.
    let isActive: Bool

    /// The optional SF Symbol name displayed before the label.
    let systemImage: String?

    /// The closure executed when the chip is tapped.
    let action: () -> Void

    /// Creates a `DSFilterChipView`.
    /// - Parameters:
    ///   - label: The text displayed inside the chip.
    ///   - isActive: Whether the filter is currently selected.
    ///   - systemImage: An optional SF Symbol name displayed before the label. Defaults to `nil`.
    ///   - action: The closure executed when the chip is tapped.
    public init(
        label: String,
        isActive: Bool,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.isActive = isActive
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.xs) {
                if let systemImage {
                    Image(systemName: systemImage)
                }

                Text(label)
                    .font(DSFont.technicalTag)
                    .tracking(DSTracking.upperTag)
            }
            .font(theme.feedbackFont)
            .fontWeight(isActive ? .semibold : .regular)
            .foregroundStyle(
                isActive ? .white : Color.primary
            )
            .padding(.horizontal, DSPadding.medium)
            .padding(.vertical, DSPadding.small)
            .background(
                isActive
                    ? theme.brandColor
                    : Color(.systemGray6)
            )
            .clipShape(Capsule())
        }
        .accessibilityLabel(label)
        .accessibilityAddTraits(
            isActive ? [.isSelected] : []
        )
        .animation(
            .easeInOut(duration: 0.15),
            value: isActive
        )
    }
}
