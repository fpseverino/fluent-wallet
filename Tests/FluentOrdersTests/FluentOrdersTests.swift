import FluentOrders
import FluentWallet
import Testing

import struct Foundation.UUID

@Suite("FluentOrders Tests")
struct FluentOrdersTests {
    @Test("Order Concrete Model")
    func order() async throws {
        let typeIdentifier = "Test Type Identifier"
        let authenticationToken = "Test Authentication Token"

        let order = Order(typeIdentifier: typeIdentifier, authenticationToken: authenticationToken)

        #expect(order._$typeIdentifier.value == typeIdentifier)
        #expect(order._$authenticationToken.value == authenticationToken)
    }

    @Test("OrdersRegistration Concrete Model")
    func ordersRegistration() async throws {
        let device = Device()
        device._$id.value = 1
        let order = Order()
        order._$id.value = UUID()

        let ordersRegistration = OrdersRegistration()
        ordersRegistration.$device.id = device.id!
        ordersRegistration.$order.id = order.id!

        #expect(ordersRegistration._$device.id == device.id)
        #expect(ordersRegistration._$order.id == order.id)
    }
}
