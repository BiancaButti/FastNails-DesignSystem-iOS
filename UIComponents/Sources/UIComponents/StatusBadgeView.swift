import SwiftUI

struct StatusBadgeView: View {

    let isOpen: Bool

    var body: some View {
        Text(isOpen ? String(localized: "homeBadgeOpenNow") : String(localized: "homeBadgeClosed"))
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(isOpen ? Color.appOpenBadge : Color.appClosedBadge)
            .clipShape(Capsule())
    }
}
