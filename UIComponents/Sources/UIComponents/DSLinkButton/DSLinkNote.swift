import SwiftUI

// MARK: - DSLinkNote
 
/// A light box featuring either a standalone highlighted link or a block of text with inline links.
///
///     // Standalone link
///     DSLinkNote(link: DSLink("Forgot my password") { ... })
///
///     // Text with multiple inline links: each %@ is replaced by a link in sequential order.
///     // Use %1$@, %2$@ when a translation requires reordering the arguments.
///     DSLinkNote("By creating an account you agree to the %@ and %@.", links: terms, privacy)
@available(iOS 16.0, *)
public struct DSLinkNote: View {
    private enum Content {
        case link(DSLink)
        case text(format: String, links: [DSLink])
    }
 
    private let content: Content
    @Environment(\.openURL) private var openURL
 
    /// Variant for "no text": displays only the standalone highlighted link.
    public init(link: DSLink) {
        self.content = .link(link)
    }
 
    /// Variant for "with text": `format` should pass a pre-localized string.
    public init(_ format: String, links: DSLink...) {
        self.content = .text(format: format, links: links)
    }
 
    public init(_ format: String, links: [DSLink]) {
        self.content = .text(format: format, links: links)
    }
 
    @ViewBuilder
    public var body: some View {
        switch content {
        case .link(let link):
            Button { open(link) } label: {
                Text(link.title)
                    .font(.subheadline.weight(.semibold))
                    .underline()
                    .foregroundStyle(Color.enamel)
            }
            .buttonStyle(.plain)
            .padding(DSSpacing.controlPadding)
            .background(
                Color.surface,
                in: RoundedRectangle(cornerRadius: DSRadius.control, style: .continuous)
            )
 
        case .text(let format, let links):
            Text(Self.attributed(format: format, links: links))
                .font(.footnote)
                .foregroundStyle(.primary)
                .tint(.link)
                .multilineTextAlignment(.center)
                .environment(\.openURL, OpenURLAction { url in
                    guard url.scheme == Self.scheme,
                          let index = url.host.flatMap(Int.init),
                          links.indices.contains(index)
                    else { return .systemAction }
                    open(links[index])
                    return .handled
                })
                .padding(DSSpacing.controlPadding)
                .background(
                    Color.surface,
                    in: RoundedRectangle(cornerRadius: DSRadius.control, style: .continuous)
                )
        }
    }

 
    // MARK: - Helpers
 
    private func open(_ link: DSLink) {
        switch link.destination {
        case .url(let url): openURL(url)
        case .action(let action): action()
        }
    }
 
    /// Internal URL scheme utilized to detect which inline link index was tapped.
    private static let scheme = "dslink"
    
    // MARK: - AttributedString Builder
 
    private static func attributed(format: String, links: [DSLink]) -> AttributedString {
        var result = AttributedString()
        var currentPosition = format.startIndex
        var nextSequentialIndex = 0
        
        /// Safe initialization via explicit string compilation to completely bypass compiler syntax misinterpretation
        let placeholderRegex = try! Regex("%(?:(?<index>\\d+)\\$)?@")
 
        // Safely iterate through regex matches using Swift Substrings
        for match in format.matches(of: placeholderRegex) {
            // Append static text preceding the match
            let textBeforeMatch = format[currentPosition..<match.range.lowerBound]
            result += AttributedString(textBeforeMatch)
 
            // Determine the explicit or sequential index for this link parameter
            let index: Int
            if let indexOutput = match.output["index"]?.value as? String, let explicitIndex = Int(indexOutput) {
                index = explicitIndex - 1
            } else {
                index = nextSequentialIndex
                nextSequentialIndex += 1
            }
 
            // Build and style the inline link chunk if a corresponding token model exists
            if links.indices.contains(index) {
                var linkSnippet = AttributedString(links[index].title)
                linkSnippet.link = URL(string: "\(scheme)://\(index)")
                linkSnippet.swiftUI.underlineStyle = .single
                linkSnippet.swiftUI.foregroundColor = .link
                result += linkSnippet
            } else {
                // Safe Fallback: prints the raw match format placeholder if the programmer forgot a link mapping
                result += AttributedString(format[match.range])
            }
            
            currentPosition = match.range.upperBound
        }
 
        // Append any trailing static text leftover at the end of the string
        let remainingText = format[currentPosition..<format.endIndex]
        result += AttributedString(remainingText)
        return result
    }

}
