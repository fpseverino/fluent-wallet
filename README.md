# FluentWallet

🎟️ 📦 A collection of Fluent models for managing passes and orders for Apple Wallet.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ffpseverino%2Ffluent-wallet%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/fpseverino/fluent-wallet)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ffpseverino%2Ffluent-wallet%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/fpseverino/fluent-wallet)

[![](https://img.shields.io/github/actions/workflow/status/fpseverino/fluent-wallet/test.yml?event=push&style=plastic&logo=github&label=tests&logoColor=%23ccc)](https://github.com/fpseverino/fluent-wallet/actions/workflows/test.yml)
[![](https://img.shields.io/codecov/c/github/fpseverino/fluent-wallet?style=plastic&logo=codecov&label=codecov)](https://codecov.io/github/fpseverino/fluent-wallet)

## Overview

This package provides a collection of Fluent protocol and concrete models, useful for managing the creation and update of passes and orders for the Apple Wallet app with your Swift on Server application.

### Getting Started

Use the SPM string to easily include the dependendency in your `Package.swift` file

```swift
.package(url: "https://github.com/fpseverino/fluent-wallet.git", from: "0.1.0")
```

and add the product you want to use to your target's dependencies:

```swift
.product(name: "FluentWalletPasses", package: "fluent-wallet")
```

```swift
.product(name: "FluentWalletOrders", package: "fluent-wallet")
```
