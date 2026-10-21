# AppKit template

Shared skeleton for Nimbus Web Design's small iPhone apps, generalized from Keepwell.
XcodeGen project, SwiftUI, iOS 17+, iPhone only, Swift 6 with complete strict concurrency.
No networking, no ads, no third-party analytics and no Swift packages.

## What's in it

| Piece | Where |
|---|---|
| App config (name, product IDs, links, copy, Pro benefits, onboarding pages) | `AppTemplate/App/AppConfig.swift` |
| StoreKit 2 entitlement manager (monthly / yearly / lifetime, no weekly) | `AppTemplate/Services/StoreManager.swift` |
| Paywall: prices, renewal terms, Terms / Privacy / Support, Restore | `AppTemplate/Views/PaywallView.swift` |
| 3-screen onboarding | `AppTemplate/Views/OnboardingView.swift` |
| Settings: Pro status, upgrade, Restore, Manage Subscription + "Settings › [your name] › Subscriptions" copy, privacy, rate, support | `AppTemplate/Views/SettingsView.swift` |
| On-device-only analytics (event counter in UserDefaults; nothing leaves the device) | `AppTemplate/Services/LocalAnalytics.swift` |
| Privacy manifest (no tracking, no collected data, UserDefaults CA92.1) | `AppTemplate/Resources/PrivacyInfo.xcprivacy` |
| Local StoreKit test config ($2.99 / $12.99 / $19.99 placeholders) | `AppTemplate.storekit` (wired into the scheme) |
| DEBUG screenshot hooks | `AppTemplate/App/DebugHooks.swift`, `RootView.runDebugHook()` |
| Unit tests | `AppTemplateTests/` |
| Simulator proof CI | `.github/workflows/sim-proof.yml`, `scripts/sim/` |
| New-app generator | `scripts/new-app.sh` |

## Make a new app

```sh
scripts/new-app.sh Quietwell quietwell ../quietwell
```

This copies the template, renames `AppTemplate` to the name and `apptemplate` to the suffix in
paths and contents (bundle `com.nimbuswebdesign.<suffix>`, products
`com.nimbuswebdesign.<suffix>.pro.monthly|yearly|lifetime`) and gives the `.storekit` file a new
identifier. Then edit `AppConfig.swift`, the prices in the `.storekit` file and
`debugFallbackPrices`, replace the icon, and build the feature in `HomeView`.

## Build locally

```sh
brew install xcodegen
xcodegen generate
open AppTemplate.xcodeproj
```

## Screenshot hooks (DEBUG only)

Launch with `-AppScreen <hook>` and optionally `-AppPro YES` (forces Pro without a purchase).
Generic hooks: `onboarding`, `home`, `paywall`, `settings`. When the screen is up, the app writes
`Documents/app-state.json` with `"ready": "true"`; `scripts/sim/capture.sh` waits for that, lets
the screen settle and captures a screenshot. Add app hooks in `RootView.runDebugHook()` and list
them in the workflow's `HOOKS` (`hook` or `hook:pro`).

## sim-proof CI

Runs on pushes to `feat/**` and on manual dispatch (private repos use free macOS minutes, billed
10x). It generates the project, builds for an iPhone 17 Pro Max (or 16 Pro Max) Simulator without
signing, runs the unit tests, captures every hook and checks each screenshot is 1320x2868. The
`sim-proof` artifact has logs, test counts and screenshots.

## App Store notes

- Paywall and listing must show price, period, auto-renew terms, Terms (Apple EULA) and Privacy links, and Restore.
- Privacy label: Data Not Collected (on-device counter only).
- Each app built from this must have a distinct feature set (Guideline 4.3).
