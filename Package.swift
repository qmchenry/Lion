// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "lion",
    dependencies: [
        .Package(url: "https://github.com/SmallPlanet/GenKit.git", Version(0, 1, 0, prereleaseIdentifiers: ["pre"], buildMetadataIdentifier: "2")),
    ]
)
