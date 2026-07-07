import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productID = "tailmeds_pro_monthly"

    @Published var isPurchased: Bool = false
    @Published var product: Product?
    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                await self?.handle(result)
            }
        }
        Task { await loadProduct() }
        Task { await refreshEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productID])
            product = products.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                await handle(verification)
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result else { return }
        await transaction.finish()
        await refreshEntitlements()
    }

    func refreshEntitlements() async {
        var purchased = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.productID {
                purchased = true
            }
        }
        isPurchased = purchased
    }
}
