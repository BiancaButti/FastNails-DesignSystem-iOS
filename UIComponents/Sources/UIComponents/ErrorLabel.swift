import SwiftUI

struct ErrorLabel: View {
    let message: String

    var body: some View {
        Label {
            Text(message)
        } icon: {
            Image(systemName: "exclamationmark.circle.fill")
        }
        .font(.caption)
        .foregroundColor(.red)
    }
}
