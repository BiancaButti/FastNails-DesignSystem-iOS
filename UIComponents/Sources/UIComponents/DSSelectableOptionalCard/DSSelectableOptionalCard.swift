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
///     titulo: "Hands",
///     descricao: "Manicure, from 30 min"
/// )
/// ```
///
/// - SeeAlso: `DSSelectableOptionList`
public struct SelectableOption: Identifiable, Hashable {

    /// The stable identifier used by SwiftUI to track the option.
    public let id: String

    /// The option's title, displayed as the primary text on the card.
    public let titulo: String

    /// The option's description, displayed as supporting text below the title.
    public let descricao: String

    /// Creates a selectable option.
    ///
    /// - Parameters:
    ///   - id: A stable identifier that persists across list rebuilds.
    ///   - titulo: The primary text shown on the card.
    ///   - descricao: The supporting text shown below the title.
    public init(id: String, titulo: String, descricao: String) {
        self.id = id
        self.titulo = titulo
        self.descricao = descricao
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

    private let cardRadius: CGFloat = 12
    private let boxRadius: CGFloat = 4

    private var palette: DSSelectableOptionCardPalette { isSelected ? .selected : .idle }

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 8) {
                checkbox
                    .padding(.top, 1)

                VStack(alignment: .leading, spacing: 4) {
                    Text(option.titulo)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(palette.title)

                    Text(option.descricao)
                        .font(.subheadline)
                        .foregroundStyle(palette.subtitle)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(palette.surface)
            .clipShape(RoundedRectangle(cornerRadius: cardRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cardRadius, style: .continuous)
                    .strokeBorder(palette.border, lineWidth: palette.borderWidth)
            )
            .contentShape(RoundedRectangle(cornerRadius: cardRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.15), value: isSelected)
        .accessibilityLabel("\(option.titulo), \(option.descricao)")
        .accessibilityValue(isSelected ? "Selecionado" : "Não selecionado")
    }

    private var checkbox: some View {
        RoundedRectangle(cornerRadius: boxRadius, style: .continuous)
            .fill(palette.box)
            .overlay(
                RoundedRectangle(cornerRadius: boxRadius, style: .continuous)
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
