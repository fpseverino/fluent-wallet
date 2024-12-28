import FluentKit
import FluentWallet

/// The `Model` that stores orders registrations.
final public class OrdersRegistration: OrdersRegistrationModel, @unchecked Sendable {
    /// The schema name of the orders registration model.
    public static let schema = OrdersRegistration.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    /// The device for this registration.
    @Parent(key: OrdersRegistration.FieldKeys.deviceID)
    public var device: OrdersDevice

    /// The order for this registration.
    @Parent(key: OrdersRegistration.FieldKeys.orderID)
    public var order: Order

    public init() {}
}

/// The migration that creates the ``OrdersRegistration`` table.
public struct CreateOrdersRegistration: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(OrdersRegistration.FieldKeys.schemaName)
            .field(.id, .int, .identifier(auto: true))
            .field(
                OrdersRegistration.FieldKeys.deviceID, .int, .required,
                .references(OrdersDevice.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .field(
                OrdersRegistration.FieldKeys.orderID, .uuid, .required,
                .references(Order.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(OrdersRegistration.FieldKeys.schemaName).delete()
    }

    public init() {}
}

extension OrdersRegistration {
    enum FieldKeys {
        static let schemaName = "orders_registrations"
        static let deviceID = FieldKey(stringLiteral: "device_id")
        static let orderID = FieldKey(stringLiteral: "order_id")
    }
}
