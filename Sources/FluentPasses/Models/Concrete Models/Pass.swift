import FluentKit
import Foundation

/// The `Model` that stores Apple Wallet passes.
///
/// Uses a UUID so people can't easily guess pass serial numbers.
final public class Pass: PassModel, @unchecked Sendable {
    public typealias PersonalizationType = Personalization

    /// The schema name of the pass model.
    public static let schema = Pass.FieldKeys.schemaName

    /// The pass alphanumeric serial number.
    ///
    /// The combination of the serial number and pass type identifier must be unique for each pass.
    /// Uses a UUID so people can't easily guess the pass serial number.
    @ID
    public var id: UUID?

    /// The last time the pass was modified.
    @Timestamp(key: Pass.FieldKeys.updatedAt, on: .update)
    public var updatedAt: Date?

    /// The pass type identifier that’s registered with Apple.
    @Field(key: Pass.FieldKeys.typeIdentifier)
    public var typeIdentifier: String

    /// The authentication token to use with the web service in the `webServiceURL` key.
    @Field(key: Pass.FieldKeys.authenticationToken)
    public var authenticationToken: String

    /// The user personalization info.
    @OptionalParent(key: Pass.FieldKeys.personalizationID)
    public var personalization: PersonalizationType?

    public required init() {}

    public required init(typeIdentifier: String, authenticationToken: String) {
        self.typeIdentifier = typeIdentifier
        self.authenticationToken = authenticationToken
    }
}

extension Pass: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(Self.schema)
            .id()
            .field(Pass.FieldKeys.updatedAt, .datetime, .required)
            .field(Pass.FieldKeys.typeIdentifier, .string, .required)
            .field(Pass.FieldKeys.authenticationToken, .string, .required)
            .field(
                Pass.FieldKeys.personalizationID, .int,
                .references(PersonalizationType.schema, .id)
            )
            .unique(on: Pass.FieldKeys.personalizationID)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(Self.schema).delete()
    }
}

extension Pass {
    enum FieldKeys {
        static let schemaName = "passes"
        static let updatedAt = FieldKey(stringLiteral: "updated_at")
        static let typeIdentifier = FieldKey(stringLiteral: "type_identifier")
        static let authenticationToken = FieldKey(stringLiteral: "authentication_token")
        static let personalizationID = FieldKey(stringLiteral: "personalization_id")
    }
}
