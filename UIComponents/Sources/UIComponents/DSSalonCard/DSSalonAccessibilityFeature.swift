import SwiftUI

// MARK: - Accessibility feature

/// An accessibility attribute of a salon, shown as a tag in the card's footer.
public struct DSSalonAccessibilityFeature: Identifiable, Hashable {
    public let id: String
    /// SF Symbol name.
    public let systemImage: String
    /// Text shown on the tag.
    public let title: String
    /// Text read by VoiceOver. When `nil`, falls back to `title`.
    public let spokenLabel: String?

    public init(
        id: String = UUID().uuidString,
        systemImage: String,
        title: String,
        spokenLabel: String? = nil
    ) {
        self.id = id
        self.systemImage = systemImage
        self.title = title
        self.spokenLabel = spokenLabel
    }

    var accessibilityText: String { spokenLabel ?? title }

    /// Step-free entrance: no steps, a ramp, or a level floor.
    public static let semDegrau = DSSalonAccessibilityFeature(
        id: "sem-degrau",
        systemImage: "figure.roll",
        title: "Acesso sem degrau"
    )

    /// Wheelchair-accessible restroom.
    public static let banheiroAdaptado = DSSalonAccessibilityFeature(
        id: "banheiro-adaptado",
        systemImage: "toilet",
        title: "Banheiro adaptado"
    )

    /// A professional who communicates in Libras (Brazilian Sign Language).
    public static let atendimentoEmLibras = DSSalonAccessibilityFeature(
        id: "libras",
        systemImage: "hands.sparkles",
        title: "Atendimento em Libras"
    )
}
