import Foundation

// MARK: - Input handling

/// Pure input rules for `DSOTPField`, kept out of the view so they can be tested.
enum DSOTPFieldInput {

    /// Keeps only digits and clamps the result to `length` characters.
    static func sanitize(_ raw: String, length: Int) -> String {
        String(raw.filter(\.isNumber).prefix(length))
    }
}

// MARK: - Completion tracking

/// Decides when a code is complete, firing exactly once per completed code.
///
/// Typing past the limit produces a change whose sanitized value is unchanged,
/// so the tracker guards against reporting the same code twice. Dropping below
/// `length` (deleting) rearms it for the next complete code.
struct DSOTPFieldCompletionTracker {

    private var lastCompleted: String?

    /// Returns `true` only on the transition into a freshly completed code.
    mutating func shouldComplete(_ code: String, length: Int) -> Bool {
        guard code.count == length else {
            lastCompleted = nil
            return false
        }
        guard lastCompleted != code else { return false }
        lastCompleted = code
        return true
    }
}
