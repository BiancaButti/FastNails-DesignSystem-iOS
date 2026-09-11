import SwiftUI
// MARK: - DSFilterChipView

/// A selectable filter chip.
///
/// `DSFilterChipView` represents a single filter option as a button with two
/// visual states:
///
/// - **Active:** uses the theme's brand color with white text.
/// - **Inactive:** uses a neutral background with primary text.
///
/// An optional SF Symbol can be displayed before the label.
///
/// ## Example
///
/// ```swift
/// DSFilterChipView(
///     label: "Mãos",
///     isActive: true
/// ) {
///     viewModel.toggleHandsFilter()
/// }
/// ```
///
/// With an icon:
///
/// ```swift
/// DSFilterChipView(
///     label: "Acessível",
///     isActive: false,
///     systemImage: "accessibility"
/// ) {
///     viewModel.toggleAccessibilityFilter()
/// }
/// ```
///
/// ## Accessibility
///
/// The chip is exposed as a button using the provided label.
///
/// When `isActive` is `true`, the `.isSelected` accessibility trait is added
/// so assistive technologies can communicate the selected state.
///
/// - Note: This view does not manage its own selected state. The caller must
///   update `isActive` after executing the action.
///
/// - SeeAlso: `DSFilterChipsSection`
/// - SeeAlso: `DSFilterChipItem`
public struct DSFilterChipView: View {

    @Environment(\.dsTheme)
    private var theme

    /// The text displayed inside the chip.
    let label: String

    /// Whether the chip is currently selected.
    let isActive: Bool

    /// An optional SF Symbol displayed before the label.
    let systemImage: String?

    /// The action executed when the chip is tapped.
    let action: () -> Void

    /// Creates a filter chip.
    ///
    /// - Parameters:
    ///   - label: The text displayed inside the chip.
    ///   - isActive: Whether the chip is currently selected.
    ///   - systemImage: An optional SF Symbol name displayed before the label.
    ///   - action: The action executed when the chip is tapped.
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
                    .font(DSFont.etiqueta)
                    .tracking(1.2)
            }
            .font(theme.feedbackFont)
            .fontWeight(isActive ? .semibold : .regular)
            .foregroundStyle(
                isActive ? .white : Color.primary
            )
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)
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
