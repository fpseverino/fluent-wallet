/// An object that contains an array of messages.
///
/// See: [`LogEntries`](https://developer.apple.com/documentation/walletpasses/logentries)
public struct LogEntriesDTO: Codable, Sendable {
    /// An array of log messages.
    public let logs: [String]

    public init(logs: [String]) {
        self.logs = logs
    }
}
