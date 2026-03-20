import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    var color: Color = .accentColor
    var accessibilityHint: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isEnabled ? color : Color(.systemGray4))
                .foregroundColor(isEnabled ? .white : Color(.systemGray))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
        .accessibilityLabel(title)
        .accessibilityHint(accessibilityHint ?? "")
    }
}
