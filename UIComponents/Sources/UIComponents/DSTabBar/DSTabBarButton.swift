import SwiftUI

/// A single tab inside the ``DSTabBar``: icon, label, and optional badge.
///
/// Internal building block driven entirely by ``DSTabBar`` — it owns no
/// selection state and just reports taps through ``action``. The icon size
/// tracks Dynamic Type via `@ScaledMetric`, and the whole button keeps a
/// 44 pt minimum tap target.
struct DSTabBarButton<Tab: DSTabItem>: View {

    /// The tab this button represents.
    let tab: Tab

    /// Whether this tab is the current selection, which drives its tint and icon.
    let isSelected: Bool

    /// Optional badge count. Values `<= 0` (or `nil`) show no badge.
    let badge: Int?

    /// The appearance tokens inherited from the parent ``DSTabBar``.
    let style: DSTabBarStyle

    /// Invoked when the button is tapped.
    let action: () -> Void
 
    @ScaledMetric(relativeTo: .caption2) private var iconSize: CGFloat = 20
 
    var body: some View {
        Button(action: action) {
            VStack(spacing: DSSpacing.xs) {
                iconView
                    .overlay(alignment: .topTrailing) { badgeView }
                Text(tab.title)
                    .font(DSFont.tabLabel)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(isSelected ? style.selectedColor : style.unselectedColor)
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.15), value: isSelected)
        // Acessibilidade
        .accessibilityLabel(Text(tab.title))
        .accessibilityValue(badgeAccessibilityValue)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityShowsLargeContentViewer {
            iconView
            Text(tab.title)
        }
    }
    
    /// The badge capsule pinned to the icon's top-trailing corner.
    ///
    /// Renders nothing when there is no positive count, and caps the display at
    /// `99+`. Hidden from accessibility because the count is announced through
    /// the button's ``accessibilityValue(_:)`` instead.
    @ViewBuilder
    private var badgeView: some View {
        if let badge, badge > 0 {
            Text(badge > 99 ? "99+" : "\(badge)")
                .font(.caption2.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(.white)
                .padding(.horizontal, DSSpacing.xs)
                .frame(minWidth: 16, minHeight: 16)
                .background(Capsule().fill(style.selectedColor))
                .offset(x: 10, y: -6)
                .accessibilityHidden(true)
        }
    }
 
    /// The tab icon, swapping to ``DSTabItem/selectedIcon`` while selected and
    /// scaling with Dynamic Type.
    private var iconView: some View {
        (isSelected ? tab.selectedIcon : tab.icon)
            .resizable()
            .scaledToFit()
            .frame(width: iconSize, height: iconSize)
    }
 
    /// The VoiceOver value announcing the badge count, or empty when there is none.
    ///
    /// Localized with plural rules from `Localizable.stringsdict`, so "1 novo"
    /// and "2 novos" agree in number.
    private var badgeAccessibilityValue: Text {
        guard let badge, badge > 0 else { return Text(verbatim: "") }
        let format = NSLocalizedString("tabBarBadgeValue",
                                       bundle: .module,
                                       comment: "Tab bar badge count announced by VoiceOver")
        return Text(String(format: format, badge))
    }
}
