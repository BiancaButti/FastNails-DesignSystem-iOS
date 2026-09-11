import SwiftUI

public enum MaskFormatation {
    case address
    case telephone
    case email
    case name
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .address, .name:
            return .default
        case .telephone:
            return .numberPad
        case .email:
            return .emailAddress
        }
    }
}

