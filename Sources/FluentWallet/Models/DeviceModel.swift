import FluentKit

/// Represents the `Model` that stores Apple Wallet devices.
public protocol DeviceModel: Model where IDValue == Int {
    /// The push token used for sending updates to the device.
    var pushToken: String { get set }

    /// The identifier Apple Wallet provides for the device.
    var libraryIdentifier: String { get set }

    /// The designated initializer.
    /// - Parameters:
    ///   - libraryIdentifier: The device identifier as provided during registration.
    ///   - pushToken: The push token to use when sending updates via push notifications.
    init(libraryIdentifier: String, pushToken: String)
}

extension DeviceModel {
    public var _$pushToken: Field<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_pushToken"),
            let pushToken = mirror as? Field<String>
        else {
            fatalError("pushToken property must be declared using @Field")
        }

        return pushToken
    }

    public var _$libraryIdentifier: Field<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_libraryIdentifier"),
            let libraryIdentifier = mirror as? Field<String>
        else {
            fatalError("libraryIdentifier property must be declared using @Field")
        }

        return libraryIdentifier
    }
}
