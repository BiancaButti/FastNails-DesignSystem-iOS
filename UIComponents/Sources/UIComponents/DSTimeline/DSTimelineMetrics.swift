import CoreGraphics

// MARK: - DSTimeline metrics

/// Component-specific magic numbers for ``DSTimeline``.
///
/// These are not part of the shared design-system scale (`DSSpacing`,
/// `DSRadius`): they are the timeline's own decorative dimensions, stroke
/// widths and animation parameters. Naming them here keeps the view free of
/// loose literals and documents what each value drives.
enum DSTimelineMetrics {

    // MARK: Node dimensions

    /// The fixed square every node is centered in, so a state change never
    /// shifts the dot or the track line.
    static let nodeSlot: CGFloat = 20

    /// Diameter of the `.pending` dot.
    static let pendingDot: CGFloat = 8

    /// Diameter of the `.current` pulsing halo.
    static let currentHalo: CGFloat = 20

    /// Diameter of the `.current` solid anchor dot.
    static let currentDot: CGFloat = 8

    /// Diameter of the `.completed` dot.
    static let completedDot: CGFloat = 12

    // MARK: Strokes

    /// Width of the vertical track line connecting the nodes.
    static let trackWidth: CGFloat = 2

    /// Width of the card's outer border.
    static let borderWidth: CGFloat = 1

    // MARK: Pulse

    /// Opacity of the `.current` halo fill (before the pulse animates it).
    static let haloFillOpacity: Double = 0.2

    /// Scale the halo grows to at the peak of the pulse.
    static let pulseScaleMax: CGFloat = 1.3

    /// Scale the halo shrinks to at the trough of the pulse.
    static let pulseScaleMin: CGFloat = 0.95

    /// Halo opacity at the trough of the pulse (fades as it expands).
    static let pulseOpacityMin: Double = 0.4

    /// Halo opacity at rest.
    static let pulseOpacityMax: Double = 1.0

    // MARK: Animation timings (seconds)

    /// Spring response for the node's state-change animation.
    static let nodeSpringResponse: Double = 0.4

    /// Spring damping fraction for the node's state-change animation.
    static let nodeSpringDamping: Double = 0.7

    /// Fade/slide duration for the content column on state change.
    static let contentFade: Double = 0.3

    /// Fill duration for the track line turning green.
    static let trackFill: Double = 0.55

    /// One leg of the continuous halo pulse (auto-reversed, repeats forever).
    static let pulseDuration: Double = 1.2
}
