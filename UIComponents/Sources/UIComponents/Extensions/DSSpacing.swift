import SwiftUI

// MARK: - DSSpacing

/// Spacing and padding scale.
///
/// Always use these values instead of raw numbers: a global adjustment becomes
/// a single line change, and spacing remains consistent across all screens.
///
/// ```swift
/// .padding(DSSpacing.md)
/// VStack(spacing: DSSpacing.sm) { ... }
/// ```
public enum DSSpacing {
    
    // MARK: - Raw Scales
    
    /// 4 pt — between icon and text.
    public static let xs: CGFloat = 4
    
    /// 8 pt — between related elements.
    public static let sm: CGFloat = 8
    
    /// 12 pt — inside fields and cells.
    public static let md: CGFloat = 12
    
    /// 16 pt — standard screen lateral margins.
    public static let lg: CGFloat = 16
    
    /// 24 pt — inside cards, between block elements.
    public static let xl: CGFloat = 24
    
    /// 32 pt — separation between major sections.
    public static let xxl: CGFloat = 32
    
    // MARK: - Composite Insets
    
    /// Default padding for standard control elements (e.g., text fields or cells).
    /// Top/Bottom: 10 pt, Leading/Trailing: 12 pt (md).
    public static let controlPadding = EdgeInsets(top: 10,
                                                  leading: DSSpacing.md,
                                                  bottom: 10,
                                                  trailing: DSSpacing.md)
}
