// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TinkoffASDK",
    defaultLocalization: "ru",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "TinkoffASDKCore", targets: ["TinkoffASDKCore"]),
        .library(name: "TinkoffASDKUI", targets: ["TinkoffASDKUI"]),
    ],
    targets: [
        .binaryTarget(
            name: "TdsSdkIos",
            path: "ThirdParty/TdsSdkIos.xcframework"
        ),
        .binaryTarget(
            name: "ThreeDSWrapper",
            path: "ThirdParty/ThreeDSWrapper.xcframework"
        ),

        // TinkoffASDKCore

        .target(
            name: "TinkoffASDKCore",
            path: "TinkoffASDKCore/TinkoffASDKCore",
            exclude: ["Resources/Info.plist"],
            resources: [
                .copy("Resources/PrivacyInfo.xcprivacy"),
            ]
        ),

        // TinkoffASDKUI

        .target(
            name: "TinkoffASDKUI",
            dependencies: [
                .target(name: "TinkoffASDKCore"),
                .target(name: "TdsSdkIos"),
                .target(name: "ThreeDSWrapper"),
            ],
            path: "TinkoffASDKUI/TinkoffASDKUI",
            exclude: ["Resources/Info.plist"],
            resources: [
                .copy("Images/Images/tinkoff_40/tinkoff_40@2x.png"),
                .copy("Images/Images/tinkoff_40/tinkoff_40@3x.png"),
            ]
        ),
    ]
)
