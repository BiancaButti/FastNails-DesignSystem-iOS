import SwiftUI

// MARK: - DSMenuList

/// A grouped card container that stacks multiple ``DSMenuRow`` elements with
/// internal separators and an optional header section category title.
public struct DSMenuList<Content: View>: View {
    let sectionTitle: String?
    @ViewBuilder let content: () -> Content

    public init(sectionTitle: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.sectionTitle = sectionTitle
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let sectionTitle {
                Text(sectionTitle.uppercased())
                    .font(DSFont.badge)
                    .foregroundColor(DSColor.ink60)
                    .tracking(1.5)
                    .padding(.leading, 4)
            }
            
            VStack(spacing: 0) {
                _VariadicView.Tree(MenuSeparatorInsertionLayout()) {
                    content()
                }
            }
            .background(DSColor.paper)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(DSColor.line, lineWidth: 1)
            )
        }
    }
}

// MARK: - Helper Layout for Separator Lines

/// Custom Layout system to inject `Color.line` between structural list items dynamically.
private struct MenuSeparatorInsertionLayout: _VariadicView.MultiViewRoot {
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        VStack(spacing: 0) {
            ForEach(children) { child in
                child
                
                if child.id != children.last?.id {
                    DSColor.line
                        .frame(height: 1)
                        .padding(.horizontal, 16)
                }
            }
        }
    }
}
