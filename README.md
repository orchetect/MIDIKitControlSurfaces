![midikitcontrolsurfaces-banner](Images/midikitcontrolsurfaces-banner.png)

# Control Surfaces Extension for [MIDIKit](https://github.com/orchetect/MIDIKit)

[![CI Build Status](https://github.com/orchetect/MIDIKitControlSurfaces/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/MIDIKitControlSurfaces/actions/workflows/build.yml) [![Platforms - macOS 10.12+ | iOS 10+](https://img.shields.io/badge/platforms-macOS%2010.12%2B%20|%20iOS%2010%2B-lightgrey.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/MIDIKitControlSurfaces/blob/main/LICENSE)

This extension adds support for control surface protocol abstractions that operate on the MIDI transport, such as HUI and MCU (Mackie Control Universal).

## Getting Started

1. Add MIDIKitControlSurfaces as a dependency using Swift Package Manager.

   - In an app project or framework, in Xcode:

     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/orchetect/MIDIKitControlSurfaces`

   - In a Swift Package, add it to the Package.swift dependencies:

     ```swift
     .package(url: "https://github.com/orchetect/MIDIKitControlSurfaces", from: "0.0.1")
     ```

1. Import the library:

   ```swift
   import MIDIKitControlSurfaces
   ```

3. See [Examples](https://github.com/orchetect/MIDIKitControlSurfaces/blob/master/Examples/) folder and [Docs](https://github.com/orchetect/MIDIKitControlSurfaces/blob/master/Docs/) folder for usage.

## Documentation

See [Docs](https://github.com/orchetect/MIDIKitControlSurfaces/blob/master/Docs/) folder.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MIDIKitControlSurfaces/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Discussion in Issues is encouraged prior to new features or modifications.
