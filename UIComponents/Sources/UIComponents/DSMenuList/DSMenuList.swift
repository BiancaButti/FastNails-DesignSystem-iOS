import SwiftUI

// MARK: - DSMenuList

/// A grouped card container that organizes multiple menu rows with optional section labeling.
///
/// Use `DSMenuList` to group related ``DSMenuRow`` elements into a single visual container.
/// It applies consistent spacing, borders, corner radius, and separators between the provided child views.
///
/// ```swift
/// DSMenuList(sectionTitle: "Conta") {
///     DSMenuRow(...)
///     DSMenuRow(...)
/// }
/// ```
public struct DSMenuList<Content: View>: View {
    /// An optional section title displayed above the menu container.
    let sectionTitle: String?

    /// The menu row content rendered inside the grouped container.
    @ViewBuilder let content: () -> Content

    /// Creates a `DSMenuList`.
    /// - Parameters:
    ///   - sectionTitle: An optional title displayed above the menu rows.
    ///   - content: A view builder that produces the menu rows displayed in the list.
    public init(
        sectionTitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.sectionTitle = sectionTitle
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            if let sectionTitle {
                Text(sectionTitle.uppercased())
                    .font(DSFont.badge)
                    .foregroundColor(DSColor.ink60)
                    .tracking(DSTracking.upperTag)
                    .padding(.leading, DSPadding.xsmall)
            }

            VStack(spacing: .zero) {
                _VariadicView.Tree(MenuSeparatorInsertionLayout()) {
                    content()
                }
            }
            .background(DSColor.paper)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: DSRadius.xxlarge,
                    style: .continuous
                )
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: DSRadius.xxlarge,
                    style: .continuous
                )
                .strokeBorder(
                    DSColor.line,
                    lineWidth: 1
                )
            )
        }
    }
}

// MARK: - Helper Layout for Separator Lines

/// A custom variadic layout that inserts separators between structural menu items.
///
/// The layout renders each child in order and adds a design system divider between
/// adjacent items without adding a separator after the final child.
private struct MenuSeparatorInsertionLayout: _VariadicView.MultiViewRoot {
    /// Renders the menu children and inserts a divider between adjacent items.
    /// - Parameter children: The menu item views provided by the parent `DSMenuList`.
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        VStack(spacing: .zero) {
            ForEach(children) { child in
                child

                if child.id != children.last?.id {
                    DSColor.line
                        .frame(height: 1)
                        .padding(.horizontal, DSPadding.regular)
                }
            }
        }
    }
}
