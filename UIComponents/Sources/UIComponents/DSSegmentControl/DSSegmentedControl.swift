import SwiftUI

// MARK: - DSSegmentedControl

/// A segmented control for selecting one option from a mutually exclusive set.
///
/// `DSSegmentedControl` displays a collection of options horizontally and
/// maintains a single selected value through a `Binding`. Each option is
/// rendered using the provided view builder, allowing the control to display
/// text or any other SwiftUI content.
///
/// When the selection changes, the control applies the Design System's
/// snappy spring animation to the selected state.
///
/// The control uses the Design System surface and typography tokens:
///
/// - `DSColor.paper2` for the container background.
/// - `DSColor.paper` for the selected segment.
/// - `DSColor.ink` for the selected option.
/// - `DSColor.ink60` for unselected options.
/// - `DSFont.descriptionBold` for the selected option.
/// - `DSFont.description` for unselected options.
///
/// Example:
///
/// ```swift
/// @State private var filter: Period = .upcoming
///
/// DSSegmentedControl(
///     selection: $filter,
///     options: Period.allCases,
///     titleKeyPath: \.localizedTitle
/// )
/// ```
///
/// For custom content, use the `content` view builder:
///
/// ```swift
/// DSSegmentedControl(
///     selection: $selection,
///     options: options
/// ) { option in
///     Label(option.title, systemImage: option.icon)
/// }
/// ```
///
/// - Parameters:
///   - Selection: The type representing each selectable option. It must
///     conform to `Hashable`.
///   - Content: The SwiftUI view rendered for each option.
///
/// - Important: The `options` array should contain unique values. Since
///   options are identified using `\.self`, duplicate values cannot be
///   distinguished by `ForEach`.
public struct DSSegmentedControl<Selection: Hashable, Content: View>: View {

    /// The currently selected option.
    ///
    /// Updating this binding changes the selected segment displayed by the
    /// control.
    @Binding private var selection: Selection

    /// The options displayed by the segmented control.
    ///
    /// Each option must be uniquely identifiable through its `Hashable`
    /// conformance.
    private let options: [Selection]

    /// Builds the visual content for each option.
    ///
    /// The closure is evaluated for every value in `options`.
    private let content: (Selection) -> Content

    /// Creates a segmented control with custom content for each option.
    ///
    /// Use this initializer when each segment requires custom SwiftUI content,
    /// such as a `Label`, an icon, or a combination of views.
    ///
    /// Example:
    ///
    /// ```swift
    /// DSSegmentedControl(
    ///     selection: $selection,
    ///     options: options
    /// ) { option in
    ///     Label(option.title, systemImage: option.icon)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - selection: A binding to the currently selected option.
    ///   - options: The options displayed by the control.
    ///   - content: A view builder that creates the content displayed for each
    ///     option.
    public init(
        selection: Binding<Selection>,
        options: [Selection],
        @ViewBuilder content: @escaping (Selection) -> Content
    ) {
        self._selection = selection
        self.options = options
        self.content = content
    }

    public var body: some View {
        HStack(spacing: .zero) {
            ForEach(options, id: \.self) { option in
                let isSelected = selection == option

                Button(action: {
                    withAnimation(
                        .spring(
                            response: DSAnimation.snappyResponse,
                            dampingFraction: DSAnimation.snappyDamping
                        )
                    ) {
                        selection = option
                    }
                }) {
                    content(option)
                        .font(
                            isSelected
                                ? DSFont.descriptionBold
                                : DSFont.description
                        )
                        .foregroundColor(
                            isSelected
                                ? DSColor.ink
                                : DSColor.ink60
                        )
                        .padding(.vertical, DSPadding.medium)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                if isSelected {
                                    RoundedRectangle(
                                        cornerRadius: DSRadius.control,
                                        style: .continuous
                                    )
                                    .fill(DSColor.paper)
                                    .shadow(
                                        color: .black.opacity(0.04),
                                        radius: DSRadius.xsmall,
                                        y: 1
                                    )
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DSPadding.xsmall)
        .background(DSColor.paper2)
        .cornerRadius(DSRadius.control)
    }
}

// MARK: - Convenience Initializer

public extension DSSegmentedControl {

    /// Creates a text-based segmented control using a key path to obtain
    /// each option's title.
    ///
    /// This initializer is a convenience for the common case where each
    /// segment is represented by a `String`.
    ///
    /// Example:
    ///
    /// ```swift
    /// @State private var filter: Period = .upcoming
    ///
    /// DSSegmentedControl(
    ///     selection: $filter,
    ///     options: Period.allCases,
    ///     titleKeyPath: \.localizedTitle
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - selection: A binding to the currently selected option.
    ///   - options: The options displayed by the control.
    ///   - titleKeyPath: A key path used to retrieve the text displayed for
    ///     each option.
    init(
        selection: Binding<Selection>,
        options: [Selection],
        titleKeyPath: KeyPath<Selection, String>
    ) where Content == Text {
        self.init(
            selection: selection,
            options: options
        ) { option in
            Text(option[keyPath: titleKeyPath])
        }
    }
}
