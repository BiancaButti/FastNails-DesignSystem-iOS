import Foundation

// MARK: - DSLink

/// Defines a link with either an external URL destination or a custom action.
///
/// Use `DSLink` to represent navigational or actionable links while keeping the destination mechanism separate from the displayed title.
/// The destination can open a URL or execute a custom action such as internal navigation, analytics, or deep-link handling.
///
/// ```swift
/// DSLink(
///     "Terms of Service",
///     url: URL(string: "https://example.com/terms")!
/// )
/// ```
@available(iOS 16.0, *)
public struct DSLink {

    /// Defines the destination behavior associated with a `DSLink`.
    public enum Destination {
        /// Opens the specified URL using the system's web handling behavior.
        case url(URL)

        /// Executes a custom action when the link is activated.
        case action(() -> Void)
    }

    /// The text displayed for the link.
    public let title: String

    /// The destination behavior executed when the link is activated.
    public let destination: Destination

    /// Creates a link that opens an external URL.
    /// - Parameters:
    ///   - title: The text displayed for the link.
    ///   - url: The external URL opened when the link is activated.
    public init(_ title: String, url: URL) {
        self.title = title
        self.destination = .url(url)
    }

    /// Creates a link that executes a custom action.
    /// - Parameters:
    ///   - title: The text displayed for the link.
    ///   - action: The closure executed when the link is activated.
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.destination = .action(action)
    }
}
