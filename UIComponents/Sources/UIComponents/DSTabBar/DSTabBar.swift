import SwiftUI

/// The Fast Nails tab bar: a horizontal row of ``DSTabBarButton`` tabs.
///
/// Drop it wherever you need the bar itself — for a full container that also
/// hides the native tab bar and preserves per-tab state, use ``DSTabBarView``.
/// Appearance comes from the environment via ``SwiftUICore/View/dsTabBarStyle(_:)``,
/// and on iOS 17+ selection changes trigger `.selection` sensory feedback.
///
/// ```swift
/// DSTabBar(selection: $tab, badges: [.bookings: 2])
/// ```
public struct DSTabBar<Tab: DSTabItem>: View {

    /// The currently selected tab, updated when a tab is tapped.
    @Binding private var selection: Tab

    /// The tabs to display, in order. Defaults to every case of `Tab`.
    private let tabs: [Tab]

    /// Badge counts keyed by tab. Missing entries (or `0`) show no badge.
    private let badges: [Tab: Int]
 
    @Environment(\.dsTabBarStyle) private var style
    @Environment(\.displayScale) private var displayScale
 
    /// Creates a tab bar.
    ///
    /// - Parameters:
    ///   - selection: The currently selected tab.
    ///   - tabs: The tabs to show, in order. Defaults to `Array(Tab.allCases)`.
    ///   - badges: The badge count per tab. Tabs with no entry (or `0`) show no badge.
    public init(
        selection: Binding<Tab>,
        tabs: [Tab] = Array(Tab.allCases),
        badges: [Tab: Int] = [:]
    ) {
        self._selection = selection
        self.tabs = tabs
        self.badges = badges
    }
 
    public var body: some View {
        content
            .padding(.horizontal, DSPadding.medium)
            .padding(.top, DSPadding.xsmall)
            .padding(.bottom, DSPadding.xsmall)
            .background {
                style.background.ignoresSafeArea(edges: .bottom)
            }
            .overlay(alignment: .top) {
                if let divider = style.dividerColor {
                    Rectangle()
                        .fill(divider)
                        .frame(height: DSLayoutIndex.base / displayScale)
                }
            }
    }

    /// The row of tab buttons, adding `.selection` sensory feedback on iOS 17+.
    @ViewBuilder
    private var content: some View {
        let bar = HStack(spacing: .zero) {
            ForEach(tabs) { tab in
                DSTabBarButton(
                    tab: tab,
                    isSelected: tab == selection,
                    badge: badges[tab],
                    style: style
                ) {
                    selection = tab
                }
            }
        }

        if #available(iOS 17.0, *) {
            bar.sensoryFeedback(.selection, trigger: selection)
        } else {
            bar
        }
    }
}
