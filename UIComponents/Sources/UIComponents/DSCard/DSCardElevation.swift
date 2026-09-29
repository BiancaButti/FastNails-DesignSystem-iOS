import Foundation

// MARK: - DSCardElevation

/// Defines the elevation level and shadow depth of a design system card.
///
/// Use `DSCardElevation` to control the perceived depth of a card through its shadow radius, opacity, and vertical offset.
public enum DSCardElevation {
    /// Displays the card without a shadow.
    case none

    /// Displays a subtle shadow for low-elevation containers.
    case subtle

    /// Displays the default elevated shadow for prominent containers.
    case raised

    /// The shadow blur radius associated with the elevation level.
    var radius: CGFloat {
        switch self {
        case .none:
            return 0
        case .subtle:
            return DSRadius.control
        case .raised:
            return DSRadius.large
        }
    }

    /// The shadow opacity associated with the elevation level.
    var opacity: Double {
        switch self {
        case .none:
            return 0
        case .subtle:
            return 0.04
        case .raised:
            return 0.06
        }
    }

    /// The vertical offset applied to the shadow.
    var offsetY: CGFloat {
        switch self {
        case .none:
            return 0
        case .subtle:
            return 3
        case .raised:
            return 10
        }
    }
}
