import FluentKit

/// The `Model` that stores Apple Wallet orders devices.
final public class OrdersDevice: DeviceModel, @unchecked Sendable {
    /// The schema name of the device model.
    public static let schema = OrdersDevice.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    /// The push token used for sending updates to the device.
    @Field(key: OrdersDevice.FieldKeys.pushToken)
    public var pushToken: String

    /// The identifier Apple Wallet provides for the device.
    @Field(key: OrdersDevice.FieldKeys.libraryIdentifier)
    public var libraryIdentifier: String

    public init(libraryIdentifier: String, pushToken: String) {
        self.libraryIdentifier = libraryIdentifier
        self.pushToken = pushToken
    }

    public init() {}
}

/// The migration that creates the ``OrdersDevice`` table.
public struct CreateOrdersDevice: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(OrdersDevice.FieldKeys.schemaName)
            .field(.id, .int, .identifier(auto: true))
            .field(OrdersDevice.FieldKeys.pushToken, .string, .required)
            .field(OrdersDevice.FieldKeys.libraryIdentifier, .string, .required)
            .unique(on: OrdersDevice.FieldKeys.pushToken, OrdersDevice.FieldKeys.libraryIdentifier)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(OrdersDevice.FieldKeys.schemaName).delete()
    }

    public init() {}
}

extension OrdersDevice {
    package enum FieldKeys {
        package static let schemaName = "orders_devices"
        static let pushToken = FieldKey(stringLiteral: "push_token")
        static let libraryIdentifier = FieldKey(stringLiteral: "library_identifier")
    }
}
