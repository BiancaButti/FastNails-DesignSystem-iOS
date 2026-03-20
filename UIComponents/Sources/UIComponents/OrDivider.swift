import SwiftUI

struct OrDivider: View {
    var label: String = String(localized: "dividerOr")

    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.secondary.opacity(0.4))
                .accessibilityHidden(true)
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 8)
                .accessibilityHidden(true)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.secondary.opacity(0.4))
                .accessibilityHidden(true)
        }
    }
}
