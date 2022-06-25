// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MIDIKitControlSurfaces",

    platforms: [
        .macOS(.v10_12), .iOS(.v10),
    ],

    products: [
        .library(
            name: "MIDIKitControlSurfaces",
            type: .static,
            targets: ["MIDIKitControlSurfaces"]
        ),
    ],

    dependencies: [
        .package(url: "https://github.com/orchetect/MIDIKit", from: "0.5.0"),
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
