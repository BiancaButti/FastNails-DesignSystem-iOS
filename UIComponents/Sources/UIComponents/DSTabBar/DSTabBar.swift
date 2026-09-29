import SwiftUI

/// A horizontal tab bar for displaying and selecting ``DSTabItem`` values.
///
/// `DSTabBar` renders a row of ``DSTabBarButton`` instances and keeps the
/// currently selected tab synchronized through a binding.
///
/// The component is responsible only for rendering the tab bar and updating
/// the selection. It does not manage navigation, child view state, or the
/// system tab bar.
///
/// For a complete tab-based container that also handles navigation concerns,
/// hides the native tab bar, and preserves per-tab state, use
/// ``DSTabBarView``.
///
/// ## Example
///
/// ```swift
/// @State private var tab: AppTab = .home
///
/// DSTabBar(
///     selection: $tab,
///     badges: [
///         .bookings: 2
///     ]
/// )
/// ```
///
/// ## Tabs
///
/// By default, the bar displays every case of `Tab` in the order returned by
/// `Tab.allCases`.
///
/// Pass a custom `tabs` array when only a subset of the available tabs should
/// be displayed or when a specific ordering is required.
///
/// ## Badges
///
/// Badge counts are supplied through the `badges` dictionary and are keyed by
/// the corresponding tab.
///
/// A badge is not displayed when:
///
/// - The tab has no entry in `badges`.
/// - The associated count is `0`.
///
/// The interpretation and formatting of the count are handled by the tab
/// button component.
///
/// ## Appearance
///
/// The visual appearance is provided by the
/// ``SwiftUICore/View/dsTabBarStyle(_:)`` environment value. This allows the
/// same tab bar component to be reused with different style configurations
/// without embedding color or surface decisions in the component itself.
///
/// The bar also renders an optional top divider supplied by the current style.
///
/// ## Interaction
///
/// Tapping a tab updates the `selection` binding with the selected tab.
///
/// On iOS 17 and later, selection changes provide `.selection` sensory
/// feedback. Earlier iOS versions use the same interaction without sensory
/// feedback.
///
/// ## Safe Area
///
/// The tab bar extends its background through the bottom safe area. Its content
/// retains the configured horizontal and vertical Design System spacing.
///
/// - Note: `DSTabBar` does not own the selected-tab state. The caller must
///   provide a binding and is responsible for reacting to selection changes.
///
/// - SeeAlso: ``DSTabBarButton``
/// - SeeAlso: ``DSTabBarView``
/// - SeeAlso: ``DSTabItem``
public struct DSTabBar<Tab: DSTabItem>: View {

    /// The currently selected tab.
    ///
    /// Updating this binding changes the selected tab displayed by the bar.
    @Binding private var selection: Tab

    /// The tabs displayed by the bar, in display order.
    ///
    /// Defaults to all cases provided by `Tab.allCases`.
    private let tabs: [Tab]

    /// Badge counts associated with individual tabs.
    ///
    /// Tabs without a value, or with a count of `0`, display no badge.
    private let badges: [Tab: Int]

    /// The visual style supplied through the environment.
    @Environment(\.dsTabBarStyle)
    private var style

    /// The display scale used to resolve the divider to a single physical
    /// pixel when required.
    @Environment(\.displayScale)
    private var displayScale

    /// Creates a tab bar.
    ///
    /// - Parameters:
    ///   - selection: A binding to the currently selected tab.
    ///   - tabs: The tabs displayed by the bar, in order. Defaults to every
    ///     case of `Tab`.
    ///   - badges: Badge counts keyed by tab. Missing entries and zero values
    ///     display no badge.
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
                style.background
                    .ignoresSafeArea(edges: .bottom)
            }
            .overlay(alignment: .top) {
                if let divider = style.dividerColor {
                    Rectangle()
                        .fill(divider)
                        .frame(
                            height: DSLayoutIndex.base / displayScale
                        )
                }
            }
    }

    /// The row containing the individual tab buttons.
    ///
    /// On iOS 17 and later, selection changes trigger the system's
    /// `.selection` sensory feedback.
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
            bar.sensoryFeedback(
                .selection,
                trigger: selection
            )
        } else {
            bar
        }
    }
}
