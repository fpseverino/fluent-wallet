import FluentWalletOrders
import Foundation
import Testing
import XCTFluent

@Suite("FluentWalletOrders Tests")
struct FluentWalletOrdersTests {
    let test = ArrayTestDatabase()

    @Test("Order Concrete Model")
    func order() async throws {
        let migration = CreateOrder()
        try await migration.prepare(on: test.db)

        let typeIdentifier = "Test Type Identifier"
        let authenticationToken = "Test Authentication Token"

        test.append([
            TestOutput(Order(typeIdentifier: typeIdentifier, authenticationToken: authenticationToken))
        ])

        let fetchedOrder = try #require(await Order.query(on: test.db).first())
        #expect(fetchedOrder._$typeIdentifier.value == typeIdentifier)
        #expect(fetchedOrder._$authenticationToken.value == authenticationToken)

        try await migration.revert(on: test.db)
    }

    @Test("OrdersDevice Concrete Model")
    func ordersDevice() async throws {
        let migration = CreateOrdersDevice()
        try await migration.prepare(on: test.db)

        let libraryIdentifier = "Test Library Identifier"
        let pushToken = "Test Push Token"

        test.append([
            TestOutput(OrdersDevice(libraryIdentifier: libraryIdentifier, pushToken: pushToken))
        ])

        let fetchedDevice = try #require(await OrdersDevice.query(on: test.db).first())
        #expect(fetchedDevice._$libraryIdentifier.value == libraryIdentifier)
        #expect(fetchedDevice._$pushToken.value == pushToken)

        try await migration.revert(on: test.db)
    }

    @Test("OrdersRegistration Concrete Model")
    func ordersRegistration() async throws {
        let migration = CreateOrdersRegistration()
        try await migration.prepare(on: test.db)

        let device = OrdersDevice()
        device._$id.value = 1

        let order = Order()
        order._$id.value = UUID()

        let ordersRegistration = OrdersRegistration()
        ordersRegistration.$device.id = device.id!
        ordersRegistration.$order.id = order.id!
        test.append([
            TestOutput(ordersRegistration)
        ])

        let fetchedOrdersRegistration = try #require(await OrdersRegistration.query(on: test.db).first())
        #expect(fetchedOrdersRegistration._$device.id == device.id)
        #expect(fetchedOrdersRegistration._$order.id == order.id)

        try await migration.revert(on: test.db)
    }

    @Test("OrdersRegistrationModel `for` QueryBuilder")
    func forQueryBuilder() async throws {
        let migration = CreateOrdersRegistration()
        try await migration.prepare(on: test.db)

        let libraryIdentifier = "Test Library Identifier"
        let pushToken = "Test Push Token"
        let device = OrdersDevice(libraryIdentifier: libraryIdentifier, pushToken: pushToken)
        device._$id.value = 1

        let typeIdentifier = "Test Type Identifier"
        let authenticationToken = "Test Authentication Token"
        let order = Order(typeIdentifier: typeIdentifier, authenticationToken: authenticationToken)
        order._$id.value = UUID()

        let ordersRegistration = OrdersRegistration()
        ordersRegistration.$device.id = device.id!
        ordersRegistration.$order.id = order.id!
        test.append([
            TestOutput(ordersRegistration)
        ])

        let fetchedOrdersRegistration = try #require(
            await OrdersRegistration
                .for(
                    deviceLibraryIdentifier: libraryIdentifier,
                    typeIdentifier: typeIdentifier,
                    on: test.db
                )
                .first()
        )
        #expect(fetchedOrdersRegistration._$device.id == device.id)
        #expect(fetchedOrdersRegistration._$order.id == order.id)

        try await migration.revert(on: test.db)
    }

    @Test("OrderIdentifiersDTO")
    func orderIdentifiersDTO() {
        let orderIdentifiers = ["Test Order Identifier"]
        let maxDate = Date.now
        let orderIdentifiersDTO = OrderIdentifiersDTO(with: orderIdentifiers, maxDate: maxDate)
        #expect(orderIdentifiersDTO.orderIdentifiers == orderIdentifiers)
        #expect(orderIdentifiersDTO.lastModified == String(maxDate.timeIntervalSince1970))
    }
}
