import Foundation

/// Everything app-specific that the shared screens read. `scripts/new-app.sh` renames
/// "AppTemplate"/"apptemplate"; then edit the copy, benefits and prices here.
enum AppConfig {
    static let appName = "AppTemplate"
    static let proName = "AppTemplate Pro"
    static let bundleID = "com.nimbuswebdesign.apptemplate"

    enum ProductID {
        static let monthly = "com.nimbuswebdesign.apptemplate.pro.monthly"
        static let yearly = "com.nimbuswebdesign.apptemplate.pro.yearly"
        static let lifetime = "com.nimbuswebdesign.apptemplate.pro.lifetime"
        static let all = [monthly, yearly, lifetime]
    }

    /// DEBUG-only paywall prices for Simulator runs launched outside Xcode (no StoreKit config).
    /// Keep in sync with AppTemplate.storekit.
    static let debugFallbackPrices: [String: String] = [
        ProductID.monthly: "$2.99",
        ProductID.yearly: "$12.99",
        ProductID.lifetime: "$19.99",
    ]

    enum Links {
        static let privacy = URL(string: "https://nimbuswebdesign.com/apps/apptemplate/privacy/")!
        static let support = URL(string: "https://nimbuswebdesign.com/apps/apptemplate/support/")!
        /// Apple's standard EULA, used as the Terms of Use for subscriptions.
        static let terms = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!
    }

    static let paywallTagline = "Everything in the free version, plus more. Nothing leaves your iPhone."
    static let freeTierSummary = "The free version keeps working with no time limit."
    static let privacySummary = "Everything happens on your iPhone. No account, no ads, no third-party analytics and no network requests."

    static let proBenefits: [Benefit] = [
        Benefit(icon: "sparkles", title: "Pro feature one", detail: "Describe the first Pro benefit."),
        Benefit(icon: "square.stack.3d.up", title: "Pro feature two", detail: "Describe the second Pro benefit."),
        Benefit(icon: "heart", title: "Support an indie app", detail: "No ads, ever."),
    ]

    static let onboardingPages: [OnboardingPage] = [
        OnboardingPage(icon: "hand.wave", title: "Welcome to AppTemplate", body: "One sentence about what the app does."),
        OnboardingPage(icon: "bolt", title: "How it works", body: "One sentence about the core loop."),
        OnboardingPage(icon: "lock.shield", title: "Private by design", body: "Everything stays on your iPhone. No account needed."),
    ]
}

struct Benefit: Sendable, Identifiable, Hashable {
    let icon: String
    let title: String
    let detail: String
    var id: String { title }
}

struct OnboardingPage: Sendable, Identifiable, Hashable {
    let icon: String
    let title: String
    let body: String
    var id: String { title }
}
