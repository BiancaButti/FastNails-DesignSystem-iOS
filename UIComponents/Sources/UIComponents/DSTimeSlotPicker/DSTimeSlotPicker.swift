import SwiftUI

/// A grid-based time slot selection component for the Fast Nails Design System.
public struct DSTimeSlotPicker: View {
    private let sectionTitle: String
    private let slots: [DSTimeSlotPickerItem] // 🛠️ Corrigido o tipo do modelo aqui
    let onSlotSelected: (DSTimeSlotPickerItem) -> Void // 🛠️ Corrigido o tipo do modelo aqui
    
    // Defines a clean 3-column grid layout where columns scale equally
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    /// Public initializer structured for the SPM package.
    /// - Parameters:
    ///   - sectionTitle: The descriptive category text above the grid (e.g., "TARDE").
    ///   - slots: The list of `TimeSlotItem` objects to render inside the grid.
    ///   - onSlotSelected: Closure executed when an available time slot is tapped.
    public init(
        sectionTitle: String,
        slots: [DSTimeSlotPickerItem], // 🛠️ Corrigido o tipo do modelo aqui
        onSlotSelected: @escaping (DSTimeSlotPickerItem) -> Void // 🛠️ Corrigido o tipo do modelo aqui
    ) {
        self.sectionTitle = sectionTitle
        self.slots = slots
        self.onSlotSelected = onSlotSelected
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section categorization title (e.g., TARDE)
            Text(sectionTitle.uppercased())
                .font(DSFont.captionSemibold)
                .foregroundColor(.ink60)
                .padding(.leading, 4)
            
            // Time Slots Adaptive Grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(slots) { slot in
                    Button {
                        if slot.isAvailable {
                            onSlotSelected(slot)
                        }
                    } label: {
                        Text(slot.time)
                            // 🛠️ Sintaxe limpa corrigida aqui
                            .font(slot.isSelected ? DSFont.descriptionBold : DSFont.description)
                            .foregroundColor(textColor(for: slot))
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .background(backgroundColor(for: slot))
                            .cornerRadius(12)
                            .overlay(
                                borderView(for: slot)
                            )
                    }
                    .disabled(!slot.isAvailable)
                }
            }
            .buttonStyle(.plain) // 💡 Aplicado no Grid unificado
        }
        .padding(20)
        .background(Color.paper)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.line, lineWidth: 1)
        )
    }
    
    // MARK: - UI Helper Style Mappings
    
    private func textColor(for slot: DSTimeSlotPickerItem) -> Color { // 🛠️ Corrigido o tipo do modelo aqui
        if !slot.isAvailable {
            return .line // Faded out text color for disabled slots
        } else if slot.isSelected {
            return .paper // Crisp text color over deep background
        } else {
            return .ink // Standard text color
        }
    }
    
    private func backgroundColor(for slot: DSTimeSlotPickerItem) -> Color { // 🛠️ Corrigido o tipo do modelo aqui
        if !slot.isAvailable {
            return .paper2 // Matches the grayish-pink tint background for unavailable items
        } else if slot.isSelected {
            return .ink // Filled selection color matching prior picker behavior
        } else {
            return .paper // Standard flat background resting inside the card
        }
    }
    
    // MARK: - UI Helper Border View
    
    @ViewBuilder
    private func borderView(for slot: DSTimeSlotPickerItem) -> some View {
        if slot.isAvailable && !slot.isSelected {
            // Outlined gray border for untouched available slots
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.line, lineWidth: 1)
        } else if !slot.isAvailable {
            // Strikethrough line overlay to match the image requirement for locked hours
            LineStrikethrough()
                .stroke(Color.line, lineWidth: 1)
                .padding(.horizontal, 16)
        } else {
            EmptyView()
        }
    }
} // ⚠️ Aqui fecha a struct DSTimeSlotPicker

// MARK: - Helper Shapes

/// Custom shape to draw a neat diagonal strikethrough over unavailable slots.
/// **Mantenha esta struct aqui, fora da DSTimeSlotPicker mas no mesmo arquivo.**
struct LineStrikethrough: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
