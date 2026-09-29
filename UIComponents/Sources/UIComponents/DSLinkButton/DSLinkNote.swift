import SwiftUI

// MARK: - DSLinkNote

/// Displays a highlighted link or localized text containing multiple inline links.
///
/// Use `DSLinkNote` for contextual actions such as terms, privacy policies, or recovery links.
/// It supports both standalone links and formatted text with sequential or explicitly indexed link placeholders.
///
/// ```swift
/// DSLinkNote(
///     "By creating an account you agree to the %@ and %@.",
///     links: terms,
///     privacy
/// )
/// ```
///
/// ## Accessibility
/// Standalone and inline links are exposed as interactive controls and activate their associated `DSLink` destinations.
@available(iOS 16.0, *)
public struct DSLinkNote: View {
    /// Defines the content presentation mode used by the link note.
    private enum Content {
        /// Displays a single standalone link.
        case link(DSLink)

        /// Displays formatted text containing one or more inline links.
        case text(format: String, links: [DSLink])
    }

    /// The content configuration rendered by the note.
    private let content: Content

    /// The environment action used to open external URLs.
    @Environment(\.openURL) private var openURL

    /// Creates a `DSLinkNote` containing a standalone highlighted link.
    /// - Parameter link: The link displayed and activated by the note.
    public init(link: DSLink) {
        self.content = .link(link)
    }

    /// Creates a `DSLinkNote` containing localized text with inline links.
    ///
    /// Place `%@` placeholders in `format` for sequential link insertion.
    /// Use `%1$@`, `%2$@`, and similar placeholders when a localized string requires explicit argument ordering.
    ///
    /// - Parameters:
    ///   - format: The localized text containing link placeholders.
    ///   - links: The links inserted into the placeholders in sequential or explicit index order.
    public init(_ format: String, links: DSLink...) {
        self.content = .text(
            format: format,
            links: links
        )
    }

    /// Creates a `DSLinkNote` containing localized text with inline links.
    ///
    /// Place `%@` placeholders in `format` for sequential link insertion.
    /// Use `%1$@`, `%2$@`, and similar placeholders when a localized string requires explicit argument ordering.
    ///
    /// - Parameters:
    ///   - format: The localized text containing link placeholders.
    ///   - links: The links inserted into the placeholders in sequential or explicit index order.
    public init(_ format: String, links: [DSLink]) {
        self.content = .text(
            format: format,
            links: links
        )
    }

    @ViewBuilder
    public var body: some View {
        switch content {
        case .link(let link):
            Button {
                open(link)
            } label: {
                Text(link.title)
                    .font(DSFont.sectionHeader)
                    .underline()
                    .foregroundStyle(DSColor.enamel)
            }
            .buttonStyle(.plain)
            .padding(DSPadding.controlPadding)
            .background(
                DSColor.surface,
                in: RoundedRectangle(
                    cornerRadius: DSRadius.control,
                    style: .continuous
                )
            )

        case .text(let format, let links):
            Text(
                Self.attributed(
                    format: format,
                    links: links
                )
            )
            .font(DSFont.inputSupport)
            .foregroundStyle(.primary)
            .tint(DSColor.link)
            .multilineTextAlignment(.center)
            .environment(
                \.openURL,
                OpenURLAction { url in
                    guard url.scheme == Self.scheme,
                          let index = url.host.flatMap(Int.init),
                          links.indices.contains(index)
                    else {
                        return .systemAction
                    }

                    open(links[index])
                    return .handled
                }
            )
            .padding(DSPadding.controlPadding)
            .background(
                DSColor.surface,
                in: RoundedRectangle(
                    cornerRadius: DSRadius.control,
                    style: .continuous
                )
            )
        }
    }

    // MARK: - Helpers

    /// Opens a link using its configured destination.
    /// - Parameter link: The link whose destination should be activated.
    private func open(_ link: DSLink) {
        switch link.destination {
        case .url(let url):
            openURL(url)

        case .action(let action):
            action()
        }
    }

    /// The internal URL scheme used to identify inline link indices.
    private static let scheme = "dslink"

    // MARK: - AttributedString Builder

    /// Builds the attributed text used to render localized inline links.
    ///
    /// Sequential `%@` placeholders consume links in order, while indexed placeholders such as `%1$@`
    /// reference a specific link. An escaped `%%` is rendered as a literal percent sign.
    ///
    /// - Parameters:
    ///   - format: The localized string containing link placeholders.
    ///   - links: The links available for placeholder substitution.
    /// - Returns: An attributed string containing the formatted text and interactive links.
    static func attributed(
        format: String,
        links: [DSLink]
    ) -> AttributedString {
        var result = AttributedString()
        var currentPosition = format.startIndex
        var nextSequentialIndex = 0

        let placeholderRegex = try! Regex(
            "%%|%(?:(?<index>\\d+)\\$)?@"
        )

        for match in format.matches(of: placeholderRegex) {
            let textBeforeMatch = format[
                currentPosition..<match.range.lowerBound
            ]

            result += AttributedString(textBeforeMatch)

            if format[match.range] == "%%" {
                result += AttributedString("%")
                currentPosition = match.range.upperBound
                continue
            }

            let index: Int

            if let indexOutput = match.output["index"]?.substring,
               let explicitIndex = Int(indexOutput) {
                index = explicitIndex - 1
            } else {
                index = nextSequentialIndex
                nextSequentialIndex += 1
            }

            if links.indices.contains(index) {
                var linkSnippet = AttributedString(
                    links[index].title
                )

                linkSnippet.link = URL(
                    string: "\(scheme)://\(index)"
                )
                linkSnippet.swiftUI.underlineStyle = .single
                linkSnippet.swiftUI.foregroundColor = DSColor.link

                result += linkSnippet
            } else {
                result += AttributedString(
                    format[match.range]
                )
            }

            currentPosition = match.range.upperBound
        }

        let remainingText = format[
            currentPosition..<format.endIndex
        ]

        result += AttributedString(remainingText)

        return result
    }
}
