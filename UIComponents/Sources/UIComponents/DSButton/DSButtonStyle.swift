import SwiftUI

public enum DSButtonStyle {
    case primary
    case secondary
    case tertiary
}

public enum DSButtonTone {
    case brand
    case neutral
    case destructive
}

struct DSButtonAppearance {
    var background: Color
    var textColor: Color
    var borderColor: Color?
    
   init(
        style: DSButtonStyle,
        tone: DSButtonTone,
        theme: DSTheme
   ) {
       let accent: Color =
       switch tone {
       case .brand:
           theme.brandColor
       case .neutral:
           theme.titleColor
       case .destructive:
           theme.errorColor
       }
       
       switch style {
       case .primary:
           background = tone == .destructive ? theme.surfaceColor : accent
           textColor = tone == .destructive ? accent : .white
           borderColor = tone == .destructive ? accent : nil
       case .secondary:
           background = theme.surfaceColor
           textColor = accent
           borderColor = tone == .neutral ? theme.borderColor : accent
       case .tertiary:
           background = .clear
           textColor = tone == .neutral ? theme.secondaryColor : accent
           borderColor = nil
       }
   }
    
}
