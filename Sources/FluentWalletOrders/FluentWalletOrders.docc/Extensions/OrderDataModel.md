# ``FluentWalletOrders/OrderDataModel``

## Overview

The `FluentWalletOrders` framework provides models to save all the basic information for orders, user devices and their registration to each order.
For all the other custom data needed to generate the order, such as the barcodes, merchant info, etc., you have to create your own model and its model middleware to handle the creation and update of order.
The order data model will be used to generate the `order.json` file contents.

### Implement the Order Data Model

Your data model should contain all the fields that you store for your order, as well as a foreign key to ``Order`` and a order type identifier that's registered with Apple.

@Snippet(path: "fluent-wallet/Snippets/OrderData", slice: ORDER_DATA)

Don't forget to create the migration for the ``OrderDataModel``.

@Snippet(path: "fluent-wallet/Snippets/OrderData", slice: CREATE_ORDER_DATA)

You also have to define two methods in the ``OrderDataModel``:
- ``OrderDataModel/orderJSON(on:)``, where you'll have to return a `struct` that conforms to `OrderJSON.Properties`.
- ``OrderDataModel/sourceFilesDirectoryPath(on:)``, where you'll have to return the path to a folder containing the order files.

@Snippet(path: "fluent-wallet/Snippets/OrderData", slice: ORDER_JSON)

### Handle Cleanup

Depending on your implementation details, you may want to automatically clean out the orders and devices table when a registration is deleted.
The implementation will be based on your type of SQL database, as there's not yet a Fluent way to implement something like SQL's `NOT EXISTS` call with a `DELETE` statement.

> Warning: Be careful with SQL triggers, as they can have unintended consequences if not properly implemented.

### Model the order.json contents

Create a `struct` that implements `OrderJSON.Properties`, which will contain all the fields for the generated `order.json` file, to return in the ``OrderDataModel/orderJSON(on:)`` method.
Create an initializer that takes your custom order data, the ``Order`` and everything else you may need.

> Tip: For information on the various keys available see the [documentation](https://developer.apple.com/documentation/walletorders/order).

@Snippet(path: "fluent-wallet/Snippets/OrderData", slice: ORDER_JSON_DATA)

### Implement the Web Service

After implementing the data models, you have to implement the web service that will handle the order creation and update.

You can use the concrete models provided by `FluentWalletOrders` or create your own models that conform to the protocols defined in the package.
For the provided models, there are corresponding migrations that you can use to create the tables in your database.

It's highly recommended to create a model middleware for your custom ``OrderDataModel`` to handle the creation and update of orders, because whenever your order data changes, you must update the ``Order/updatedAt`` time so that Wallet knows to retrieve a new order.
