import FluentKit

/// The `Model` that stores Apple Wallet error logs.
final public class LogEntry: LogEntryModel, @unchecked Sendable {
    /// The schema name of the error log model.
    public static let schema = LogEntry.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    /// The error message provided by Apple Wallet.
    @Field(key: LogEntry.FieldKeys.message)
    public var message: String

    public init(message: String) {
        self.message = message
    }

    public init() {}
}

public struct CreateLogEntry: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(LogEntry.FieldKeys.schemaName)
            .field(.id, .int, .identifier(auto: true))
            .field(LogEntry.FieldKeys.message, .string, .required)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(LogEntry.FieldKeys.schemaName).delete()
    }

    public init() {}
}

extension LogEntry {
    enum FieldKeys {
        static let schemaName = "log_entries"
        static let message = FieldKey(stringLiteral: "message")
    }
}
