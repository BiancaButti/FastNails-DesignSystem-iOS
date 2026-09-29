import SwiftUI

// MARK: - Accessibility tag

/// A visual tag that displays a single accessibility feature of a salon.
///
/// `DSSalonCardAccessibilityTag` renders an accessibility feature as a pill
/// containing an SF Symbol and a descriptive title. The tag uses the
/// ``DSSalonCardPalette`` provided by the parent card to ensure consistent
/// styling with the rest of the salon card.
///
/// The tag is intentionally hidden from accessibility technologies. The
/// containing ``DSSalonCard`` is responsible for exposing the salon's
/// accessibility features as part of a single combined accessibility
/// representation.
///
/// This prevents VoiceOver from announcing the same accessibility information
/// twice and preserves the product-defined reading order:
///
/// 1. Salon name
/// 2. Price
/// 3. Distance
/// 4. Availability
/// 5. Accessibility features
///
/// - Important: Do not remove `.accessibilityHidden(true)` unless the
///   accessibility implementation of ``DSSalonCard`` is also changed.
///   Exposing this view independently would cause VoiceOver to announce the
///   accessibility feature again.
///
/// Example:
///
/// ```swift
/// DSSalonCardAccessibilityTag(
///     feature: .semDegrau,
///     palette: palette
/// )
/// ```
struct DSSalonCardAccessibilityTag: View {

    /// The accessibility feature represented by the tag.
    ///
    /// Provides the SF Symbol, visible title, and accessibility information
    /// associated with the feature.
    let feature: DSSalonAccessibilityFeature

    /// The visual palette used to style the tag.
    ///
    /// The palette determines the background and foreground colors used by
    /// the accessibility feature tag.
    let palette: DSSalonCardPalette

    var body: some View {
        HStack(spacing: DSSpacing.md) {
            Image(systemName: feature.systemImage)
                .font(DSFont.captionSemibold)
                .foregroundStyle(.white)
                .frame(
                    width: DSSize.large,
                    height: DSSize.large
                )
                .background(
                    RoundedRectangle(
                        cornerRadius: DSRadius.xsmall,
                        style: .continuous
                    )
                    .fill(palette.featureIconBackground)
                )

            Text(feature.title)
                .font(DSFont.fieldLabel)
                .foregroundStyle(palette.featureForeground)

            Spacer(minLength: .zero)
        }
        .padding(.vertical, DSPadding.small)
        .padding(.horizontal, DSPadding.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Capsule()
                .fill(palette.featureBackground)
        )
        .accessibilityHidden(true)
    }
}
