import SwiftUI

// MARK: - List (multiple choice)

/// A vertical list of multiple-choice selectable cards.
///
/// `DSSelectableOptionList` displays a collection of ``SelectableOption``
/// values as ``DSSelectableCheckboxCard`` instances and provides a binding
/// to the set of currently selected option identifiers.
///
/// The component does not own the selection state. The caller provides the
/// `selection` binding, while the list updates the set when an option is
/// selected or deselected.
///
/// Each card behaves independently, allowing multiple options to be selected
/// at the same time.
///
/// ## Example
///
/// ```swift
/// @State private var selection: Set<String> = ["hands"]
///
/// DSSelectableOptionList(
///     title: "Selectable Options",
///     options: [
///         SelectableOption(
///             id: "hands",
///             title: "Hands",
///             description: "Manicure, from 30 min"
///         ),
///         SelectableOption(
///             id: "feet",
///             title: "Feet",
///             description: "Pedicure, from 45 min"
///         )
///     ],
///     selection: $selection
/// )
/// ```
///
/// ## Selection handling
///
/// The list implements multiple selection by toggling each option's `id`
/// within the bound selection set:
///
/// - If an option is selected, tapping it removes its `id` from `selection`.
/// - If an option is not selected, tapping it inserts its `id` into
///   `selection`.
///
/// The component does not enforce a minimum or maximum number of selected
/// options.
///
/// If a single-choice behavior is required, the caller should enforce that
/// constraint when updating the selection.
///
/// Each option's `id` must remain stable across list rebuilds so SwiftUI can
/// preserve identity, state, diffing, and animations.
///
/// ## Accessibility
///
/// The list groups its child cards into an accessibility container and
/// exposes the list title together with an instruction that multiple options
/// can be selected.
///
/// Each ``DSSelectableCheckboxCard`` remains an independent accessibility
/// element and announces its own title, description, and selection state.
///
/// - Note: The list does not manage selection state independently. The caller
///   is responsible for owning and providing the `selection` binding.
///
/// - SeeAlso: ``SelectableOption``
/// - SeeAlso: ``DSSelectableCheckboxCard``
public struct DSSelectableOptionList: View {

    /// The title displayed above the selectable options.
    let title: String

    /// The ordered collection of options displayed by the list.
    ///
    /// The order of this array determines the visual and accessibility order
    /// of the cards.
    let options: [SelectableOption]

    /// The set containing the identifiers of currently selected options.
    ///
    /// The parent view owns this state. The list mutates the bound set when
    /// the user toggles an option.
    @Binding var selection: Set<SelectableOption.ID>

    /// Creates a multiple-choice selectable option list.
    ///
    /// - Parameters:
    ///   - title: The title displayed above the options.
    ///   - options: The ordered collection of options displayed by the list.
    ///   - selection: A binding to the set containing the identifiers of the
    ///     currently selected options.
    public init(
        title: String,
        options: [SelectableOption],
        selection: Binding<Set<SelectableOption.ID>>
    ) {
        self.title = title
        self.options = options
        self._selection = selection
    }

    public var body: some View {
        VStack(
            alignment: .leading,
            spacing: DSSpacing.md
        ) {
            Text(title)
                .font(DSFont.technicalTag)
                .textCase(.uppercase)
                .tracking(DSTracking.upperTag)
                .foregroundStyle(DSColor.ink60)
                .accessibilityAddTraits(.isHeader)

            ForEach(options) { option in
                DSSelectableCheckboxCard(
                    option: option,
                    isSelected: selection.contains(option.id)
                ) {
                    if selection.contains(option.id) {
                        selection.remove(option.id)
                    } else {
                        selection.insert(option.id)
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(
            "\(title). Select one or more options."
        )
    }
}
