import FluentOrders
import FluentWallet
import Testing
import XCTFluent

import struct Foundation.UUID

@Suite("FluentOrders Tests")
struct FluentOrdersTests {
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

    @Test("OrdersRegistration Concrete Model")
    func ordersRegistration() async throws {
        let migration = CreateOrdersRegistration()
        try await migration.prepare(on: test.db)

        let device = Device()
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
        let device = Device(libraryIdentifier: libraryIdentifier, pushToken: pushToken)
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
}
