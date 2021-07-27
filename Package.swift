// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MIDIKitControlSurfaces",

    platforms: [
        .macOS(.v10_12), .iOS(.v10), .tvOS(.v14), .watchOS(.v7)
    ],

    products: [
        .library(
            name: "MIDIKitControlSurfaces",
            type: .static,
            targets: ["MIDIKitControlSurfaces"]
        ),
    ],

    dependencies: [
        .package(url: "https://github.com/orchetect/MIDIKit", .branch("dev")), // from: "0.1.6"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.0.3"),
    ],

    targets: [
        .target(
            name: "MIDIKitControlSurfaces",
            dependencies: [
                .product(name: "MIDIKit", package: "MIDIKit"),
                .product(name: "SwiftRadix", package: "SwiftRadix"),
            ]
        ),

        .testTarget(
            name: "MIDIKitControlSurfacesTests",
            dependencies: [
                .target(name: "MIDIKitControlSurfaces"),
            ]
        )
    ]
)
