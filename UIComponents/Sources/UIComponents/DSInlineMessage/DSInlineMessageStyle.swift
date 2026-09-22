import SwiftUI

/// Defines the background and border styling for the banner component using Fast Nails tokens.
public enum DSInlineMessageStyle {
    case info
    case warning
    case error       
    
    var backgroundColor: Color {
        switch self {
        case .info:
            return Color.paper
        case .warning:
            return Color.amber.opacity(0.06)
        case .error:
            return Color.alert.opacity(0.06)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .info:
            return Color.line
        case .warning:
            return Color.amber.opacity(0.2)
        case .error:
            return Color.alert.opacity(0.2)
        }
    }
    
    var actionColor: Color {
        switch self {
        case .info:
            return Color.enamel
        case .warning:
            return Color.amber
        case .error:
            return Color.terracota
        }
    }
    
    var titleColor: Color {
        switch self {
        case .info, .warning:
            return Color.ink
        case .error:
            return Color.terracota
        }
    }
}
