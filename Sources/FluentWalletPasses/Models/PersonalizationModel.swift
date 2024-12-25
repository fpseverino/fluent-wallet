import FluentKit

/// Represents the `Model` that stores user personalization info.
public protocol PersonalizationModel: Model where IDValue == Int {
    associatedtype PassType: PassModel

    /// The pass this personalization info is associated with.
    var pass: PassType { get set }

    /// The user’s full name, as entered by the user.
    var fullName: String? { get set }

    /// The user’s given name, parsed from the full name.
    ///
    /// This is the name bestowed upon an individual to differentiate them from other members of a group that share a family name (for example, “John”).
    /// In some locales, this is also known as a first name or forename.
    var givenName: String? { get set }

    /// The user’s family name, parsed from the full name.
    ///
    /// This is the name bestowed upon an individual to denote membership in a group or family (for example, “Appleseed”).
    var familyName: String? { get set }

    /// The email address, as entered by the user.
    var emailAddress: String? { get set }

    /// The postal code, as entered by the user.
    var postalCode: String? { get set }

    /// The user’s ISO country code.
    ///
    /// This key is only included when the system can deduce the country code.
    var isoCountryCode: String? { get set }

    /// The phone number, as entered by the user.
    var phoneNumber: String? { get set }
}

extension PersonalizationModel {
    public var _$id: ID<Int> {
        guard let mirror = Mirror(reflecting: self).descendant("_id"),
            let id = mirror as? ID<Int>
        else {
            fatalError("id property must be declared using @ID")
        }

        return id
    }

    public var _$pass: Parent<PassType> {
        guard let mirror = Mirror(reflecting: self).descendant("_pass"),
            let pass = mirror as? Parent<PassType>
        else {
            fatalError("pass property must be declared using @Parent")
        }

        return pass
    }

    public var _$fullName: OptionalField<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_fullName"),
            let fullName = mirror as? OptionalField<String>
        else {
            fatalError("fullName property must be declared using @OptionalField")
        }

        return fullName
    }

    public var _$givenName: OptionalField<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_givenName"),
            let givenName = mirror as? OptionalField<String>
        else {
            fatalError("givenName property must be declared using @OptionalField")
        }

        return givenName
    }

    public var _$familyName: OptionalField<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_familyName"),
            let familyName = mirror as? OptionalField<String>
        else {
            fatalError("familyName property must be declared using @OptionalField")
        }

        return familyName
    }

    public var _$emailAddress: OptionalField<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_emailAddress"),
            let emailAddress = mirror as? OptionalField<String>
        else {
            fatalError("emailAddress property must be declared using @OptionalField")
        }

        return emailAddress
    }

    public var _$postalCode: OptionalField<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_postalCode"),
            let postalCode = mirror as? OptionalField<String>
        else {
            fatalError("postalCode property must be declared using @OptionalField")
        }

        return postalCode
    }

    public var _$isoCountryCode: OptionalField<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_isoCountryCode"),
            let isoCountryCode = mirror as? OptionalField<String>
        else {
            fatalError("isoCountryCode property must be declared using @OptionalField")
        }

        return isoCountryCode
    }

    public var _$phoneNumber: OptionalField<String> {
        guard let mirror = Mirror(reflecting: self).descendant("_phoneNumber"),
            let phoneNumber = mirror as? OptionalField<String>
        else {
            fatalError("phoneNumber property must be declared using @OptionalField")
        }

        return phoneNumber
    }
}
