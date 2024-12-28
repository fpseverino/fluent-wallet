import FluentKit

/// The `Model` that stores Apple Wallet passes devices.
final public class PassesDevice: DeviceModel, @unchecked Sendable {
    /// The schema name of the device model.
    public static let schema = PassesDevice.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    /// The push token used for sending updates to the device.
    @Field(key: PassesDevice.FieldKeys.pushToken)
    public var pushToken: String

    /// The identifier Apple Wallet provides for the device.
    @Field(key: PassesDevice.FieldKeys.libraryIdentifier)
    public var libraryIdentifier: String

    public init(libraryIdentifier: String, pushToken: String) {
        self.libraryIdentifier = libraryIdentifier
        self.pushToken = pushToken
    }

    public init() {}
}

/// The migration that creates the ``PassesDevice`` table.
public struct CreatePassesDevice: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(PassesDevice.FieldKeys.schemaName)
            .field(.id, .int, .identifier(auto: true))
            .field(PassesDevice.FieldKeys.pushToken, .string, .required)
            .field(PassesDevice.FieldKeys.libraryIdentifier, .string, .required)
            .unique(on: PassesDevice.FieldKeys.pushToken, PassesDevice.FieldKeys.libraryIdentifier)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(PassesDevice.FieldKeys.schemaName).delete()
    }

    public init() {}
}

extension PassesDevice {
    package enum FieldKeys {
        package static let schemaName = "devices"
        static let pushToken = FieldKey(stringLiteral: "push_token")
        static let libraryIdentifier = FieldKey(stringLiteral: "library_identifier")
    }
}
