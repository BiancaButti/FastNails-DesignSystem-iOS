import SwiftUI

// MARK: - DSPadding

/// Padding scale for component internal structures and screen edges.
///
/// The documentation values, named by usage and ordered from smallest to largest.
public enum DSPadding {
    /// 4 pt — xsmall. Micro adjustments, icon-to-text spacing, or tight internal edges.
    public static let xsmall: CGFloat = 4

    /// 8 pt — small. Standard small padding for tight elements, badges, or button contents.
    public static let small: CGFloat = 8

    /// 12 pt — medium. Compact padding for smaller components or grouped content blocks.
    public static let medium: CGFloat = 12

    /// 16 pt — regular. Standard padding for screen edges, content cards, and list rows.
    public static let regular: CGFloat = 16

    /// 20 pt — mediumLarge. Intermediate padding for custom layouts or inner containers.
    public static let mediumLarge: CGFloat = 20

    /// 24 pt — large. Generous padding used for bottom elements, section gaps, or modal footers.
    public static let large: CGFloat = 24

    /// 32 pt — xlarge. Wide padding for section separation or breathing room between card blocks.
    public static let xlarge: CGFloat = 32

    /// 40 pt — xxlarge. Very wide padding, often used as top/bottom margins for prominent headers.
    public static let xxlarge: CGFloat = 40

    /// 48 pt — huge. Massive padding for illustration layouts, welcome screens, or hero areas.
    public static let huge: CGFloat = 48

    /// 56 pt — xhuge. Maximum layout padding for deep vertical stack constraints.
    public static let xhuge: CGFloat = 56
    
    // MARK: - Composite Insets
    
    /// Default padding for standard control elements (e.g., text fields or cells).
    /// Top/Bottom: 10 pt, Leading/Trailing: 12 pt (md).
    public static let controlPadding = EdgeInsets(top: 10,
                                                  leading: medium,
                                                  bottom: 10,
                                                  trailing: medium)
}
