import SwiftUI

// MARK: - Accessibility tag

/// A visual pill that advertises a single accessibility feature of a salon
/// (e.g. "Step-free access") inside a ``DSSalonCard``.
///
/// This view is intentionally decorative: it is marked `accessibilityHidden`
/// because the salon's accessibility features are spoken by the parent
/// ``DSSalonCard`` as part of its combined accessibility label, following the
/// product's fixed reading order (name, price, distance, availability,
/// accessibility). Exposing each tag separately would make VoiceOver announce
/// the same information twice and break that order.
struct DSSalonCardAccessibilityTag: View {
    let feature: DSSalonAccessibilityFeature
    let palette: DSSalonCardPalette

    var body: some View {
        HStack(spacing: DSSpacing.md) {
            Image(systemName: feature.systemImage)
                .font(DSFont.captionSemibold)
                .foregroundStyle(.white)
                .frame(width: DSSize.large,
                       height: DSSize.large)
                .background(
                    RoundedRectangle(
                        cornerRadius: DSRadius.xsmall,
                        style: .continuous)
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
        .background(Capsule().fill(palette.featureBackground))
        .accessibilityHidden(true)
    }
}

