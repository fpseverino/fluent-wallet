import FluentWalletPasses
import Foundation
import Testing
import XCTFluent

@Suite("FluentWalletPasses Tests")
struct FluentWalletPassesTests {
    let test = ArrayTestDatabase()

    @Test("Pass Concrete Model")
    func pass() async throws {
        let migration = CreatePass()
        try await migration.prepare(on: test.db)

        let typeIdentifier = "Test Type Identifier"
        let authenticationToken = "Test Authentication Token"

        let pass = Pass(typeIdentifier: typeIdentifier, authenticationToken: authenticationToken)
        test.append([
            TestOutput(pass)
        ])

        let fetchedPass = try #require(await Pass.query(on: test.db).first())
        #expect(fetchedPass._$typeIdentifier.value == typeIdentifier)
        #expect(fetchedPass._$authenticationToken.value == authenticationToken)
        #expect(fetchedPass._$updatedAt.value != nil)

        try await migration.revert(on: test.db)
    }

    @Test("PassesDevice Concrete Model")
    func passesDevice() async throws {
        let migration = CreatePassesDevice()
        try await migration.prepare(on: test.db)

        let libraryIdentifier = "Test Library Identifier"
        let pushToken = "Test Push Token"

        test.append([
            TestOutput(PassesDevice(libraryIdentifier: libraryIdentifier, pushToken: pushToken))
        ])

        let fetchedDevice = try #require(await PassesDevice.query(on: test.db).first())
        #expect(fetchedDevice._$libraryIdentifier.value == libraryIdentifier)
        #expect(fetchedDevice._$pushToken.value == pushToken)

        try await migration.revert(on: test.db)
    }

    @Test("PassesRegistration Concrete Model")
    func passesRegistration() async throws {
        let migration = CreatePassesRegistration()
        try await migration.prepare(on: test.db)

        let device = PassesDevice()
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

    @Test("PersonalizationInfo Concrete Model")
    func personalization() async throws {
        let migration = CreatePersonalizationInfo()
        try await migration.prepare(on: test.db)

        let typeIdentifier = "Test Type Identifier"
        let authenticationToken = "Test Authentication Token"

        let pass = Pass(typeIdentifier: typeIdentifier, authenticationToken: authenticationToken)
        pass._$id.value = UUID()

        let fullName = "Test Name"
        let givenName = String(fullName.prefix(4))
        let familyName = String(fullName.suffix(4))
        let emailAddress = "Test Email"
        let postalCode = "Test Postal Code"
        let isoCountryCode = "Test ISO Country Code"
        let phoneNumber = "Test Phone Number"

        let personalization = PersonalizationInfo()
        personalization.$pass.id = pass.id!
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

        let fetchedPersonalization = try #require(await PersonalizationInfo.query(on: test.db).first())
        #expect(fetchedPersonalization._$pass.id == pass.id)
        #expect(fetchedPersonalization._$fullName.value == fullName)
        #expect(fetchedPersonalization._$givenName.value == givenName)
        #expect(fetchedPersonalization._$familyName.value == familyName)
        #expect(fetchedPersonalization._$emailAddress.value == emailAddress)
        #expect(fetchedPersonalization._$postalCode.value == postalCode)
        #expect(fetchedPersonalization._$isoCountryCode.value == isoCountryCode)
        #expect(fetchedPersonalization._$phoneNumber.value == phoneNumber)
        #expect(fetchedPersonalization._$id != nil)

        try await migration.revert(on: test.db)
    }

    @Test("PassesRegistrationModel `for` QueryBuilder")
    func forQueryBuilder() async throws {
        let migration = CreatePassesRegistration()
        try await migration.prepare(on: test.db)

        let libraryIdentifier = "Test Library Identifier"
        let pushToken = "Test Push Token"
        let device = PassesDevice(libraryIdentifier: libraryIdentifier, pushToken: pushToken)
        device._$id.value = 1

        let typeIdentifier = "Test Type Identifier"
        let authenticationToken = "Test Authentication Token"
        let pass = Pass(typeIdentifier: typeIdentifier, authenticationToken: authenticationToken)
        pass._$id.value = UUID()

        let passesRegistration = PassesRegistration()
        passesRegistration.$device.id = device.id!
        passesRegistration.$pass.id = pass.id!

        test.append([
            TestOutput(passesRegistration)
        ])

        let fetchedPassesRegistration = try #require(
            await PassesRegistration
                .for(
                    deviceLibraryIdentifier: libraryIdentifier,
                    typeIdentifier: typeIdentifier,
                    on: test.db
                )
                .first()
        )
        #expect(fetchedPassesRegistration._$device.id == device.id)
        #expect(fetchedPassesRegistration._$pass.id == pass.id)

        try await migration.revert(on: test.db)
    }

    @Test("SerialNumbersDTO")
    func serialNumbersDTO() {
        let serialNumbers = ["Test Serial Number 1", "Test Serial Number 2"]
        let maxDate = Date.now
        let serialNumbersDTO = SerialNumbersDTO(with: serialNumbers, maxDate: maxDate)
        #expect(serialNumbersDTO.lastUpdated == String(maxDate.timeIntervalSince1970))
        #expect(serialNumbersDTO.serialNumbers == serialNumbers)
    }

    @Test("PersonalizationDictionaryDTO")
    func personalizationDictionaryDTO() throws {
        let personalizationToken = "Test Personalization Token"
        let requiredPersonalizationInfo = PersonalizationDictionaryDTO.RequiredPersonalizationInfo(
            emailAddress: "Test Email Address",
            familyName: "Test Family Name",
            fullName: "Test Full Name",
            givenName: "Test Given Name",
            isoCountryCode: "Test ISO Country Code",
            phoneNumber: "Test Phone Number",
            postalCode: "Test Postal Code"
        )
        let personalizationDictionaryDTO = PersonalizationDictionaryDTO(
            personalizationToken: personalizationToken,
            requiredPersonalizationInfo: requiredPersonalizationInfo
        )
        #expect(personalizationDictionaryDTO.personalizationToken == personalizationToken)
        #expect(personalizationDictionaryDTO.requiredPersonalizationInfo.emailAddress == requiredPersonalizationInfo.emailAddress)
        #expect(personalizationDictionaryDTO.requiredPersonalizationInfo.familyName == requiredPersonalizationInfo.familyName)
        #expect(personalizationDictionaryDTO.requiredPersonalizationInfo.fullName == requiredPersonalizationInfo.fullName)
        #expect(personalizationDictionaryDTO.requiredPersonalizationInfo.givenName == requiredPersonalizationInfo.givenName)
        #expect(personalizationDictionaryDTO.requiredPersonalizationInfo.isoCountryCode == requiredPersonalizationInfo.isoCountryCode)
        #expect(personalizationDictionaryDTO.requiredPersonalizationInfo.phoneNumber == requiredPersonalizationInfo.phoneNumber)
        #expect(personalizationDictionaryDTO.requiredPersonalizationInfo.postalCode == requiredPersonalizationInfo.postalCode)

        // Test `PersonalizationDictionaryDTO.RequiredPersonalizationInfo` `CodingKeys`
        let encoded = try JSONEncoder().encode(requiredPersonalizationInfo)
        let jsonString = String(data: encoded, encoding: .utf8)!
        #expect(jsonString.contains("ISOCountryCode"))
        #expect(!jsonString.contains("isoCountryCode"))
        let decoded = try JSONDecoder().decode(PersonalizationDictionaryDTO.RequiredPersonalizationInfo.self, from: encoded)
        #expect(decoded.isoCountryCode == requiredPersonalizationInfo.isoCountryCode)
    }

    @Test("PushTokenDTO")
    func pushTokenDTO() {
        let pushToken = "Test Push Token"
        let pushTokenDTO = PushTokenDTO(pushToken: pushToken)
        #expect(pushTokenDTO.pushToken == pushToken)
    }

    @Test("LogEntriesDTO")
    func logEntriesDTO() {
        let logEntries = ["Test Log Entry 1", "Test Log Entry 2"]
        let logEntriesDTO = LogEntriesDTO(logs: logEntries)
        #expect(logEntriesDTO.logs == logEntries)
    }
}
