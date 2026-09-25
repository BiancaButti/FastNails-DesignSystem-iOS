import SwiftUI

// MARK: - DSRadius

/// Radius scale.
///
/// The documentation values, named by usage and ordered from smallest to largest.
public enum DSRadius {
    /// 4 pt — xsmall. Micro components, checkboxes, tags, or small indicators.
    public static let xsmall: CGFloat = 4

    /// 8 pt — small. Small components, badges, or inner borders.
    public static let small: CGFloat = 8
    
    /// 12 pt — control. Buttons and fields.
    public static let control: CGFloat = 12
    
    /// 16 pt — large. Cards and elevated surfaces.
    public static let large: CGFloat = 16
    
    /// 18 pt — xlarge. Deeply elevated surfaces or container elements.
    public static let xlarge: CGFloat = 18
    
    /// 20 pt — xxlarge. Large containers, bottom sheets, or main screens.
    public static let xxlarge: CGFloat = 20
    
    /// 24 pt — large. Generous padding used for bottom elements, section gaps, or modal footers.
    public static let mediumHuge: CGFloat = 24
    
    /// 48 pt — huge. Massive padding for illustration layouts, welcome screens, or hero areas.
    public static let huge: CGFloat = 48
}
