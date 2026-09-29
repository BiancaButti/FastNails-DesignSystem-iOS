import SwiftUI

// MARK: - DSStatusCardEyebrow

/// A decorative overline displayed at the top of a ``DSStatusCard``.
///
/// `DSStatusCardEyebrow` provides contextual information above the card's
/// title, such as "Today", "Confirmed", or "Upcoming".
///
/// The view applies the Design System's technical label typography, uppercase
/// transformation, and letter spacing. Callers should provide the text in its
/// natural casing.
///
/// ## Example
///
/// ```swift
/// DSStatusCardEyebrow("Confirmed")
/// ```
///
/// - Note: The eyebrow is a visual context label. It does not define the
///   accessibility reading order of the card; the containing
///   ``DSStatusCard`` is responsible for the card's accessibility structure.
struct DSStatusCardEyebrow: View {

    /// The text displayed by the eyebrow.
    ///
    /// The view applies uppercase styling automatically.
    private let text: String

    /// Creates an eyebrow label.
    ///
    /// - Parameter text: The contextual label displayed above the card title.
    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(DSFont.technicalTag)
            .tracking(DSTracking.upperTag)
            .textCase(.uppercase)
    }
}
