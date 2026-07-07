import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @AppStorage("tailmeds_notifEnabled") private var notifEnabled: Bool = true
    @AppStorage("tailmeds_reminderEnabled") private var reminderEnabled: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Enable notifications", isOn: $notifEnabled)
                        .accessibilityIdentifier("notifToggle")
                    Toggle("Enable reminders", isOn: $reminderEnabled)
                        .accessibilityIdentifier("reminderToggle")
                }
                Section("Subscription") {
                    if purchases.isPurchased {
                        Label("Pro unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Restore Purchases") {
                            Task { await purchases.restore() }
                        }
                        .accessibilityIdentifier("restoreButton")
                    }
                }
                Section("Legal") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/tailmeds-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/tailmeds-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
        }
    }
}
