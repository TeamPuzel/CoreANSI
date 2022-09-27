// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "CoreANSI",
    products: [.library(name: "CoreANSI", targets: ["CoreANSI"])],
    targets: [.target(name: "CoreANSI", dependencies: [])]
)
