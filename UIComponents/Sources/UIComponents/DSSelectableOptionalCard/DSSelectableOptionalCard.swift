import SwiftUI

// MARK: - Model

/// Represents a selectable option displayed by ``DSSelectableOptionList``.
///
/// `SelectableOption` contains the stable identity and the textual content
/// presented by a selectable card. The model conforms to `Identifiable` so
/// SwiftUI can track each option across list updates, and to `Hashable` so
/// it can be used in collections and selection-related operations.
///
/// - Important: The `id` must remain stable for the lifetime of an option
///   across list rebuilds. Do not generate a new identifier during each
///   initialization, such as with `UUID()`, when the same logical option is
///   being recreated. Changing the identity can cause SwiftUI to treat the
///   option as a different element and disrupt diffing, state preservation,
///   and animations.
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
/// - SeeAlso: ``DSSelectableOptionList``
public struct SelectableOption: Identifiable, Hashable {

    /// A stable identifier used by SwiftUI to track the option.
    ///
    /// The identifier should represent the identity of the logical option,
    /// rather than the particular instance of `SelectableOption`.
    public let id: String

    /// The primary text displayed on the selectable card.
    public let title: String

    /// Supporting text displayed below the option's title.
    public let description: String

    /// Creates a selectable option.
    ///
    /// - Parameters:
    ///   - id: A stable identifier that remains consistent across list
    ///     rebuilds.
    ///   - title: The primary text displayed on the card.
    ///   - description: Supporting text displayed below the title.
    public init(
        id: String,
        title: String,
        description: String
    ) {
        self.id = id
        self.title = title
        self.description = description
    }
}

// MARK: - Card

/// A selectable multiple-choice card with a checkbox indicator.
///
/// `DSSelectableCheckboxCard` renders a ``SelectableOption`` as a tappable
/// card containing a checkbox indicator, title, and supporting description.
///
/// The view is intentionally stateless with respect to selection. It receives
/// the current selection through `isSelected` and reports user interaction
/// through `onToggle`. The owner of the view is responsible for storing and
/// updating the selection state.
///
/// This separation allows ``DSSelectableOptionList`` or another parent
/// component to own the selection model while the card remains responsible
/// only for presentation and interaction.
///
/// The card's appearance is determined by
/// `DSSelectableOptionCardPalette`, with separate visual states for selected
/// and unselected options.
///
/// ## Accessibility
///
/// The entire card behaves as a single button.
///
/// Its accessibility representation consists of:
///
/// 1. The option title.
/// 2. The option description.
/// 3. The current selection state.
///
/// The visual checkbox is hidden from assistive technologies because its
/// state is already communicated through the button's accessibility value.
/// This prevents VoiceOver from announcing the same information twice.
///
/// ## Reduce Motion
///
/// The selection animation respects the system's Reduce Motion setting.
/// When Reduce Motion is enabled, the state transition is presented without
/// animation.
///
/// - Important: The card deliberately avoids semantic system colors such as
///   `.primary`, `.secondary`, and `Color(.systemBackground)`. The component
///   uses Design System tokens instead so its colors remain consistent with
///   the application's palette.
///
/// - SeeAlso: ``SelectableOption``
/// - SeeAlso: ``DSSelectableOptionList``
struct DSSelectableCheckboxCard: View {

    /// Whether the system's Reduce Motion accessibility setting is enabled.
    ///
    /// When enabled, the card skips its selection animation.
    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    /// The option displayed by the card.
    let option: SelectableOption

    /// Indicates whether the option is currently selected.
    ///
    /// Selection is owned by the parent component and passed into the card
    /// as a value.
    let isSelected: Bool

    /// The action executed when the user toggles the card.
    ///
    /// The card does not mutate selection state directly. The parent is
    /// responsible for updating `isSelected` after this action is invoked.
    let onToggle: () -> Void

    /// The palette corresponding to the current selection state.
    private var palette: DSSelectableOptionCardPalette {
        isSelected ? .selected : .idle
    }

    var body: some View {
        Button(action: onToggle) {
            HStack(
                alignment: .top,
                spacing: DSSpacing.sm
            ) {
                checkbox
                    .padding(.top, DSPadding.xsmall)

                VStack(
                    alignment: .leading,
                    spacing: DSSpacing.sm
                ) {
                    Text(option.title)
                        .font(DSFont.caption)
                        .minimumScaleFactor(0.8)

                    Text(option.description)
                        .font(DSFont.inputSupport)
                        .foregroundStyle(palette.subtitle)
                }

                Spacer(minLength: .zero)
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.vertical, DSPadding.medium)
            .padding(.horizontal, DSPadding.medium)
            .background(palette.surface)
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
                .strokeBorder(
                    palette.border,
                    lineWidth: palette.borderWidth
                )
            )
            .contentShape(
                RoundedRectangle(
                    cornerRadius: DSRadius.control,
                    style: .continuous
                )
            )
        }
        .buttonStyle(.plain)
        .animation(
            reduceMotion
                ? nil
                : .easeInOut(duration: 0.15),
            value: isSelected
        )
        .accessibilityLabel(
            "\(option.title), \(option.description)"
        )
        .accessibilityValue(
            isSelected
                ? "Selected"
                : "Not selected"
        )
    }

    /// The visual checkbox displayed on the card.
    ///
    /// The checkbox reflects the current selection state through the
    /// ``DSSelectableOptionCardPalette`` and displays a checkmark when the
    /// option is selected.
    ///
    /// The checkbox is hidden from accessibility technologies because the
    /// parent button already exposes the selection state through its
    /// accessibility value.
    private var checkbox: some View {
        RoundedRectangle(
            cornerRadius: DSRadius.xsmall,
            style: .continuous
        )
        .fill(palette.box)
        .overlay(
            RoundedRectangle(
                cornerRadius: DSRadius.xsmall,
                style: .continuous
            )
            .strokeBorder(
                palette.boxBorder,
                lineWidth: DSBorder.thin
            )
        )
        .overlay {
            if isSelected {
                Image(systemName: "checkmark")
                    .font(
                        .system(
                            size: DSSize.mediumLarge * 0.52,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(palette.check)
            }
        }
        .frame(
            width: DSSize.mediumLarge,
            height: DSSize.mediumLarge
        )
        .accessibilityHidden(true)
    }
}
