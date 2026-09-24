import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Families

/// The three font families for Fast Nails.
///
/// **As long as the font files are not present in the package, each family falls back to an equivalent system font.**
/// Client code will not change when they arrive — only `isInstalled` will start returning `true`.
public enum DSFontFamily {

    /// Titles and brand name.
    case display
    /// Body text, labels, buttons.
    case body
    /// Numbers, codes, technical uppercase labels.
    case mono

    /// Font name when it exists in the bundle.
    var name: String {
        switch self {
        case .display: "BricolageGrotesque-Bold"
        case .body: "Karla-Regular"
        case .mono: "SpaceMono-Regular"
        }
    }

    /// System design fallback used until the custom font arrives.
    var systemFallback: Font.Design {
        switch self {
        case .display: .default
        case .body: .default
        case .mono: .monospaced
        }
    }

    var isInstalled: Bool {
        #if canImport(UIKit)
        UIFont(name: name, size: 12) != nil
        #else
        false
        #endif
    }
}

// MARK: - Scale

/// Typography for Fast Nails based on a strict Base-4 Type Scale (8, 12, 16, 20, 24, 28, 32).
///
/// All fonts are **relative to a text style**, meaning they support Dynamic Type.
/// Use these static properties to ensure UI consistency across the app.
public enum DSFont {

    /// Internal builder that falls back to the system font if the custom family is not installed.
    private static func font(
        _ family: DSFontFamily,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle,
        weight: Font.Weight
    ) -> Font {
        if family.isInstalled {
            return .custom(family.name, size: size, relativeTo: textStyle).weight(weight)
        }
        return .system(textStyle, design: family.systemFallback).weight(weight)
    }

    // MARK: - Large Display & Titles (Display)
    
    /// Hero headers, large metrics or promotional splash titles. 32pt.
    public static let heroTitle = font(.display, size: 32, relativeTo: .largeTitle, weight: .bold)
    
    /// Main screen titles and brand highlights. 28pt.
    public static let bigTitle = font(.display, size: 28, relativeTo: .title, weight: .bold)

    /// Section titles, block headers, or card headlines. 20pt.
    public static let title = font(.display, size: 20, relativeTo: .title3, weight: .bold)

    /// Secondary subsection headers. 16pt.
    public static let sectionHeader = font(.display, size: 16, relativeTo: .headline, weight: .semibold)

    // MARK: - Descriptions & Body (Body)

    /// Standard description text, paragraphs, and list items. 16pt.
    public static let description = font(.body, size: 16, relativeTo: .body, weight: .regular)

    /// Bold emphasis for body text or important descriptions. 16pt.
    public static let descriptionBold = font(.body, size: 16, relativeTo: .body, weight: .semibold)

    /// Secondary metadata, detailed captions, or smaller description text. 12pt.
    public static let caption = font(.body, size: 12, relativeTo: .caption, weight: .regular)
    
    /// Small caption header with semibold weight. 12pt.
    public static let captionSemibold = font(.display, size: 12, relativeTo: .caption, weight: .semibold)

    // MARK: - Forms & Inputs (Body)

    /// Text field and input labels. 12pt.
    public static let fieldLabel = font(.body, size: 12, relativeTo: .subheadline, weight: .medium)

    /// Supporting text below inputs or error messages. 12pt.
    public static let inputSupport = font(.body, size: 12, relativeTo: .footnote, weight: .regular)

    /// Highlighted supporting text for inputs. 12pt.
    public static let inputSupportBold = font(.body, size: 12, relativeTo: .footnote, weight: .semibold)

    // MARK: - Controls & Navigation

    /// Primary and secondary action buttons text. 16pt.
    public static let button = font(.body, size: 16, relativeTo: .body, weight: .semibold)
    
    /// Tab bar label text. 16pt.
    public static let tabLabel = font(.display, size: 16, relativeTo: .caption2, weight: .medium)

    // MARK: - Technical & Utilities (Mono)

    /// OTP or verification code digits. 24pt.
    public static let codeDigit = font(.mono, size: 24, relativeTo: .title2, weight: .bold)

    /// Prices, times, numeric countdowns, or currency values. 16pt.
    public static let numericValue = font(.mono, size: 16, relativeTo: .body, weight: .bold)

    /// Status badges or indicators inside tags. 12pt.
    public static let badge = font(.mono, size: 12, relativeTo: .caption2, weight: .semibold)
    
    /// Uppercase technical metadata tags. 8pt.
    ///
    /// *Note: Remember to manually chain `.tracking(1.2)` and `.textCase(.uppercase)` on the Text view when using this.*
    public static let technicalTag = font(.mono, size: 8, relativeTo: .caption2, weight: .regular)
    
    // MARK: - Dynamic & Components
    
    /// A dynamic bold font calculated from a base size component.
    ///
    /// It automatically forces the resulting size to align with the **strict Base-4 scale**.
    /// - Parameter size: The reference size variable.
    /// - Returns: A bold font aligned to the nearest multiple of 4.
    public static func dynamicBold(scaledFrom size: CGFloat) -> Font {
        let rawSize = size * 0.38
        // Força o arredondamento matemático para o múltiplo de 4 mais próximo (mínimo de 8pt)
        let strictSize = max(8, CGFloat(Int((rawSize + 2) / 4) * 4))
        
        // Utiliza a sua família de títulos (.display) para manter o peso forte
        return font(.display, size: strictSize, relativeTo: .body, weight: .bold)
    }

    // MARK: - Dynamic & Components
    
    /// A dynamic regular font calculated from a base size component (e.g., for proportional label scales).
    ///
    /// It automatically forces the resulting size to align with the **strict Base-4 scale**.
    /// - Parameter size: The reference size variable.
    /// - Returns: A regular font aligned to the nearest multiple of 4.
    public static func dynamicRegular(scaledFrom size: CGFloat) -> Font {
        let rawSize = size * 0.4
        // Força o arredondamento matemático para o múltiplo de 4 mais próximo (mínimo de 8pt)
        let strictSize = max(8, CGFloat(Int((rawSize + 2) / 4) * 4))
        
        // Utiliza a sua família padrão de corpo (.body) com peso regular
        return font(.body, size: strictSize, relativeTo: .body, weight: .regular)
    }

}

// MARK: - Font Registration

public extension DSFont {

    /// Registers the fonts bundled in the package. Call this once at app startup.
    static func register() {
        #if canImport(UIKit)
        for family in [DSFontFamily.display, .body, .mono] {
            guard
                let url = Bundle.module.url(forResource: family.name, withExtension: "ttf")
            else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
        #endif
    }
}
