import FluentKit

/// Represents the `Model` that stores Apple Wallet log messages.
public protocol LogEntryModel: Model {
    /// The log message provided by Apple Wallet.
    var message: String { get set }

    /// The designated initializer.
    /// - Parameter message: The log message.
    init(message: String)
}

extension LogEntryModel {
    public var _$message: Field<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_message"),
            let message = mirror as? Field<String>
        else {
            fatalError("id property must be declared using @ID")
        }

        return message
    }
}
