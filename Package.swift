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

func addShouldTestFlag() {
    // swiftSettings may be nil so we can't directly append to it
    
    var swiftSettings = package.targets
        .first(where: { $0.name == "MIDIKitControlSurfacesTests" })?
        .swiftSettings ?? []
    
    swiftSettings.append(.define("shouldTestCurrentPlatform"))
    
    package.targets
        .first(where: { $0.name == "MIDIKitControlSurfacesTests" })?
        .swiftSettings = swiftSettings
}

// Swift version in Xcode 12.5.1 which introduced watchOS testing
#if os(watchOS) && swift(>=5.4.2)
addShouldTestFlag()
#elseif os(watchOS)
// don't add flag
#else
addShouldTestFlag()
#endif
