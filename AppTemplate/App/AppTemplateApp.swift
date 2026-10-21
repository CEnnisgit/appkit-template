import SwiftUI

@main
struct AppTemplateApp: App {
    @State private var store = StoreManager()
    @State private var analytics = LocalAnalytics()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .environment(analytics)
                .task {
                    #if DEBUG
                    if DebugHooks.forcePro { store.debugForcePro = true }
                    #endif
                    analytics.log("app_open")
                    await store.start()
                }
        }
    }
}
