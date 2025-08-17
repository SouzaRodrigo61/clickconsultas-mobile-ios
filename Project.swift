import ProjectDescription

let project = Project(
    name: "clickconsultas-mobile-ios",
    packages: [
        .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .exact("1.20.1")),
        .remote(url: "https://github.com/1998code/SwiftGlass.git", requirement: .exact("1.8.0")),
        .remote(url: "https://github.com/Aeastr/Portal.git", requirement: .exact("2.0.0")),
        .remote(url: "https://github.com/nathantannar4/Transmission", requirement: .exact("2.5.3")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .exact("12.1.0")),
        .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .exact("9.0.0")),
        .remote(url: "https://github.com/siteline/SwiftUI-Introspect", requirement: .exact("1.4.0-beta.4"))
    ],
    targets: [
        .target(
            name: "clickconsultas-mobile-ios",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.clickconsultas-mobile-ios",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .package(product: "ComposableArchitecture"),
                .package(product: "SwiftGlass"),
                .package(product: "Portal"),
                .package(product: "Transmission"),
                .package(product: "FirebaseCrashlytics"),
                .package(product: "FirebaseAnalytics"),
                .package(product: "FirebaseAuth"),
                .package(product: "GoogleSignIn"),
                .package(product: "SwiftUIIntrospect")
            ],
            settings: .settings(
                base: [:],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ],
                defaultSettings: .recommended
            ),
            additionalFiles: []
        ),
        .target(
            name: "clickconsultas-mobile-iosTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.clickconsultas-mobile-iosTests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [.target(name: "clickconsultas-mobile-ios")]
        ),
    ],
    schemes: [
        .scheme(
            name: "clickconsultas-mobile-ios",
            shared: true,
            buildAction: .buildAction(targets: ["clickconsultas-mobile-ios"]),
            testAction: .targets(["clickconsultas-mobile-iosTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release"),
            profileAction: .profileAction(configuration: "Release"),
            analyzeAction: .analyzeAction(configuration: "Debug")
        )
    ]
)
