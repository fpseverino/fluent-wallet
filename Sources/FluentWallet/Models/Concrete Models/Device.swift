import FluentKit

/// The `Model` that stores Apple Wallet devices.
final public class Device: DeviceModel, @unchecked Sendable {
    /// The schema name of the device model.
    public static let schema = Device.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    /// The push token used for sending updates to the device.
    @Field(key: Device.FieldKeys.pushToken)
    public var pushToken: String

    /// The identifier Apple Wallet provides for the device.
    @Field(key: Device.FieldKeys.libraryIdentifier)
    public var libraryIdentifier: String

    public init(libraryIdentifier: String, pushToken: String) {
        self.libraryIdentifier = libraryIdentifier
        self.pushToken = pushToken
    }

    public init() {}
}

extension Device: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(Self.schema)
            .field(.id, .int, .identifier(auto: true))
            .field(Device.FieldKeys.pushToken, .string, .required)
            .field(Device.FieldKeys.libraryIdentifier, .string, .required)
            .unique(on: Device.FieldKeys.pushToken, Device.FieldKeys.libraryIdentifier)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(Self.schema).delete()
    }
}

extension Device {
    enum FieldKeys {
        static let schemaName = "devices"
        static let pushToken = FieldKey(stringLiteral: "push_token")
        static let libraryIdentifier = FieldKey(stringLiteral: "library_identifier")
    }
}
