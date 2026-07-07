import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accent)
                Text("Tailmeds Pro")
                    .font(Theme.titleFont)
                Text("Trigger correlation view linking symptoms to food/environment tags")
                    .font(Theme.bodyFont)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                if let product = purchases.product {
                    Button {
                        Task {
                            await purchases.purchase()
                            if purchases.isPurchased { dismiss() }
                        }
                    } label: {
                        Text("Unlock for \(product.displayPrice)")
                            .font(Theme.headlineFont)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .accessibilityIdentifier("purchaseButton")
                    .padding(.horizontal)
                } else {
                    ProgressView()
                }
                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .accessibilityIdentifier("paywallRestoreButton")
                Button("Not now") { dismiss() }
                    .accessibilityIdentifier("paywallDismissButton")
                    .padding(.bottom)
            }
            .padding()
            .navigationTitle("Go Pro")
        }
    }
}
