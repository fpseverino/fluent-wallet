# ``FluentWalletPasses``

A collection of Fluent models for managing passes for Apple Wallet.

## Overview

@Row {
    @Column { }
    @Column(size: 4) {
        ![Passes](passes)
    }
    @Column { }
}

This package provides a collection of Fluent protocol and concrete models, useful for managing the creation and update of passes for the Apple Wallet app with your Swift on Server application.

For information on Apple Wallet passes, see the [Apple Developer Documentation](https://developer.apple.com/documentation/walletpasses).

## Topics

### Models

- ``PassDataModel``
- ``PassModel``
- ``PassesRegistrationModel``

### Concrete Models

- ``Pass``
- ``PassesDevice``
- ``PassesRegistration``

### Migrations

- ``CreatePass``
- ``CreatePassesDevice``
- ``CreatePassesRegistration``

### DTOs

- ``SerialNumbersDTO``

### Personalized Passes

- <doc:PersonalizedPasses>
- ``PersonalizationModel``
- ``Personalization``
- ``CreatePersonalization``
- ``PersonalizationDictionaryDTO``
