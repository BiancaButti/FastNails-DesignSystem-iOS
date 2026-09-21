import SwiftUI

// MARK: - DSStatusCardEyebrow

/// The overline (eyebrow) shown at the very top of a ``DSStatusCard``.
///
/// Renders a short, uppercase, letter-spaced label using the `DSFont.etiqueta`
/// token, optionally preceded by a small colored status dot. It sets the
/// context for the card's title — e.g. "TODAY", "CONFIRMED" — and stays purely
/// decorative, leaving the spoken content to the card itself.
///
/// ```swift
/// DSStatusCardEyebrow("Confirmed", dot: .positive)
/// ```
struct DSStatusCardEyebrow: View {
    @Environment(\.dsTheme)
    private var theme
    
    /// The label text. Uppercasing and tracking are applied by the view, so
    /// pass it in its natural casing.
    private let text: String

    /// Tone of the leading status dot. `nil` hides the dot and shows text only.
    private let dot: DSStatusCardIndicator.Tone?

    /// Creates an eyebrow label.
    ///
    /// - Parameters:
    ///   - text: The label text, styled uppercase by the view.
    ///   - dot: The tone of the leading status dot, or `nil` for no dot.
    init(_ text: String,
         dot: DSStatusCardIndicator.Tone? = nil) {
        self.text = text
        self.dot = dot
    }

    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            if let dot {
                Circle()
                    .fill(dot.color)
                    .frame(width: 6, height: 6)
            }
            Text(text)
                .font(DSFont.etiqueta)
                .tracking(1.2)
                .textCase(.uppercase)
        }
    }
}

// MARK: - Tone color

extension DSStatusCardIndicator.Tone {
    /// Dot/accent color for the tone, drawn from the shared palette.
    var color: Color {
        switch self {
        case .positive: .confirmed
        case .pending:  .amber
        case .critical: .alert
        case .inactive: .ink60
        }
    }
}
