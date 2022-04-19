// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "uikit-textfield",
  platforms: [
    .iOS(.v14),
  ],
  products: [
    .library(
      name: "UIKitTextField",
      targets: ["UIKitTextField"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0"),
    .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.1"),
  ],
  targets: [
    .target(
      name: "UIKitTextField",
      dependencies: []
    ),
    .testTarget(
      name: "UIKitTextFieldTests",
      dependencies: [
        "UIKitTextField",
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
        "ViewInspector",
      ],
      resources: [.process("__Snapshots__")]
    ),
  ]
)
