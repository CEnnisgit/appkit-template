import SwiftUI

enum AppRoute: Hashable {
    case settings
}

struct RootView: View {
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    @Environment(LocalAnalytics.self) private var analytics
    @State private var path: [AppRoute] = []
    @State private var showPaywall = false
    @State private var didRunDebugHook = false

    var body: some View {
        Group {
            if hasOnboarded {
                NavigationStack(path: $path) {
                    HomeView(showPaywall: $showPaywall, path: $path)
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .settings: SettingsView(showPaywall: $showPaywall)
                            }
                        }
                }
            } else {
                OnboardingView {
                    analytics.log("onboarding_done")
                    hasOnboarded = true
                }
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .onAppear { analytics.log("paywall_view") }
        }
        .task { await runDebugHook() }
    }

    private func runDebugHook() async {
        #if DEBUG
        guard !didRunDebugHook, let screen = DebugHooks.screen else { return }
        didRunDebugHook = true
        // Generic hooks: onboarding | home | paywall | settings
        switch screen {
        case "onboarding": hasOnboarded = false
        case "paywall": hasOnboarded = true; showPaywall = true
        case "settings": hasOnboarded = true; path = [.settings]
        default: hasOnboarded = true
        }
        try? await Task.sleep(for: .seconds(2))
        DebugHooks.report(["screen": screen, "ready": "true"])
        #endif
    }
}
