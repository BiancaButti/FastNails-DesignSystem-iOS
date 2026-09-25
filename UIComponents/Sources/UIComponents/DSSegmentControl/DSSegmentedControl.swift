import SwiftUI

// MARK: - DSSegmentedControl

/// A custom segmented control used to toggle between mutually exclusive options,
/// such as filtering list timelines (e.g., "Próximos" vs. "Anteriores").
///
/// It features smooth sliding animations and adheres to the `Color.paper2` surface token container
/// and `Color.paper` selected capsule layout.
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
public struct DSSegmentedControl<Selection: Hashable, Content: View>: View {
    @Binding private var selection: Selection
    private let options: [Selection]
    private let content: (Selection) -> Content

    /// Creates a generic `DSSegmentedControl` with custom view mapping.
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
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                let isSelected = selection == option
                
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                        selection = option
                    }
                }) {
                    content(option)
                        .font(isSelected ? DSFont.descriptionBold : DSFont.description)
                        .foregroundColor(isSelected ? DSColor.ink : DSColor.ink60)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                if isSelected {
                                    RoundedRectangle(
                                        cornerRadius: DSRadius.control,
                                        style: .continuous)
                                        .fill(DSColor.paper)
                                        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(DSColor.paper2)
        .cornerRadius(DSRadius.control)
    }
}

// MARK: - Convenience Initializer

public extension DSSegmentedControl {
    /// A convenience initializer to quickly build a segmented control using text titles.
    init(
        selection: Binding<Selection>,
        options: [Selection],
        titleKeyPath: KeyPath<Selection, String>
    ) where Content == Text {
        self.init(selection: selection, options: options) { option in
            Text(option[keyPath: titleKeyPath])
        }
    }
}
