// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SnackBack",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "SnackBack",
      targets: ["SnackBack"])
  ],
  dependencies: [
    .package(url: "https://github.com/dtaylor1701/SnackBackModels", from: "0.1.0"),
    .package(url: "https://github.com/dtaylor1701/Pigeon", from: "1.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "SnackBack",
      dependencies: [
        .product(name: "SnackBackModels", package: "SnackBackModels"),
        .product(name: "Pigeon", package: "Pigeon"),
      ]),
    .testTarget(
      name: "SnackBackTests",
      dependencies: ["SnackBack"]),
  ]
)
