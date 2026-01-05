// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AXKit",
  platforms: [
    .macOS(.v13),
  ],
  products: [
    .library(
      name: "AXKit",
      targets: ["AXKit"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    .package(url: "https://github.com/airbnb/swift", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "AXKit",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
      ],
      swiftSettings: [
        .enableExperimentalFeature("StrictConcurrency")
      ]
    ),
    .testTarget(
      name: "AXKitTests",
      dependencies: ["AXKit"]),
  ])
