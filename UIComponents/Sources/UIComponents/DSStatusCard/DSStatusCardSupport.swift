import SwiftUI

// MARK: - DSStatusCardEyebrow

/// The overline (eyebrow) shown at the very top of a ``DSStatusCard``.
///
/// Renders a short, uppercase, letter-spaced label using the `DSFont.etiqueta`
/// token. It sets the context for the card's title — e.g. "TODAY",
/// "CONFIRMED" — and stays purely decorative, leaving the spoken content to the
/// card itself.
///
/// ```swift
/// DSStatusCardEyebrow("Confirmed")
/// ```
struct DSStatusCardEyebrow: View {

    /// The label text. Uppercasing and tracking are applied by the view, so
    /// pass it in its natural casing.
    private let text: String

    /// Creates an eyebrow label.
    ///
    /// - Parameter text: The label text, styled uppercase by the view.
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(DSFont.technicalTag)
            .tracking(1.2)
            .textCase(.uppercase)
    }
}
