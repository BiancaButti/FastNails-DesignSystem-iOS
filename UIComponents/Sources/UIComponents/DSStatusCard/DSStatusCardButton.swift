import SwiftUI

// MARK: - DSStatusCard action button

/// An action button designed to be used inside a ``DSStatusCard``.
///
/// `DSStatusCardButton` provides a simple button with a text label. Its
/// appearance is intentionally not defined by the button itself. The
/// containing ``DSStatusCard`` applies the
/// ``SwiftUI/ButtonStyle/dsStatusCard(background:foreground:)`` style,
/// allowing the button to inherit the card's action colors and metrics.
///
/// This keeps the button reusable while ensuring that all action buttons
/// inside a status card share the same visual treatment.
///
/// ## Example
///
/// ```swift
/// DSStatusCard(
///     eyebrow: "Seu próximo horário",
///     title: "Sexta, 28/08 · 14:00"
/// ) {
///     DSStatusCardButton(title: "Como chegar") {
///         // Handle directions.
///     }
///
///     DSStatusCardButton(title: "Ver detalhes") {
///         // Handle details.
///     }
/// }
/// ```
///
/// - Important: `DSStatusCardButton` is intended to be used inside
///   ``DSStatusCard``. The card is responsible for applying the button style
///   that defines its colors, layout, and metrics.
///
/// - Note: When used outside a ``DSStatusCard``, the button does not
///   automatically receive the status-card button style.
public struct DSStatusCardButton: View {

    /// The text displayed by the button.
    private let title: String

    /// The action executed when the button is tapped.
    private let action: () -> Void

    /// Creates a status-card action button.
    ///
    /// - Parameters:
    ///   - title: The text displayed by the button.
    ///   - action: The closure executed when the button is tapped.
    public init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(
            title,
            action: action
        )
    }
}
