# Setting Up Pass Personalization

Create a personalized pass for Apple Wallet.

## Overview

> Warning: This section is a work in progress. Testing is hard without access to the certificates required to develop this feature. If you have access to the entitlements, please help us implement this feature.

Pass Personalization lets you create passes, referred to as personalizable passes, that prompt the user to provide personal information during signup that is used to update the pass.

> Important: Making a pass personalizable, just like adding NFC to a pass, requires a special entitlement issued by Apple. Although accessing such entitlements is hard if you're not a big company, you can learn more in [Getting Started with Apple Wallet](https://developer.apple.com/wallet/get-started/).

Personalizable passes can be distributed like any other pass. For information on personalizable passes, see the [Wallet Developer Guide](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/PassKit_PG/PassPersonalization.html#//apple_ref/doc/uid/TP40012195-CH12-SW2) and [Return a Personalized Pass](https://developer.apple.com/documentation/walletpasses/return_a_personalized_pass).

### Implement the Data Model

You'll have to make a few changes to your ``PassDataModel`` to support personalizable passes.

A personalizable pass is just a standard pass package with the following additional files:

- A `personalization.json` file.
- A `personalizationLogo@XX.png` file.

Implement the ``PassDataModel/personalizationJSON(on:)`` method.
If the pass requires personalization, and if it was not already personalized, create the `PersonalizationJSON` struct, which will contain all the fields for the generated `personalization.json` file, and return it, otherwise return `nil`.

In the ``PassDataModel/sourceFilesDirectoryPath(on:)`` method, you have to return two different directory paths, depending on whether the pass has to be personalized or not. If it does, the directory must contain the `personalizationLogo@XX.png` file.

Finally, you have to implement the ``PassDataModel/passJSON(on:)`` method as usual, but remember to use in the `PassJSON.Properties` initializer the user info that will be saved inside ``Personalization`` after the pass has been personalized.
Each ``Personalization`` instance has a reference to the pass it belongs to, so you can easily retrieve the user info for the pass.

```swift
extension PassData {
    func passJSON(on db: any Database) async throws -> any PassJSON.Properties {
        // Here create the pass JSON data as usual.
        try await PassJSONData(data: self, pass: self.$pass.get(on: db))
    }

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

    func sourceFilesDirectoryPath(on db: any Database) async throws -> String {
        if self.requiresPersonalization {
            // If the pass requires personalization, return the URL path to the personalization template,
            // which must contain the `personalizationLogo@XX.png` file.
            return "SourceFiles/Passes/Personalization/"
        } else {
            // Otherwise, return the URL path to the standard pass template.
            return "SourceFiles/Passes/Standard/"
        }
    }
}
```

### Implement the Web Service

After implementing the data model methods, you have to implement the web service that will handle the personalization.

Build the pass bundle with a `PassBuilder` as usual and distribute it.
The user will be prompted to provide the required personal information when they add the pass.
Wallet will then send the user personal information to your server, which should be saved in the ``Personalization`` table.
Immediately after that, Wallet will request the updated pass.
This updated pass will contain the user personalization data that was previously saved inside the ``Personalization`` table.
You can access the pass linked to the personalization data by using the ``Personalization/pass`` field.

> Important: This updated and personalized pass **must not** contain the `personalization.json` file, so make sure that the ``PassDataModel/personalizationJSON(on:)`` method returns `nil` when the pass has already been personalized.

## Topics

### Data Model Method

- ``PassDataModel/personalizationJSON(on:)``
