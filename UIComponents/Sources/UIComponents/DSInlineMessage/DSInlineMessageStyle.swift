import SwiftUI

/// Defines the background and border styling for the banner component using Fast Nails tokens.
public enum DSInlineMessageStyle {
    case info
    case warning
    case error       
    
    var backgroundColor: Color {
        switch self {
        case .info:
            return DSColor.paper
        case .warning:
            return DSColor.amber.opacity(0.06)
        case .error:
            return DSColor.alert.opacity(0.06)
        }
    }
    
    var borderColor: Color {
        switch self {
        case .info:
            return DSColor.line
        case .warning:
            return DSColor.amber.opacity(0.2)
        case .error:
            return DSColor.alert.opacity(0.2)
        }
    }
    
    var actionColor: Color {
        switch self {
        case .info:
            return DSColor.enamel
        case .warning:
            return DSColor.amber
        case .error:
            return DSColor.terracotta
        }
    }
    
    var titleColor: Color {
        switch self {
        case .info, .warning:
            return DSColor.ink
        case .error:
            return DSColor.terracotta
        }
    }
}
