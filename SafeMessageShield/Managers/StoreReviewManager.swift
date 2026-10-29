//
//  StoreReviewManager.swift
//  SafeMessageShield
//

import Foundation
import StoreKit
import SwiftUI

/// Akıllı App Store Puanlama İstem Yöneticisi
/// Yalnızca kullanıcının uygulamadan gerçek değer aldığı başarılı işlemlerden sonra,
/// sürüm başına maksimum 1 defa ve cooldown süresiyle tetiklenir.
@MainActor
final class StoreReviewManager {
    static let shared = StoreReviewManager()

    // MARK: - Keys
    static let actionCountKey = "review_positive_action_count"
    static let lastPromptVersionKey = "review_last_prompted_version"
    static let lastPromptDateKey = "review_last_prompted_date"

    // MARK: - Configuration
    static let defaultThreshold = 3
    static let defaultCooldownDays: TimeInterval = 30

    // MARK: - Dependencies (for Unit Testing)
    private let userDefaults: UserDefaults
    private let dateProvider: () -> Date
    private let versionProvider: () -> String
    private let reviewRequester: () -> Void

    init(
        userDefaults: UserDefaults = .standard,
        dateProvider: @escaping () -> Date = { Date() },
        versionProvider: @escaping () -> String = {
            Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
        },
        reviewRequester: @escaping () -> Void = {
            if let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    ) {
        self.userDefaults = userDefaults
        self.dateProvider = dateProvider
        self.versionProvider = versionProvider
        self.reviewRequester = reviewRequester
    }

    // MARK: - Public State Accessors
    var actionCount: Int {
        get { userDefaults.integer(forKey: Self.actionCountKey) }
        set { userDefaults.set(newValue, forKey: Self.actionCountKey) }
    }

    var lastPromptVersion: String? {
        get { userDefaults.string(forKey: Self.lastPromptVersionKey) }
        set { userDefaults.set(newValue, forKey: Self.lastPromptVersionKey) }
    }

    var lastPromptDate: Date? {
        get { userDefaults.object(forKey: Self.lastPromptDateKey) as? Date }
        set { userDefaults.set(newValue, forKey: Self.lastPromptDateKey) }
    }

    // MARK: - Public Methods

    /// Kullanıcının değer aldığı başarılı bir işlemi kaydeder ve gerekiyorsa puanlama ister.
    @discardableResult
    func recordPositiveAction(
        threshold: Int = defaultThreshold,
        cooldownDays: TimeInterval = defaultCooldownDays
    ) -> Bool {
        actionCount += 1
        return requestReviewIfAppropriate(threshold: threshold, cooldownDays: cooldownDays)
    }

    /// Koşullar sağlanıyorsa puanlama istemini tetikler.
    @discardableResult
    func requestReviewIfAppropriate(
        threshold: Int = defaultThreshold,
        cooldownDays: TimeInterval = defaultCooldownDays
    ) -> Bool {
        guard canRequestReview(threshold: threshold, cooldownDays: cooldownDays) else {
            return false
        }

        let currentVersion = versionProvider()
        let currentDate = dateProvider()

        lastPromptVersion = currentVersion
        lastPromptDate = currentDate

        reviewRequester()
        return true
    }

    /// Puanlama istemi için tüm koşulların geçerli olup olmadığını doğrular.
    func canRequestReview(
        threshold: Int = defaultThreshold,
        cooldownDays: TimeInterval = defaultCooldownDays
    ) -> Bool {
        // 1. Eşik kontrolü: Yeterli pozitif işlem yapıldı mı?
        guard actionCount >= threshold else { return false }

        let currentVersion = versionProvider()

        // 2. Sürüm kontrolü: Bu sürümde daha önce gösterildi mi?
        if let lastVersion = lastPromptVersion, lastVersion == currentVersion {
            return false
        }

        // 3. Cooldown kontrolü: En son gösterimden beri yeterli süre geçti mi?
        if let lastDate = lastPromptDate {
            let elapsed = dateProvider().timeIntervalSince(lastDate)
            let cooldownSeconds = cooldownDays * 86400
            if elapsed < cooldownSeconds {
                return false
            }
        }

        return true
    }

    /// Sayacı sıfırlama (testler veya özel durumlar için)
    func reset() {
        userDefaults.removeObject(forKey: Self.actionCountKey)
        userDefaults.removeObject(forKey: Self.lastPromptVersionKey)
        userDefaults.removeObject(forKey: Self.lastPromptDateKey)
    }
}
