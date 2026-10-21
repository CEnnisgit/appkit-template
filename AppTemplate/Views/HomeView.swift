import SwiftUI

/// Placeholder home screen. Replace with the app's core feature.
struct HomeView: View {
    @Binding var showPaywall: Bool
    @Binding var path: [AppRoute]
    @Environment(StoreManager.self) private var store
    @Environment(LocalAnalytics.self) private var analytics

    var body: some View {
        List {
            Section {
                Text("Your app goes here.")
                    .font(.title2.weight(.semibold))
                Button("Free action") { analytics.log("free_action") }
                Button {
                    if store.isPro { analytics.log("pro_action") } else { showPaywall = true }
                } label: {
                    Label(store.isPro ? "Pro action" : "Pro action (unlock)",
                          systemImage: store.isPro ? "star.fill" : "lock.fill")
                }
            }
        }
        .navigationTitle(AppConfig.appName)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { path.append(.settings) } label: { Image(systemName: "gearshape") }
                    .accessibilityLabel("Settings")
            }
        }
    }
}
