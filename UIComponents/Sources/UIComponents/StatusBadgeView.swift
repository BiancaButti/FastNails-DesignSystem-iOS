import SwiftUI

public struct StatusBadgeView: View {
    public enum Tone {
        case success
        case failure

        var backgroundColor: Color {
            switch self {
            case .success:
                return Color.appOpenBadge
            case .failure:
                return Color.appClosedBadge
            }
        }
    }

    let text: String
    let tone: Tone

    public init(isOpen: Bool) {
        self.text = isOpen ? String(localized: "homeBadgeOpenNow") : String(localized: "homeBadgeClosed")
        self.tone = isOpen ? .success : .failure
    }

    public init(text: String, tone: Tone) {
        self.text = text
        self.tone = tone
    }

    public var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(tone.backgroundColor)
            .clipShape(Capsule())
    }
}
