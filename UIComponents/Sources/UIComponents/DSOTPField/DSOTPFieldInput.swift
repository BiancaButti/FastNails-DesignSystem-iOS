import Foundation

// MARK: - Input handling

/// Pure input rules for `DSOTPField`, kept out of the view so they can be tested.
enum DSOTPFieldInput {

    /// Sanitizes raw OTP input by keeping only numeric characters and limiting
    /// the result to the requested number of digits.
    ///
    /// - Parameters:
    ///   - raw: The raw text received from the input control.
    ///   - length: The maximum number of digits allowed.
    /// - Returns: A digits-only string containing at most `length` characters.
    static func sanitize(_ raw: String, length: Int) -> String {
        String(raw.filter(\.isNumber).prefix(length))
    }
}

// MARK: - Completion tracking

/// Tracks OTP completion independently from the view's rendering state.
///
/// The tracker ensures that a completion callback is emitted only once for
/// each completed code. Deleting digits below the required length resets the
/// tracker so a newly entered code can trigger completion again.
struct DSOTPFieldCompletionTracker {

    /// The most recently reported complete code.
    ///
    /// Used to prevent the same completed value from triggering the completion
    /// callback more than once.
    private var lastCompleted: String?

    /// Determines whether the supplied code represents a newly completed OTP.
    ///
    /// When the code is shorter than `length`, the tracker is rearmed. When the
    /// code reaches the required length, completion is reported only if that
    /// exact code has not already been reported.
    ///
    /// - Parameters:
    ///   - code: The sanitized OTP value currently entered.
    ///   - length: The required number of digits.
    /// - Returns: `true` only when `code` has just reached the required length
    ///   and has not already been reported.
    mutating func shouldComplete(_ code: String, length: Int) -> Bool {
        guard code.count == length else {
            lastCompleted = nil
            return false
        }

        guard lastCompleted != code else {
            return false
        }

        lastCompleted = code
        return true
    }
}
