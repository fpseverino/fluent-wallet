import FluentKit

/// The `Model` that stores user personalization info.
final public class PersonalizationInfo: PersonalizationInfoModel, @unchecked Sendable {
    /// The schema name of the user personalization model.
    public static let schema = PersonalizationInfo.FieldKeys.schemaName

    @ID(custom: .id)
    public var id: Int?

    /// The pass this personalization info is associated with.
    @Parent(key: PersonalizationInfo.FieldKeys.passID)
    public var pass: Pass

    /// The user’s full name, as entered by the user.
    @OptionalField(key: PersonalizationInfo.FieldKeys.fullName)
    public var fullName: String?

    /// The user’s given name, parsed from the full name.
    ///
    /// This is the name bestowed upon an individual to differentiate them from other members of a group that share a family name (for example, “John”).
    /// In some locales, this is also known as a first name or forename.
    @OptionalField(key: PersonalizationInfo.FieldKeys.givenName)
    public var givenName: String?

    /// The user’s family name, parsed from the full name.
    ///
    /// This is the name bestowed upon an individual to denote membership in a group or family (for example, “Appleseed”).
    @OptionalField(key: PersonalizationInfo.FieldKeys.familyName)
    public var familyName: String?

    /// The email address, as entered by the user.
    @OptionalField(key: PersonalizationInfo.FieldKeys.emailAddress)
    public var emailAddress: String?

    /// The postal code, as entered by the user.
    @OptionalField(key: PersonalizationInfo.FieldKeys.postalCode)
    public var postalCode: String?

    /// The user’s ISO country code.
    ///
    /// This key is only included when the system can deduce the country code.
    @OptionalField(key: PersonalizationInfo.FieldKeys.isoCountryCode)
    public var isoCountryCode: String?

    /// The phone number, as entered by the user.
    @OptionalField(key: PersonalizationInfo.FieldKeys.phoneNumber)
    public var phoneNumber: String?

    public init() {}
}

/// The migration that creates the ``PersonalizationInfo`` table.
public struct CreatePersonalizationInfo: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(PersonalizationInfo.FieldKeys.schemaName)
            .field(.id, .int, .identifier(auto: true))
            .field(
                PersonalizationInfo.FieldKeys.passID, .uuid, .required,
                .references(Pass.FieldKeys.schemaName, .id, onDelete: .cascade)
            )
            .unique(on: PersonalizationInfo.FieldKeys.passID)
            .field(PersonalizationInfo.FieldKeys.fullName, .string)
            .field(PersonalizationInfo.FieldKeys.givenName, .string)
            .field(PersonalizationInfo.FieldKeys.familyName, .string)
            .field(PersonalizationInfo.FieldKeys.emailAddress, .string)
            .field(PersonalizationInfo.FieldKeys.postalCode, .string)
            .field(PersonalizationInfo.FieldKeys.isoCountryCode, .string)
            .field(PersonalizationInfo.FieldKeys.phoneNumber, .string)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(PersonalizationInfo.FieldKeys.schemaName).delete()
    }

    public init() {}
}

extension PersonalizationInfo {
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
