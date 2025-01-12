import FluentKit
import FluentWalletOrders
import Foundation
import WalletOrders

// snippet.ORDER_DATA
final class OrderData: OrderDataModel, @unchecked Sendable {
    static let schema = "Order_data"

    static let typeIdentifier = "order.com.example.FluentWallet"

    @ID
    var id: UUID?

    @Parent(key: "order_id")
    var order: Order

    // Example of other extra fields:
    @Field(key: "merchant_name")
    var merchantName: String

    // Add any other field relative to your app, such as an identifier, the order status, etc.

    init() {}
}

// snippet.CREATE_ORDER_DATA
struct CreateOrderData: AsyncMigration {
    public func prepare(on database: Database) async throws {
        try await database.schema(OrderData.schema)
            .id()
            .field("order_id", .uuid, .required, .references(Order.schema, .id, onDelete: .cascade))
            .field("merchant_name", .string, .required)
            .create()
    }

    public func revert(on database: Database) async throws {
        try await database.schema(OrderData.schema).delete()
    }
}

// snippet.ORDER_JSON
extension OrderData {
    func orderJSON(on db: any Database) async throws -> any OrderJSON.Properties {
        try await OrderJSONData(data: self, order: self.$order.get(on: db))
    }

    func sourceFilesDirectoryPath(on db: any Database) async throws -> String {
        // The location might vary depending on the type of order.
        "SourceFiles/Orders/"
    }
}

// snippet.ORDER_JSON_DATA
struct OrderJSONData: OrderJSON.Properties {
    var schemaVersion = OrderJSON.SchemaVersion.v1
    var orderType = OrderJSON.OrderType.ecommerce
    var orderNumber = "HM090772020864"
    var webServiceURL = "https://example.com/api/orders/"
    var status = OrderJSON.OrderStatus.open
    var orderManagementURL = "https://www.example.com/"

    var createdAt: String
    var updatedAt: String
    var merchant: MerchantData
    var authenticationToken: String
    var orderIdentifier: String

    var orderTypeIdentifier = OrderData.typeIdentifier

    struct MerchantData: OrderJSON.Merchant {
        var merchantIdentifier = "com.example.pet-store"
        var displayName: String
        var url = "https://www.example.com/"
        var logo = "pet_store_logo.png"
    }

    init(data: OrderData, order: Order) {
        self.orderIdentifier = order.id!.uuidString
        self.authenticationToken = order.authenticationToken
        self.merchant = MerchantData(displayName: "Pet Store")

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = .withInternetDateTime
        self.createdAt = dateFormatter.string(from: order.createdAt!)
        self.updatedAt = dateFormatter.string(from: order.updatedAt!)
    }
}
