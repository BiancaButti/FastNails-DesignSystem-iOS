import SwiftUI

struct ErrorLabel: View {
    let message: String

    init(message: String) {
        self.message = message
    }

    var body: some View {
        FeedbackLabel(message: message, tone: .failure)
    }
}
