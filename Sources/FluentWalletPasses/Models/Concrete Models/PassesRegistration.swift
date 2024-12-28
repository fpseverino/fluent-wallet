import FluentKit
import FluentWallet

/// The `Model` that stores passes registrations.
final public class PassesRegistration: PassesRegistrationModel, @unchecked Sendable {
    /// The schema name of the passes registration model.
    public static let schema = PassesRegistration.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    /// The device for this registration.
    @Parent(key: PassesRegistration.FieldKeys.deviceID)
    public var device: PassesDevice

    /// The pass for this registration.
    @Parent(key: PassesRegistration.FieldKeys.passID)
    public var pass: Pass

    public init() {}
}

/// The migration that creates the ``PassesRegistration`` table.
public struct CreatePassesRegistration: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(PassesRegistration.FieldKeys.schemaName)
            .field(.id, .int, .identifier(auto: true))
            .field(
                PassesRegistration.FieldKeys.deviceID, .int, .required,
                .references(PassesDevice.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .field(
                PassesRegistration.FieldKeys.passID, .uuid, .required,
                .references(Pass.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(PassesRegistration.FieldKeys.schemaName).delete()
    }

    public init() {}
}

extension PassesRegistration {
    enum FieldKeys {
        static let schemaName = "passes_registrations"
        static let deviceID = FieldKey(stringLiteral: "device_id")
        static let passID = FieldKey(stringLiteral: "pass_id")
    }
}
