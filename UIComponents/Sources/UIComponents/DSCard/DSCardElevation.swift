import Foundation

/// Intensity of the shadow cast beneath the card.
public enum DSCardElevation {
    /// No shadow. Use with `borderColor` in dense lists.
    case none
    /// A barely perceptible shadow, for cards that repeat on screen.
    case subtle
    /// The default shadow, for cards floating over a colored background.
    case raised

    var radius: CGFloat {
        switch self {
        case .none: return 0
        case .subtle: return DSRadius.control
        case .raised: return DSRadius.large
        }
    }

    var opacity: Double {
        switch self {
        case .none: return 0
        case .subtle: return 0.04
        case .raised: return 0.06
        }
    }

    var offsetY: CGFloat {
        switch self {
        case .none: return 0
        case .subtle: return 3
        case .raised: return 10
        }
    }
}
