import FluentPasses
import FluentWallet
import Testing
import XCTFluent

import struct Foundation.UUID

@Suite("FluentPasses Tests")
struct FluentPassesTests {
    let test = ArrayTestDatabase()

    @Test("Pass Concrete Model")
    func pass() async throws {
        let migration = CreatePass()
        try await migration.prepare(on: test.db)

        let typeIdentifier = "Test Type Identifier"
        let authenticationToken = "Test Authentication Token"
        let personalization = Personalization()
        personalization._$id.value = 1

        let pass = Pass(typeIdentifier: typeIdentifier, authenticationToken: authenticationToken)
        pass.$personalization.id = personalization.id!
        test.append([
            TestOutput(pass)
        ])

        let fetchedPass = try #require(await Pass.query(on: test.db).first())
        #expect(fetchedPass._$typeIdentifier.value == typeIdentifier)
        #expect(fetchedPass._$authenticationToken.value == authenticationToken)
        #expect(fetchedPass._$personalization.id == personalization.id)

        try await migration.revert(on: test.db)
    }

    @Test("PassesRegistration Concrete Model")
    func passesRegistration() async throws {
        let migration = CreatePassesRegistration()
        try await migration.prepare(on: test.db)

        let device = Device()
        device._$id.value = 1
        let pass = Pass()
        pass._$id.value = UUID()

        let passesRegistration = PassesRegistration()
        passesRegistration.$device.id = device.id!
        passesRegistration.$pass.id = pass.id!
        test.append([
            TestOutput(passesRegistration)
        ])

        let fetchedPassesRegistration = try #require(await PassesRegistration.query(on: test.db).first())
        #expect(fetchedPassesRegistration._$device.id == device.id)
        #expect(fetchedPassesRegistration._$pass.id == pass.id)

        try await migration.revert(on: test.db)
    }

    @Test("Personalization Concrete Model")
    func personalization() async throws {
        let migration = CreatePersonalization()
        try await migration.prepare(on: test.db)

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
        test.append([
            TestOutput(personalization)
        ])

        let fetchedPersonalization = try #require(await Personalization.query(on: test.db).first())
        #expect(fetchedPersonalization._$fullName.value == fullName)
        #expect(fetchedPersonalization._$givenName.value == givenName)
        #expect(fetchedPersonalization._$familyName.value == familyName)
        #expect(fetchedPersonalization._$emailAddress.value == emailAddress)
        #expect(fetchedPersonalization._$postalCode.value == postalCode)
        #expect(fetchedPersonalization._$isoCountryCode.value == isoCountryCode)
        #expect(fetchedPersonalization._$phoneNumber.value == phoneNumber)

        try await migration.revert(on: test.db)
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
