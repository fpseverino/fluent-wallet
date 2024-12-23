import FluentKit

/// The `Model` that stores user personalization info.
final public class Personalization: PersonalizationModel, @unchecked Sendable {
    /// The schema name of the user personalization model.
    public static let schema = Personalization.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    /// The pass this personalization info is associated with.
    @Parent(key: Personalization.FieldKeys.passID)
    public var pass: Pass

    /// The user’s full name, as entered by the user.
    @OptionalField(key: Personalization.FieldKeys.fullName)
    public var fullName: String?

    /// The user’s given name, parsed from the full name.
    ///
    /// This is the name bestowed upon an individual to differentiate them from other members of a group that share a family name (for example, “John”).
    /// In some locales, this is also known as a first name or forename.
    @OptionalField(key: Personalization.FieldKeys.givenName)
    public var givenName: String?

    /// The user’s family name, parsed from the full name.
    ///
    /// This is the name bestowed upon an individual to denote membership in a group or family (for example, “Appleseed”).
    @OptionalField(key: Personalization.FieldKeys.familyName)
    public var familyName: String?

    /// The email address, as entered by the user.
    @OptionalField(key: Personalization.FieldKeys.emailAddress)
    public var emailAddress: String?

    /// The postal code, as entered by the user.
    @OptionalField(key: Personalization.FieldKeys.postalCode)
    public var postalCode: String?

    /// The user’s ISO country code.
    ///
    /// This key is only included when the system can deduce the country code.
    @OptionalField(key: Personalization.FieldKeys.isoCountryCode)
    public var isoCountryCode: String?

    /// The phone number, as entered by the user.
    @OptionalField(key: Personalization.FieldKeys.phoneNumber)
    public var phoneNumber: String?

    public init() {}
}

public struct CreatePersonalization: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(Personalization.FieldKeys.schemaName)
            .field(.id, .int, .identifier(auto: true))
            .field(
                Personalization.FieldKeys.passID, .uuid, .required,
                .references(Pass.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .unique(on: Personalization.FieldKeys.passID)
            .field(Personalization.FieldKeys.fullName, .string)
            .field(Personalization.FieldKeys.givenName, .string)
            .field(Personalization.FieldKeys.familyName, .string)
            .field(Personalization.FieldKeys.emailAddress, .string)
            .field(Personalization.FieldKeys.postalCode, .string)
            .field(Personalization.FieldKeys.isoCountryCode, .string)
            .field(Personalization.FieldKeys.phoneNumber, .string)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(Personalization.FieldKeys.schemaName).delete()
    }

    public init() {}
}

extension Personalization {
    enum FieldKeys {
        static let schemaName = "personalization_info"
        static let passID = FieldKey(stringLiteral: "pass_id")
        static let fullName = FieldKey(stringLiteral: "full_name")
        static let givenName = FieldKey(stringLiteral: "given_name")
        static let familyName = FieldKey(stringLiteral: "family_name")
        static let emailAddress = FieldKey(stringLiteral: "email_address")
        static let postalCode = FieldKey(stringLiteral: "postal_code")
        static let isoCountryCode = FieldKey(stringLiteral: "iso_country_code")
        static let phoneNumber = FieldKey(stringLiteral: "phone_number")
    }
}
