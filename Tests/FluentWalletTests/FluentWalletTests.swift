import FluentWallet
import Testing

@Suite("FluentWallet Tests")
struct FluentWalletTests {
    @Test("Device Concrete Model")
    func devices() async throws {
        let libraryIdentifier = "Test Library Identifier"
        let pushToken = "Test Push Token"

        let device = Device(libraryIdentifier: libraryIdentifier, pushToken: pushToken)

        #expect(device._$libraryIdentifier.value == libraryIdentifier)
        #expect(device._$pushToken.value == pushToken)
    }

    @Test("LogEntry Concrete Model")
    func logEntries() async throws {
        let message = "Test message"

        let logEntry = LogEntry(message: message)

        #expect(logEntry._$message.value == message)
    }
}
