import SwiftUI

public struct ErrorLabel: View {
    let message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        FeedbackLabel(message: message, tone: .failure)
    }
}
