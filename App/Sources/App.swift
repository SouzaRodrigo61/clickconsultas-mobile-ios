import SwiftUI
import ComposableArchitecture

@main
struct ClickConsultasApp: App {
    init() {
        loadRocketSimConnect()
    }
    
    @State private var store = Store(initialState: Root.Feature.State()) {
        Root.Feature()
    }
    
    var body: some Scene {
        WindowGroup {
            Root.ContentView(store: store)
                .preferredColorScheme(.light)
        }
    }
}

private func loadRocketSimConnect() {
    #if DEBUG
    guard (Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
        print("Failed to load linker framework")
        return
    }
    print("RocketSim Connect successfully linked")
    #endif
}
