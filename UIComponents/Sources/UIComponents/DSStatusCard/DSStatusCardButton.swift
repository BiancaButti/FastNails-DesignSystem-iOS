import SwiftUI

// MARK: - DSStatusCard action button

/// The action button used inside a ``DSStatusCard``.
///
/// It renders a plain button labeled with `title`. The surrounding card supplies
/// its colors and metrics through
/// ``SwiftUI/ButtonStyle/dsStatusCard(background:foreground:)``, so the button
/// automatically follows the card's palette — there is no fixed color here.
///
/// Use it inside a ``DSStatusCard``'s `actions` builder:
///
/// ```swift
/// DSStatusCard(eyebrow: "Seu próximo horário", title: "Sexta, 28/08 · 14:00") {
///     DSStatusCardButton(title: "Como chegar") { }
///     DSStatusCardButton(title: "Ver detalhes") { }
/// }
/// ```
public struct DSStatusCardButton: View {

    /// The button's label.
    private let title: String

    /// The action performed on tap.
    private let action: () -> Void

    /// Creates a status-card action button.
    ///
    /// - Parameters:
    ///   - title: The button's label.
    ///   - action: The action performed on tap.
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(title, action: action)
    }
}
