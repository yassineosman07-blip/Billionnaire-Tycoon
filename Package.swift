// swift-tools-version: 6.0
import PackageDescription
let package = Package(name: "BusinessClickerCore", platforms: [.iOS(.v17), .macOS(.v14)], products: [.library(name: "BusinessClickerCore", targets: ["BusinessClickerCore"])], targets: [.target(name: "BusinessClickerCore", path: "BusinessClicker/Core"), .testTarget(name: "BusinessClickerCoreTests", dependencies: ["BusinessClickerCore"], path: "BusinessClicker/Tests", exclude: ["iOS"])], swiftLanguageModes: [.v5])
