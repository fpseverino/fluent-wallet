import struct Foundation.Date

/// The unique identifiers associated with orders.
///
/// See: [`OrderIdentifiers`](https://developer.apple.com/documentation/walletorders/orderidentifiers)
public struct OrderIdentifiersDTO: Codable {
    /// An array of order identifer strings.
    public let orderIdentifiers: [String]

    /// The date and time of when an order was last changed.
    public let lastModified: String

    public init(with orderIdentifiers: [String], maxDate: Date) {
        self.orderIdentifiers = orderIdentifiers
        self.lastModified = String(maxDate.timeIntervalSince1970)
    }
}
