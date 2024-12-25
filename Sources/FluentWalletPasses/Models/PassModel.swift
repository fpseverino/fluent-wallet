import FluentKit
import FluentWallet
import Foundation

/// Represents the `Model` that stores Apple Wallet passes.
///
/// Uses a UUID so people can't easily guess pass serial numbers.
public protocol PassModel: Model where IDValue == UUID {
    /// The pass type identifier that’s registered with Apple.
    var typeIdentifier: String { get set }

    /// The last time the pass was modified.
    var updatedAt: Date? { get set }

    /// The authentication token to use with the web service in the `webServiceURL` key.
    var authenticationToken: String { get set }

    /// The designated initializer.
    /// - Parameters:
    ///   - typeIdentifier: The pass type identifier that’s registered with Apple.
    ///   - authenticationToken: The authentication token to use with the web service in the `webServiceURL` key.
    init(typeIdentifier: String, authenticationToken: String)
}

extension PassModel {
    public var _$id: ID<UUID> {
        guard let mirror = Mirror(reflecting: self).descendant("_id"),
            let id = mirror as? ID<UUID>
        else {
            fatalError("id property must be declared using @ID")
        }

        return id
    }

    public var _$typeIdentifier: Field<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_typeIdentifier"),
            let typeIdentifier = mirror as? Field<String>
        else {
            fatalError("typeIdentifier property must be declared using @Field")
        }

        return typeIdentifier
    }

    public var _$updatedAt: Timestamp<DefaultTimestampFormat> {
        guard let mirror = Mirror(reflecting: self).descendant("_updatedAt"),
            let updatedAt = mirror as? Timestamp<DefaultTimestampFormat>
        else {
            fatalError("updatedAt property must be declared using @Timestamp(on: .update)")
        }

        return updatedAt
    }

    public var _$authenticationToken: Field<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_authenticationToken"),
            let authenticationToken = mirror as? Field<String>
        else {
            fatalError("authenticationToken property must be declared using @Field")
        }

        return authenticationToken
    }
}
