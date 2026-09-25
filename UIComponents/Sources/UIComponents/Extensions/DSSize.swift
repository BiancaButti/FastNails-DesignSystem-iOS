import SwiftUI

// MARK: - DSSize

/// Size scale for frames, widths, heights, and component dimensions (4pt grid).
///
/// The documentation values, named by sizing scale and ordered from smallest to largest.
public enum DSSize {
    /// 4 pt — xsmall
    public static let xsmall: CGFloat = 4
    
    /// 8 pt — small
    public static let small: CGFloat = 8
    
    /// 12 pt — mediumCompact
    public static let mediumCompact: CGFloat = 12
    
    /// 16 pt — medium
    public static let medium: CGFloat = 16
    
    /// 20 pt — mediumLarge
    public static let mediumLarge: CGFloat = 20
    
    /// 24 pt — large
    public static let large: CGFloat = 24
    
    /// 32 pt — xlarge
    public static let xlarge: CGFloat = 32
    
    /// 40 pt — xxlarge
    public static let xxlarge: CGFloat = 40
    
    /// 44 pt — touchTarget. Minimum accessible size for interactive elements.
    public static let touchTarget: CGFloat = 44
    
    /// 48 pt — huge. Standard button heights or avatar sizes.
    public static let huge: CGFloat = 48
    
    /// 52 pt — xhuge
    public static let xhuge: CGFloat = 52
    
    /// 56 pt — jumbo. Large fields or prominent action bars.
    public static let jumbo: CGFloat = 56
    
    /// 290 pt — containerSmall. Used to bound widths for standard content cards, narrow dialogs, or side sheets.
    public static let containerSmall: CGFloat = 290
}


// MARK: - DSLayoutIndex (zIndex)
/// Visual layering hierarchy (Z-Axis orchestration).
public enum DSLayoutIndex {
    /// 1 — Base layer for elements that need to sit slightly above the default background content.
        public static let base: Double = 1
    /// 10 — Sticky headers, top navigation bars, or floating action buttons.
    public static let sticky: Int = 10
    /// 100 — Global overlays, fullscreen dimmers, or modal sheets.
    public static let overlay: Int = 100
    /// 999 — Critical alerts, system toasts, or global loaders.
    public static let critical: Int = 999
}

// MARK: - DSTypography (lineLimit)
/// Standardized text constraints for content density and hierarchy.
public enum DSTextLimit {
    /// 1 line — Strict limit for titles, action labels, and headings.
    public static let title: Int = 1
    /// 2 lines — Optimal threshold for card subtitles or description snippets.
    public static let description: Int = 2
    /// 3 lines — Maximum density for list body text previews before truncation.
    public static let summary: Int = 3
}

// MARK: - DSBorder (lineWidth)
/// Structural dividers, control strokes, and outline variations.
public enum DSBorder {
    /// 1 pt — Default thin divider or subtle component hairline border.
    public static let thin: CGFloat = 1
    /// 2 pt — Focused input borders, selection indicators, or active badge outlines.
    public static let heavy: CGFloat = 2
}

// MARK: - DSShadowOffset (y for shadow)
/// Vertical displacement variations representing simulated depth light sources.
public enum DSShadowOffset {
    /// 2 pt — Subtle elevation accent for flat buttons or nested components.
    public static let subtle: CGFloat = 2
    /// 4 pt — Standard elevated offset for floating cards and surface headers.
    public static let regular: CGFloat = 4
    /// 8 pt — Deep vertical depth for dropdowns, custom modaldialogs, or context sheets.
    public static let deep: CGFloat = 8
}

// MARK: - DSAnimation
/// Standardized motion tokens for spring and linear animations.
public enum DSAnimation {
        /// 0.3s response — Standard duration for fast/snappy screen responses.
        public static let response: Double = 0.3
        
        /// 0.8 fraction — Smooth damping that prevents overshoot or heavy bouncing.
        public static let dampingFraction: Double = 0.8
    
    /// 0.15s duration — Fast state changes (toggles, tab switches, subtle fades).
       public static let fastDuration: Double = 0.15
    
    /// Snappy spring for quick interactive selections or tab shifts.
            public static let snappyResponse: Double = 0.25
            public static let snappyDamping: Double = 0.75
}

// Novo arquivo ou namespace de tipografia:
public enum DSTracking {
    /// 1.2 pt — upperTag. Tight tracking for uppercase labels and technical tags.
    public static let upperTag: CGFloat = 1.2
}
