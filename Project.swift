import ProjectDescription

let project = Project(
    name: "clickconsultas-mobile-ios",
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
            dependencies: [],
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
