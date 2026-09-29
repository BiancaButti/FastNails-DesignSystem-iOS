import SwiftUI

// MARK: - Accessibility feature

/// Describes an accessibility feature available at a salon.
///
/// `DSSalonAccessibilityFeature` represents an accessibility attribute that can
/// be displayed as a tag in a salon card. Each feature contains an SF Symbol,
/// a visible title, and an optional label used by assistive technologies such
/// as VoiceOver.
///
/// Use the predefined static properties when one of the standard accessibility
/// features is required, or initialize the type directly to represent a
/// custom feature.
///
/// Example:
///
/// ```swift
/// let feature = DSSalonAccessibilityFeature(
///     systemImage: "figure.roll",
///     title: "Acesso sem degrau"
/// )
/// ```
///
/// - Note: When `spokenLabel` is `nil`, VoiceOver uses the value of `title`.
public struct DSSalonAccessibilityFeature: Identifiable, Hashable {

    /// A unique identifier for the accessibility feature.
    ///
    /// This value is used to identify the feature when working with SwiftUI
    /// collections such as `ForEach`.
    public let id: String

    /// The name of the SF Symbol displayed for the feature.
    ///
    /// The value must correspond to a valid SF Symbol name supported by the
    /// target operating system.
    public let systemImage: String

    /// The text displayed to the user on the accessibility feature tag.
    public let title: String

    /// An optional accessibility label read by VoiceOver.
    ///
    /// When this value is `nil`, the feature's `title` is used instead.
    ///
    /// Use this property when the visible text needs to be shorter or more
    /// descriptive when announced by assistive technologies.
    public let spokenLabel: String?

    /// Creates an accessibility feature.
    ///
    /// - Parameters:
    ///   - id: A unique identifier for the feature. Defaults to a newly
    ///     generated UUID string.
    ///   - systemImage: The name of the SF Symbol used to represent the
    ///     feature.
    ///   - title: The text displayed on the feature tag.
    ///   - spokenLabel: An optional label announced by VoiceOver. If `nil`,
    ///     `title` is used instead.
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

    /// The text used when the feature is announced by assistive technologies.
    ///
    /// If a custom `spokenLabel` was provided, it is returned. Otherwise,
    /// the visible `title` is used as the accessibility text.
    var accessibilityText: String {
        spokenLabel ?? title
    }

    /// Indicates that the salon has step-free access.
    ///
    /// This feature represents an entrance with no steps, a ramp, or a
    /// level-access floor.
    public static let semDegrau = DSSalonAccessibilityFeature(
        id: "sem-degrau",
        systemImage: "figure.roll",
        title: "Acesso sem degrau"
    )

    /// Indicates that the salon has an accessible restroom.
    ///
    /// This feature represents a restroom adapted for wheelchair users
    /// or other accessibility requirements.
    public static let banheiroAdaptado = DSSalonAccessibilityFeature(
        id: "banheiro-adaptado",
        systemImage: "toilet",
        title: "Banheiro adaptado"
    )

    /// Indicates that the salon provides service in Libras.
    ///
    /// Libras is the Brazilian Sign Language (Língua Brasileira de Sinais).
    public static let atendimentoEmLibras = DSSalonAccessibilityFeature(
        id: "libras",
        systemImage: "hands.sparkles",
        title: "Atendimento em Libras"
    )
}
