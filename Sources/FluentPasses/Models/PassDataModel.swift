import FluentKit

/// Represents the `Model` that stores custom app data associated to Apple Wallet passes.
public protocol PassDataModel: Model {
    associatedtype PassType: PassModel

    /// The pass type identifier that’s registered with Apple.
    static var typeIdentifier: String { get }

    /// The foreign key to the pass table.
    var pass: PassType { get set }
}

extension PassDataModel {
    public var _$pass: Parent<PassType> {
        guard let mirror = Mirror(reflecting: self).descendant("_pass"),
            let pass = mirror as? Parent<PassType>
        else {
            fatalError("pass property must be declared using @Parent")
        }

        return pass
    }
}
