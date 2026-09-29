import SwiftUI

// MARK: - DSStatusCard Component

/// A card that presents the state and details of an appointment or request.
///
/// `DSStatusCard` displays an eyebrow, title, supporting details, an optional
/// ``DSStatusBadge``, and optional action content.
///
/// The card adapts its layout according to the ``DSStatusCardVariant`` provided
/// through the environment:
///
/// - `.expanded` uses the standard card spacing and displays actions.
/// - `.compact` uses tighter spacing and does not display actions.
///
/// The card's visual emphasis can also be provided through
/// `statusCardEmphasis`. When no explicit emphasis is provided, the card
/// derives its appearance from the booking status.
///
/// ## Example
///
/// A card with actions:
///
/// ```swift
/// DSStatusCard(
///     eyebrow: "Your next appointment",
///     title: "Fri, 28/08 · 14:00",
///     details: [
///         "Studio Ana Lima · Hands · R$ 35"
///     ],
///     status: DSStatusBadge(
///         title: "Confirmed",
///         status: .confirmed
///     )
/// ) {
///     DSStatusCardButton(title: "Directions") {
///         // Handle action.
///     }
/// }
/// ```
///
/// A card without actions:
///
/// ```swift
/// DSStatusCard(
///     eyebrow: "Previous appointment",
///     title: "Mon, 18/08 · 10:00",
///     details: [
///         "Studio Ana Lima · Hands · R$ 35"
///     ],
///     status: DSStatusBadge(
///         title: "Finished",
///         status: .finished
///     )
/// )
/// ```
///
/// ## Actions
///
/// Actions are rendered only when the card uses the `.expanded` variant and
/// the caller provides action content.
///
/// When multiple actions are provided, the card attempts to display them
/// horizontally. If the available width is insufficient, the layout
/// automatically switches to a vertical arrangement using `ViewThatFits`.
///
/// This allows the action row to adapt to larger Dynamic Type sizes without
/// requiring the caller to manage the layout.
///
/// ## Status and emphasis
///
/// When an explicit `statusCardEmphasis` is provided, it takes precedence over
/// the emphasis inferred from the status.
///
/// When the emphasis remains `.standard`, the booking status can determine the
/// card's semantic appearance. For example, confirmed bookings use the
/// positive appearance, while declined and cancelled bookings use the critical
/// appearance.
///
/// ## Accessibility
///
/// The card keeps its child views as contained accessibility elements, allowing
/// VoiceOver to navigate through the eyebrow, title, details, status, and
/// actions according to their semantic roles.
///
/// The status badge receives a contextual appearance from the card so that its
/// foreground and background remain legible against the card's surface.
///
/// ## Appearance
///
/// The card is intentionally rendered using the light color scheme. This keeps
/// the component aligned with the Design System's light-only palette,
/// including controls and other views contained inside the card.
///
/// - Note: The caller owns the behavior of the provided action views. The card
///   is responsible only for their layout and visual styling.
/// - SeeAlso: ``DSStatusBadge``
/// - SeeAlso: ``DSStatusCardVariant``
/// - SeeAlso: ``DSStatusCardEmphasis``
public struct DSStatusCard<Actions: View>: View {

    /// The layout density of the card.
    ///
    /// The value is provided through the `statusCardVariant` environment key.
    /// The `.expanded` variant supports actions, while `.compact` uses a
    /// tighter layout and hides them.
    @Environment(\.statusCardVariant)
    private var variant

    /// The explicitly requested visual emphasis for the card.
    ///
    /// The value is resolved together with the optional booking status to
    /// determine the final card palette.
    @Environment(\.statusCardEmphasis)
    private var emphasis

    /// The uppercase overline displayed above the title.
    private let eyebrow: String

    /// The primary headline displayed by the card.
    private let title: String

    /// Supporting text lines displayed below the title.
    ///
    /// Each element is rendered as a separate line in the same order provided
    /// by the caller.
    private let details: [String]

    /// The optional status badge displayed below the supporting details.
    private let status: DSStatusBadge?

    /// The action content supplied by the caller.
    ///
    /// Actions are displayed only by the `.expanded` variant.
    private let actions: Actions

    /// Creates a status card.
    ///
    /// - Parameters:
    ///   - eyebrow: The uppercase overline displayed above the title.
    ///   - title: The primary headline displayed by the card.
    ///   - details: Supporting text lines displayed below the title.
    ///   - status: An optional ``DSStatusBadge`` displayed below the details.
    ///   - actions: The action content displayed when the card uses the
    ///     `.expanded` variant.
    public init(
        eyebrow: String,
        title: String,
        details: [String] = [],
        status: DSStatusBadge? = nil,
        @ViewBuilder actions: () -> Actions
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.details = details
        self.status = status
        self.actions = actions()
    }

    /// Resolves the visual emphasis actually used by the card.
    ///
    /// An explicit environment value takes precedence. When the configured
    /// emphasis is `.standard`, the booking status can determine the semantic
    /// appearance.
    private var resolvedEmphasis: DSStatusCardEmphasis {
        DSStatusCardEmphasis.resolved(
            explicit: emphasis,
            for: status?.status
        )
    }

    /// Indicates whether the action row should be rendered.
    ///
    /// Actions are rendered only in the `.expanded` variant and when the
    /// generic action content is not `EmptyView`.
    private var hasActions: Bool {
        variant == .expanded && Actions.self != EmptyView.self
    }

    public var body: some View {
        let palette = DSStatusCardPalette.resolve(
            variant,
            emphasis: resolvedEmphasis
        )

        VStack(
            alignment: .leading,
            spacing: DSPadding.small
        ) {
            DSStatusCardEyebrow(eyebrow)
                .foregroundStyle(
                    palette.secondary.opacity(0.7)
                )

            Text(title)
                .font(DSFont.title)
                .foregroundStyle(palette.secondary)

            ForEach(
                Array(details.enumerated()),
                id: \.offset
            ) { _, line in
                Text(line)
                    .font(DSFont.inputSupport)
                    .foregroundStyle(palette.secondary)
            }

            if let status {
                status
                    .environment(
                        \.statusBadgeOnCard,
                        DSStatusBadgeOnCardAppearance(
                            foreground: palette.secondary,
                            background: palette.secondary.opacity(0.18)
                        )
                    )
                    .padding(.top, DSPadding.xsmall)
            }

            if hasActions {
                ViewThatFits {
                    HStack(spacing: DSPadding.xsmall) {
                        actions
                    }

                    VStack(spacing: DSPadding.xsmall) {
                        actions
                    }
                }
                .buttonStyle(
                    .dsStatusCard(
                        background: palette.actionBackground,
                        foreground: palette.actionForeground
                    )
                )
                .padding(.top, DSPadding.small)
            }
        }
        .padding(
            variant == .expanded
                ? DSPadding.medium
                : DSPadding.small
        )
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background(
            palette.background,
            in: .rect(
                cornerRadius: DSRadius.large,
                style: .continuous
            )
        )
        .environment(\.colorScheme, .light)
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Convenience Initializer

public extension DSStatusCard where Actions == EmptyView {

    /// Creates a status card without action buttons.
    ///
    /// Use this initializer when the card only needs to present information
    /// and an optional status.
    ///
    /// - Parameters:
    ///   - eyebrow: The uppercase overline displayed above the title.
    ///   - title: The primary headline displayed by the card.
    ///   - details: Supporting text lines displayed below the title.
    ///   - status: An optional ``DSStatusBadge`` displayed below the details.
    init(
        eyebrow: String,
        title: String,
        details: [String] = [],
        status: DSStatusBadge? = nil
    ) {
        self.init(
            eyebrow: eyebrow,
            title: title,
            details: details,
            status: status
        ) {
            EmptyView()
        }
    }
}
