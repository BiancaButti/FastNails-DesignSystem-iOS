import SwiftUI
// MARK: - DSNoticeItem Data Structure

/// Represents a single bullet-point row inside a ``DSNoticeCard``.
public struct DSNoticeItem: Hashable, Identifiable {
    public var id: String { title }
    
    let systemIconName: String
    let iconColor: Color
    let title: String
    
    public init(systemIconName: String, iconColor: Color, title: String) {
        self.systemIconName = systemIconName
        self.iconColor = iconColor
        self.title = title
    }
}
