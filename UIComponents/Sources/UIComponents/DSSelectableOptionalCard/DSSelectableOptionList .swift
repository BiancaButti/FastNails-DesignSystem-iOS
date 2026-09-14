import SwiftUI
// MARK: - List (multiple choice)

/// A vertical list of multiple-choice selectable cards.
///
/// Use `DSSelectableOptionList` to let the user pick one or more options from a
/// short set. Each option is rendered as a `DSSelectableCheckboxCard` and the
/// current selection is driven by a binding, so the caller owns the state and
/// the list simply reflects and mutates it.
///
/// The list displays a title above the cards. Tapping a card toggles its
/// membership in the selection set.
///
/// ## Example
///
/// ```swift
/// @State private var selection: Set<String> = ["hands"]
///
/// DSSelectableOptionList(
///     title: "Selectable Options",
///     options: [
///         SelectableOption(id: "hands", titulo: "Hands", descricao: "Manicure, from 30 min"),
///         SelectableOption(id: "feet", titulo: "Feet", descricao: "Pedicure, from 45 min")
///     ],
///     selection: $selection
/// )
/// ```
///
/// ## Selection handling
///
/// The list is a multiple-choice control: toggling a card inserts or removes
/// its `id` from the `selection` set. To build a single-choice variant, clear
/// the set before inserting in the caller, or enforce the constraint upstream.
///
/// Each option's `id` must be stable across list rebuilds so SwiftUI can keep
/// its identity for diffing and animation.
///
/// ## Accessibility
///
/// The list is exposed as a container that groups its cards, with an
/// accessibility label combining the title and an instruction to select one or
/// more options. Each card is an independent button that announces its
/// selected state through its accessibility value.
///
/// - Note: The list does not manage the selection itself; the caller is
///   responsible for providing and updating the `selection` binding.
///
/// - SeeAlso: `SelectableOption`
public struct DSSelectableOptionList: View {

    /// The title displayed above the options.
    let title: String

    /// The ordered collection of options displayed by the list.
    let options: [SelectableOption]

    /// The set of currently selected option identifiers.
    @Binding var selection: Set<SelectableOption.ID>

    /// Creates a multiple-choice selectable option list.
    ///
    /// - Parameters:
    ///   - title: The title displayed above the options.
    ///   - options: The ordered collection of options to display.
    ///   - selection: A binding to the set of selected option identifiers.
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
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.tinta60)
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
        .accessibilityLabel("\(title). Selecione uma ou mais opções.")
    }
}
