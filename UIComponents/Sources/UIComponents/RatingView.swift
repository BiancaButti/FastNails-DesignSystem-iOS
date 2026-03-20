import SwiftUI

struct RatingView: View {

    enum Style {
        /// Single star + number. Accessibility hidden (row handles its own label).
        case compact
        /// Five stars (fill/half/empty) + number. Has its own accessibility label.
        case expanded
    }

    let rating: Double
    let style: Style

    var body: some View {
        switch style {
        case .compact:
            compactView
                .accessibilityHidden(true)
        case .expanded:
            expandedView
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    String(format: String(localized: "manicuristProfileRatingAccessibility"),
                           String(format: "%.1f", rating))
                )
        }
    }
}

// MARK: - Subviews

private extension RatingView {

    var compactView: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .foregroundStyle(Color.appRating)
                .font(.caption2)
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    var expandedView: some View {
        HStack(spacing: 6) {
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: starIcon(for: index))
                        .foregroundStyle(Color.appRating)
                        .font(.subheadline)
                }
            }
            .accessibilityHidden(true)

            Text(String(format: "%.1f", rating))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Helpers

private extension RatingView {

    func starIcon(for index: Int) -> String {
        if Double(index) <= rating.rounded(.down) {
            return "star.fill"
        } else if Double(index) - rating < 1 && rating.truncatingRemainder(dividingBy: 1) >= 0.5 {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}
