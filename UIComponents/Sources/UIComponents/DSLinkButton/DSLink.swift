import Foundation

// MARK: - DSLink

/// A Design System link model. It can either open an external URL or execute a custom block
/// (useful for internal navigation, logging analytics, deep-linking, etc.).
@available(iOS 16.0, *)
public struct DSLink {
    
    /// The destination type for the link.
    public enum Destination {
        /// Opens a standard web browser URL.
        case url(URL)
        /// Executes a custom code block or local app action.
        case action(() -> Void)
    }
 
    /// The display text for the link.
    public let title: String
    
    /// The underlying destination mechanism.
    public let destination: Destination
 
    /// Initializes a link that opens an external web URL.
    public init(_ title: String, url: URL) {
        self.title = title
        self.destination = .url(url)
    }
 
    /// Initializes a link that triggers a custom action or code block.
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.destination = .action(action)
    }
}
