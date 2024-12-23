import FluentWallet
import Testing
import XCTFluent

@Suite("FluentWallet Tests")
struct FluentWalletTests {
    let test = ArrayTestDatabase()

    @Test("Device Concrete Model")
    func devices() async throws {
        let migration = CreateDevice()
        try await migration.prepare(on: test.db)

        let libraryIdentifier = "Test Library Identifier"
        let pushToken = "Test Push Token"

        test.append([
            TestOutput(Device(libraryIdentifier: libraryIdentifier, pushToken: pushToken))
        ])

        let fetchedDevice = try #require(await Device.query(on: test.db).first())
        #expect(fetchedDevice._$libraryIdentifier.value == libraryIdentifier)
        #expect(fetchedDevice._$pushToken.value == pushToken)

        try await migration.revert(on: test.db)
    }

    @Test("LogEntry Concrete Model")
    func logEntries() async throws {
        let migration = CreateLogEntry()
        try await migration.prepare(on: test.db)

        let message = "Test message"

        test.append([
            TestOutput(LogEntry(message: message))
        ])

        let fetchedLogEntry = try #require(await LogEntry.query(on: test.db).first())
        #expect(fetchedLogEntry._$message.value == message)

        try await migration.revert(on: test.db)
    }
}
