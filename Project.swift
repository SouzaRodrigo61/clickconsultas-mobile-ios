import ProjectDescription

let project = Project.clickConsultasProject(
    name: "clickconsultas-mobile-ios",
    packages: Package.clickConsultasPackages,
    targets: [
        .clickConsultasApp(
            name: "clickconsultas-mobile-ios",
            bundleId: "io.clickconsultas.mobile",
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: Package.clickConsultasDependencies + [
                // Add module dependencies here as they are created
                // .target(name: "AuthenticationFeature"),
                // .target(name: "HomeFeature"),
                // .target(name: "SearchFeature"),
                // .target(name: "BookingFeature"),
                // .target(name: "ProfileFeature"),
                // .target(name: "SharedDomain"),
                // .target(name: "SharedData"),
                // .target(name: "SharedDependencies")
            ]
        ),
        .clickConsultasTests(
            name: "clickconsultas-mobile-iosTests",
            bundleId: "io.clickconsultas.mobileTests",
            sources: ["App/Tests/**"],
            dependencies: [.target(name: "clickconsultas-mobile-ios")]
        )
    ],
    schemes: [
        .clickConsultasScheme(
            name: "clickconsultas-mobile-ios",
            target: "clickconsultas-mobile-ios",
            testTarget: "clickconsultas-mobile-iosTests"
        )
    ]
)
