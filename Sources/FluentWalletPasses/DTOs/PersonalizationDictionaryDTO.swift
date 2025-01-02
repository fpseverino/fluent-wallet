/// An object that contains the information you use to personalize a pass.
///
/// See: [`PersonalizationDictionary`](https://developer.apple.com/documentation/walletpasses/personalizationdictionary)
public struct PersonalizationDictionaryDTO: Codable, Sendable {
    /// The personalization token for this request. The server must sign and return the token.
    public let personalizationToken: String

    /// An object that contains the user-entered information for a personalized pass.
    public let requiredPersonalizationInfo: RequiredPersonalizationInfo

    public init(
        personalizationToken: String,
        requiredPersonalizationInfo: RequiredPersonalizationInfo
    ) {
        self.personalizationToken = personalizationToken
        self.requiredPersonalizationInfo = requiredPersonalizationInfo
    }

    /// An object that contains the user-entered information for a personalized pass.
    ///
    /// See: [`RequiredPersonalizationInfo`](https://developer.apple.com/documentation/walletpasses/personalizationdictionary/requiredpersonalizationinfo-data.dictionary)
    public struct RequiredPersonalizationInfo: Codable, Sendable {
        /// The user-entered email address for the user of the personalized pass.
        public let emailAddress: String?

        /// The family name for the user of the personalized pass, parsed from the full name.
        ///
        /// The name can indicate membership in a group.
        public let familyName: String?

        /// The user-entered full name for the user of the personalized pass.
        public let fullName: String?

        /// The given name for the user of the personalized pass, parsed from the full name.
        ///
        /// The system uses the name to differentiate the individual from other members who share the same family name.
        /// In some locales, the given name is also known as a _forename_ or _first name_.
        public let givenName: String?

        /// The ISO country code.
        ///
        /// The system sets this key when it’s known; otherwise, it doesn’t include the key.
        public let isoCountryCode: String?

        /// The user-entered phone number for the user of the personalized pass.
        public let phoneNumber: String?

        /// The user-entered postal code for the user of the personalized pass.
        public let postalCode: String?

        public init(
            emailAddress: String? = nil,
            familyName: String? = nil,
            fullName: String? = nil,
            givenName: String? = nil,
            isoCountryCode: String? = nil,
            phoneNumber: String? = nil,
            postalCode: String? = nil
        ) {
            self.emailAddress = emailAddress
            self.familyName = familyName
            self.fullName = fullName
            self.givenName = givenName
            self.isoCountryCode = isoCountryCode
            self.phoneNumber = phoneNumber
            self.postalCode = postalCode
        }

        enum CodingKeys: String, CodingKey {
            case emailAddress
            case familyName
            case fullName
            case givenName
            case isoCountryCode = "ISOCountryCode"
            case phoneNumber
            case postalCode
        }
    }
}
