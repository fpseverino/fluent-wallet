import FluentKit
import FluentWallet

/// Represents the `Model` that stores passes registrations.
public protocol PassesRegistrationModel: Model where IDValue == Int {
    associatedtype PassType: PassModel
    associatedtype DeviceType: DeviceModel

    /// The device for this registration.
    var device: DeviceType { get set }

    /// The pass for this registration.
    var pass: PassType { get set }
}

extension PassesRegistrationModel {
    public var _$device: Parent<DeviceType> {
        guard let mirror = Mirror(reflecting: self).descendant("_device"),
            let device = mirror as? Parent<DeviceType>
        else {
            fatalError("device property must be declared using @Parent")
        }

        return device
    }

    public var _$pass: Parent<PassType> {
        guard let mirror = Mirror(reflecting: self).descendant("_pass"),
            let pass = mirror as? Parent<PassType>
        else {
            fatalError("pass property must be declared using @Parent")
        }

        return pass
    }

    static public func `for`(deviceLibraryIdentifier: String, typeIdentifier: String, on db: any Database) -> QueryBuilder<Self> {
        Self.query(on: db)
            .join(parent: \._$pass)
            .join(parent: \._$device)
            .filter(PassType.self, \._$typeIdentifier == typeIdentifier)
            .filter(DeviceType.self, \._$libraryIdentifier == deviceLibraryIdentifier)
    }
}
