import FluentKit
import WalletPasses

/// Represents the `Model` that stores custom app data associated to Apple Wallet passes.
public protocol PassDataModel: Model {
    associatedtype PassType: PassModel

    /// The pass type identifier that’s registered with Apple.
    static var typeIdentifier: String { get }

    /// The foreign key to the pass table.
    var pass: PassType { get set }

    /// Encode the pass into JSON.
    ///
    /// This method should generate the entire pass JSON.
    ///
    /// - Parameter db: The SQL database to query against.
    ///
    /// - Returns: An object that conforms to `PassJSON.Properties`.
    ///
    /// > Tip: See the [`Pass`](https://developer.apple.com/documentation/walletpasses/pass) object to understand the keys.
    func passJSON(on db: any Database) async throws -> any PassJSON.Properties

    /// Should return a URL path which points to the template data for the pass.
    ///
    /// The path should point to a directory containing all the images and localizations for the generated `.pkpass` archive
    /// but should *not* contain any of these items:
    ///  - `manifest.json`
    ///  - `pass.json`
    ///  - `personalization.json`
    ///  - `signature`
    ///
    /// - Parameter db: The SQL database to query against.
    ///
    /// - Returns: A URL path which points to the template data for the pass.
    func sourceFilesDirectoryPath(on db: any Database) async throws -> String

    /// Create the personalization JSON struct.
    ///
    /// This method should generate the entire personalization JSON struct.
    /// If the pass in question requires personalization, you should return a `PersonalizationJSON`.
    /// If the pass does not require personalization, you should return `nil`.
    ///
    /// The default implementation of this method returns `nil`.
    ///
    /// - Parameter db: The SQL database to query against.
    ///
    /// - Returns: A `PersonalizationJSON` or `nil` if the pass does not require personalization.
    func personalizationJSON(on db: any Database) async throws -> PersonalizationJSON?
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

extension PassDataModel {
    public func personalizationJSON(on db: any Database) async throws -> PersonalizationJSON? {
        nil
    }
}
