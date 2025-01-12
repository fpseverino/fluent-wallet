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
    var formatVersion = PassJSON.FormatVersion.v1
    var organizationName = "example"
    var teamIdentifier = "DEF123GHIJ"  // You should keep this value secret
    var webServiceURL = "https://example.com/api/passes/"
    var logoText = "Example"
    var sharingProhibited = true
    var backgroundColor = "rgb(207, 77, 243)"
    var foregroundColor = "rgb(255, 255, 255)"

    var passTypeIdentifier = PassData.typeIdentifier

    var description: String
    var serialNumber: String
    var authenticationToken: String

    var barcodes = Barcode(message: "message")
    struct Barcode: PassJSON.Barcodes {
        var format = PassJSON.BarcodeFormat.qr
        var message: String
        var messageEncoding = "iso-8859-1"
    }

    let boardingPass = Boarding(transitType: .air)
    struct Boarding: PassJSON.BoardingPass {
        var transitType: PassJSON.TransitType
        var headerFields: [PassField]
        var primaryFields: [PassField]
        var secondaryFields: [PassField]
        var auxiliaryFields: [PassField]
        var backFields: [PassField]

        struct PassField: PassJSON.PassFieldContent {
            var key: String
            var label: String
            var value: String
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
