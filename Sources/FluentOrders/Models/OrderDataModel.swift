import FluentKit

/// Represents the `Model` that stores custom app data associated to Wallet orders.
public protocol OrderDataModel: Model {
    associatedtype OrderType: OrderModel

    /// An identifier for the order type associated with the order.
    static var typeIdentifier: String { get }

    /// The foreign key to the order table.
    var order: OrderType { get set }
}

extension OrderDataModel {
    public var _$order: Parent<OrderType> {
        guard let mirror = Mirror(reflecting: self).descendant("_order"),
            let order = mirror as? Parent<OrderType>
        else {
            fatalError("order property must be declared using @Parent")
        }

        return order
    }
}
