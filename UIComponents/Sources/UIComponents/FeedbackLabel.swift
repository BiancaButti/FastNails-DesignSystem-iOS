import SwiftUI

enum FeedbackTone: CaseIterable {
    case success
    case failure

    var color: Color {
        switch self {
        case .success:
            return Color.appOpenBadge
        case .failure:
            return Color.appClosedBadge
        }
    }

    var iconName: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .failure:
            return "exclamationmark.circle.fill"
        }
    }
}

struct FeedbackLabel: View {
    let message: String
    let tone: FeedbackTone

    init(message: String, tone: FeedbackTone) {
        self.message = message
        self.tone = tone
    }

    var body: some View {
        Label {
            Text(message)
        } icon: {
            Image(systemName: tone.iconName)
        }
        .font(.caption)
        .foregroundStyle(tone.color)
    }
}

struct SuccessLabel: View {
    let message: String

    init(message: String) {
        self.message = message
    }

    var body: some View {
        FeedbackLabel(message: message, tone: .success)
    }
}