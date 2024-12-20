import FluentPasses
import FluentWallet
import Testing

import struct Foundation.UUID

@Suite("FluentPasses Tests")
struct FluentPassesTests {
    @Test("Pass Concrete Model")
    func pass() async throws {
        let typeIdentifier = "Test Type Identifier"
        let authenticationToken = "Test Authentication Token"
        let personalization = Personalization()
        personalization._$id.value = 1

        let pass = Pass(typeIdentifier: typeIdentifier, authenticationToken: authenticationToken)
        pass.$personalization.id = personalization.id!

        #expect(pass._$typeIdentifier.value == typeIdentifier)
        #expect(pass._$authenticationToken.value == authenticationToken)
        #expect(pass._$personalization.id == personalization.id)
    }

    @Test("PassesRegistration Concrete Model")
    func passesRegistration() async throws {
        let device = Device()
        device._$id.value = 1
        let pass = Pass()
        pass._$id.value = UUID()

        let passesRegistration = PassesRegistration()
        passesRegistration.$device.id = device.id!
        passesRegistration.$pass.id = pass.id!

        #expect(passesRegistration._$device.id == device.id)
        #expect(passesRegistration._$pass.id == pass.id)
    }

    @Test("Personalization Concrete Model")
    func personalization() async throws {
        let fullName = "Test Name"
        let givenName = String(fullName.prefix(4))
        let familyName = String(fullName.suffix(4))
        let emailAddress = "Test Email"
        let postalCode = "Test Postal Code"
        let isoCountryCode = "Test ISO Country Code"
        let phoneNumber = "Test Phone Number"

        let personalization = Personalization()
        personalization.fullName = fullName
        personalization.givenName = givenName
        personalization.familyName = familyName
        personalization.emailAddress = emailAddress
        personalization.postalCode = postalCode
        personalization.isoCountryCode = isoCountryCode
        personalization.phoneNumber = phoneNumber

        #expect(personalization._$fullName.value == fullName)
        #expect(personalization._$givenName.value == givenName)
        #expect(personalization._$familyName.value == familyName)
        #expect(personalization._$emailAddress.value == emailAddress)
        #expect(personalization._$postalCode.value == postalCode)
        #expect(personalization._$isoCountryCode.value == isoCountryCode)
        #expect(personalization._$phoneNumber.value == phoneNumber)
    }

    @Test("PersonalizationJSON initialization")
    func initPersonalizationJSON() async throws {
        let requiredPersonalizationFields: [PersonalizationJSON.PersonalizationField] = [
            .name, .postalCode, .emailAddress, .phoneNumber,
        ]
        let description = "Test Description"
        let termsAndConditions = "Test Terms and Conditions"

        let personalizationJSON = PersonalizationJSON(
            requiredPersonalizationFields: requiredPersonalizationFields,
            description: description,
            termsAndConditions: termsAndConditions
        )

        #expect(personalizationJSON.requiredPersonalizationFields == requiredPersonalizationFields)
        #expect(personalizationJSON.description == description)
        #expect(personalizationJSON.termsAndConditions == termsAndConditions)
    }
}
