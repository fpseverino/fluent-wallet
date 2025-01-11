import FluentKit
import FluentWalletPasses
import Foundation
import WalletPasses

// snippet.PASS_DATA
final class PassData: PassDataModel, @unchecked Sendable {
    static let schema = "pass_data"

    static let typeIdentifier = "pass.com.example.FluentWallet"

    @ID
    var id: UUID?

    @Parent(key: "pass_id")
    var pass: Pass

    // Examples of other extra fields:
    @Field(key: "punches")
    var punches: Int

    @Field(key: "title")
    var title: String

    // Add any other field relative to your app, such as a location, a date, etc.

    init() {}
}

// snippet.CREATE_PASS_DATA
struct CreatePassData: AsyncMigration {
    public func prepare(on database: any Database) async throws {
        try await database.schema(PassData.schema)
            .id()
            .field("pass_id", .uuid, .required, .references(Pass.schema, .id, onDelete: .cascade))
            .field("punches", .int, .required)
            .field("title", .string, .required)
            .create()
    }

    public func revert(on database: any Database) async throws {
        try await database.schema(PassData.schema).delete()
    }
}

// snippet.PASS_JSON
extension PassData {
    func passJSON(on db: any Database) async throws -> any PassJSON.Properties {
        try await PassJSONData(data: self, pass: self.$pass.get(on: db))
    }

    func sourceFilesDirectoryPath(on db: any Database) async throws -> String {
        // The location might vary depending on the type of pass.
        "SourceFiles/Passes/"
    }
}

// snippet.PERSONALIZATION_JSON
extension PassData {
    func personalizationJSON(on db: any Database) async throws -> PersonalizationJSON? {
        let pass = try await self.$pass.get(on: db)

        let personalization = try await Personalization.query(on: db)
            .filter(\.$pass.$id == pass.requireID())
            .first()

        if personalization == nil {
            // If the pass requires personalization, create the personalization JSON struct.
            return PersonalizationJSON(
                requiredPersonalizationFields: [.name, .postalCode, .emailAddress, .phoneNumber],
                description: "Hello, World!"
            )
        } else {
            // Otherwise, return `nil`.
            return nil
        }
    }
}

// snippet.PASS_JSON_DATA
struct PassJSONData: PassJSON.Properties {
    let formatVersion = PassJSON.FormatVersion.v1
    let organizationName = "example"
    let teamIdentifier = "DEF123GHIJ"  // You should keep this value secret
    let webServiceURL = "https://example.com/api/passes/"
    let logoText = "Example"
    let sharingProhibited = true
    let backgroundColor = "rgb(207, 77, 243)"
    let foregroundColor = "rgb(255, 255, 255)"

    let passTypeIdentifier = PassData.typeIdentifier

    let description: String
    let serialNumber: String
    let authenticationToken: String

    let barcodes = Barcode(message: "message")
    struct Barcode: PassJSON.Barcodes {
        let format = PassJSON.BarcodeFormat.qr
        let message: String
        let messageEncoding = "iso-8859-1"
    }

    let boardingPass = Boarding(transitType: .air)
    struct Boarding: PassJSON.BoardingPass {
        let transitType: PassJSON.TransitType
        let headerFields: [PassField]
        let primaryFields: [PassField]
        let secondaryFields: [PassField]
        let auxiliaryFields: [PassField]
        let backFields: [PassField]

        struct PassField: PassJSON.PassFieldContent {
            let key: String
            let label: String
            let value: String
        }

        init(transitType: PassJSON.TransitType) {
            self.headerFields = [.init(key: "header", label: "Header", value: "Header")]
            self.primaryFields = [.init(key: "primary", label: "Primary", value: "Primary")]
            self.secondaryFields = [.init(key: "secondary", label: "Secondary", value: "Secondary")]
            self.auxiliaryFields = [.init(key: "auxiliary", label: "Auxiliary", value: "Auxiliary")]
            self.backFields = [.init(key: "back", label: "Back", value: "Back")]
            self.transitType = transitType
        }
    }

    init(data: PassData, pass: Pass) {
        self.description = data.title
        self.serialNumber = pass.id!.uuidString
        self.authenticationToken = pass.authenticationToken
    }
}
