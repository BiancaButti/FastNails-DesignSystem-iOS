import SwiftUI

public extension View {

    /// Sets the ``DSStatusCardVariant`` for every ``DSStatusCard`` in this
    /// view hierarchy.
    func statusCardVariant(_ variant: DSStatusCardVariant) -> some View {
        environment(\.statusCardVariant, variant)
    }

    /// Sets the ``DSStatusCardEmphasis`` for every ``DSStatusCard`` in this
    /// view hierarchy.
    func statusCardEmphasis(_ emphasis: DSStatusCardEmphasis) -> some View {
        environment(\.statusCardEmphasis, emphasis)
    }
}
