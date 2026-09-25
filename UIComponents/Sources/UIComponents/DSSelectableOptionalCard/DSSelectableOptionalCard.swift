import SwiftUI

// MARK: - Model

/// A single selectable option displayed by ``DSSelectableOptionList``.
///
/// Each option carries a stable identity plus the title and description shown
/// on its card.
///
/// - Important: The `id` is supplied by the caller so it stays stable across
///   list rebuilds. Using a freshly generated value such as `UUID()` as a
///   default would create a new identity on every initialization and break
///   SwiftUI's diffing and animation.
///
/// ## Example
///
/// ```swift
/// let option = SelectableOption(
///     id: "hands",
///     title: "Hands",
///     description: "Manicure, from 30 min"
/// )
/// ```
///
/// - SeeAlso: `DSSelectableOptionList`
public struct SelectableOption: Identifiable, Hashable {

    /// The stable identifier used by SwiftUI to track the option.
    public let id: String

    /// The option's title, displayed as the primary text on the card.
    public let title: String

    /// The option's description, displayed as supporting text below the title.
    public let description: String

    /// Creates a selectable option.
    ///
    /// - Parameters:
    ///   - id: A stable identifier that persists across list rebuilds.
    ///   - title: The primary text shown on the card.
    ///   - description: The supporting text shown below the title.
    public init(id: String, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}



// MARK: - Card

/// A single multiple-choice card with a checkbox indicator.
///
/// `DSSelectableCheckboxCard` renders one ``SelectableOption`` as a tappable
/// card showing a checkbox, a title, and a description. It is a stateless view:
/// it reflects the `isSelected` flag and reports taps through `onToggle`,
/// leaving selection state to its owner (typically ``DSSelectableOptionList``).
///
/// The appearance for each state is provided by `DSSelectableOptionCardPalette`,
/// which keeps the surface and its content colors in sync.
///
/// - Important: No SwiftUI semantic color is used here. Because `DSTheme` has a
///   single palette, `.primary`, `.secondary` and `Color(.systemBackground)`
///   would flip in the system's dark mode while the tokens stayed put —
///   resulting in light text over a light card. The app root also needs
///   `.preferredColorScheme(.light)` so that sheets and alerts follow along.
///
/// ## Accessibility
///
/// The card is a single button whose label combines the title and description,
/// and whose value announces the selected state. The checkbox indicator is
/// hidden from assistive technologies to avoid redundant announcements.
///
/// - SeeAlso: ``SelectableOption``
/// - SeeAlso: `DSSelectableOptionList`
struct DSSelectableCheckboxCard: View {
    @Environment(\.dsTheme)
    private var theme
    /// The size of the checkbox indicator, following Dynamic Type along with
    /// the text.
    @ScaledMetric(relativeTo: .body)
    private var boxSize: CGFloat = 22

    /// Whether the system's Reduce Motion setting is enabled, used to skip the
    /// selection animation.
    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    /// The option rendered by the card.
    let option: SelectableOption

    /// Whether the card is currently selected.
    let isSelected: Bool

    /// The action performed when the card is tapped.
    let onToggle: () -> Void

    private let boxRadius: CGFloat = 4

    private var palette: DSSelectableOptionCardPalette { isSelected ? .selected : .idle }

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 8) {
                checkbox
                    .padding(.top, DSPadding.xsmall)

                VStack(alignment: .leading, spacing: 8) {
                    Text(option.title)
                        .font(DSFont.caption)
                        .minimumScaleFactor(0.8)

                    Text(option.description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(palette.subtitle)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, DSPadding.medium)
            .padding(.horizontal, DSPadding.medium)
            .background(palette.surface)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: DSRadius.control,
                    style: .continuous))
            .overlay(
                RoundedRectangle(
                    cornerRadius: DSRadius.control,
                    style: .continuous)
                    .strokeBorder(palette.border, lineWidth: palette.borderWidth)
            )
            .contentShape(
                RoundedRectangle(
                    cornerRadius: DSRadius.control,
                    style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.15), value: isSelected)
        .accessibilityLabel("\(option.title), \(option.description)")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }

    private var checkbox: some View {
        RoundedRectangle(
            cornerRadius: DSRadius.xsmall,
            style: .continuous)
            .fill(palette.box)
            .overlay(
                RoundedRectangle(
                    cornerRadius: DSRadius.xsmall,
                    style: .continuous)
                    .strokeBorder(palette.boxBorder, lineWidth: 2)
            )
            .overlay {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: boxSize * 0.52, weight: .bold))
                        .foregroundStyle(palette.check)
                }
            }
            .frame(width: boxSize, height: boxSize)
            .accessibilityHidden(true)
    }
}
