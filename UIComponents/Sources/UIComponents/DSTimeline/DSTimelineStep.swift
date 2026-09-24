import SwiftUI

public enum DSTimelineStepState: Equatable {
    case pending
    case current
    case completed
}

public struct DSTimelineStepItem: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let state: DSTimelineStepState
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        state: DSTimelineStepState = .pending
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.state = state
    }
}
