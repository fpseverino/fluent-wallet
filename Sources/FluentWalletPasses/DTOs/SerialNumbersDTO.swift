import struct Foundation.Date

/// An object that contains serial numbers for the updatable passes on a device.
///
/// See: [`SerialNumbers`](https://developer.apple.com/documentation/walletpasses/serialnumbers)
public struct SerialNumbersDTO: Codable, Sendable {
    /// A developer-defined string that contains a tag that indicates the modification time for the returned passes.
    public let lastUpdated: String

    /// An array of serial numbers for the updated passes.
    public let serialNumbers: [String]

    public init(with serialNumbers: [String], maxDate: Date) {
        lastUpdated = String(maxDate.timeIntervalSince1970)
        self.serialNumbers = serialNumbers
    }
}
