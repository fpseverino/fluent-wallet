# ``FluentWalletPasses/PassDataModel``

## Overview

The `FluentWalletPasses` framework provides models to save all the basic information for passes, user devices and their registration to each pass.
For all the other custom data needed to generate the pass, such as the barcodes, locations, etc., you have to create your own model and its model middleware to handle the creation and update of passes.
The pass data model will be used to generate the `pass.json` file contents.

### Implement the Pass Data Model

Your data model should contain all the fields that you store for your pass, as well as a foreign key to ``Pass`` and a pass type identifier that's registered with Apple.

@Snippet(path: "fluent-wallet/Snippets/PassData", slice: PASS_DATA)

Don't forget to create the migration for the ``PassDataModel``.

@Snippet(path: "fluent-wallet/Snippets/PassData", slice: CREATE_PASS_DATA)

You also have to define two methods in the ``PassDataModel``:
- ``PassDataModel/passJSON(on:)``, where you'll have to return a `struct` that conforms to `PassJSON.Properties`.
- ``PassDataModel/sourceFilesDirectoryPath(on:)``, where you'll have to return the path to a folder containing the pass files.

@Snippet(path: "fluent-wallet/Snippets/PassData", slice: PASS_JSON)

### Handle Cleanup

Depending on your implementation details, you may want to automatically clean out the passes and devices table when a registration is deleted.
The implementation will be based on your type of SQL database, as there's not yet a Fluent way to implement something like SQL's `NOT EXISTS` call with a `DELETE` statement.

> Warning: Be careful with SQL triggers, as they can have unintended consequences if not properly implemented.

### Model the pass.json contents

You have to create a `struct` that implements `PassJSON.Properties`, which will contain all the fields for the generated `pass.json` file, to return in the ``PassDataModel/passJSON(on:)`` method.
Create an initializer that takes your custom pass data, the ``Pass`` and everything else you may need.

> Tip: For information on the various keys available see the [documentation](https://developer.apple.com/documentation/walletpasses/pass). See also [this guide](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/PassKit_PG/index.html#//apple_ref/doc/uid/TP40012195-CH1-SW1) for some help.

@Snippet(path: "fluent-wallet/Snippets/PassData", slice: PASS_JSON_DATA)

### Implement the Web Service

After implementing the data models, you have to implement the web service that will handle the pass creation and update.

You can use the concrete models provided by `FluentWalletPasses` or create your own models that conform to the protocols defined in the package.
For the provided models, there are corresponding migrations that you can use to create the tables in your database.

It's highly recommended to create a model middleware for your custom ``PassDataModel`` to handle the creation and update of passes, because whenever your pass data changes, you must update the ``Pass/updatedAt`` time so that Wallet knows to retrieve a new pass.
