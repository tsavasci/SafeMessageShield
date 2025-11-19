//
//  DataManager.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import Foundation

/// App Group ID - Ana uygulama ve extension'lar arasında veri paylaşımı için
let kAppGroupIdentifier = "group.tsavasci.SafeMessageShield"

class DataManager {
    static let shared = DataManager()

    private let userDefaults: UserDefaults
    private let blockedNumbersKey = "blockedNumbers"
    private let allowedNumbersKey = "allowedNumbers"
    private let filterRulesKey = "filterRules"

    private init() {
        guard let defaults = UserDefaults(suiteName: kAppGroupIdentifier) else {
            fatalError("App Group oluşturulamadı. Capabilities ayarlarını kontrol edin.")
        }
        self.userDefaults = defaults
    }

    // MARK: - Blocked Numbers Management

    func getBlockedNumbers() -> [String] {
        return userDefaults.stringArray(forKey: blockedNumbersKey) ?? []
    }

    func addBlockedNumber(_ phoneNumber: String) {
        var numbers = getBlockedNumbers()
        let cleanedNumber = phoneNumber.replacingOccurrences(
            of: "[^0-9+]", with: "", options: .regularExpression)

        if !numbers.contains(cleanedNumber) {
            numbers.append(cleanedNumber)
            userDefaults.set(numbers, forKey: blockedNumbersKey)
            userDefaults.synchronize()
        }
    }

    func removeBlockedNumber(_ phoneNumber: String) {
        var numbers = getBlockedNumbers()
        let cleanedNumber = phoneNumber.replacingOccurrences(
            of: "[^0-9+]", with: "", options: .regularExpression)

        numbers.removeAll { $0 == cleanedNumber }
        userDefaults.set(numbers, forKey: blockedNumbersKey)
        userDefaults.synchronize()
    }

    func isNumberBlocked(_ phoneNumber: String) -> Bool {
        let cleanedNumber = phoneNumber.replacingOccurrences(
            of: "[^0-9+]", with: "", options: .regularExpression)
        return getBlockedNumbers().contains(cleanedNumber)
    }

    // MARK: - Allowed Numbers Management (Whitelist)

    func getAllowedNumbers() -> [String] {
        return userDefaults.stringArray(forKey: allowedNumbersKey) ?? []
    }

    func addAllowedNumber(_ value: String) {
        var numbers = getAllowedNumbers()

        // Değer zaten listede mi kontrol et (case-insensitive)
        let exists = numbers.contains { existingValue in
            existingValue.uppercased() == value.uppercased()
        }

        if !exists {
            numbers.append(value)
            userDefaults.set(numbers, forKey: allowedNumbersKey)
            userDefaults.synchronize()
        }
    }

    func removeAllowedNumber(_ value: String) {
        var numbers = getAllowedNumbers()

        // Case-insensitive silme
        numbers.removeAll { existingValue in
            existingValue.uppercased() == value.uppercased()
        }

        userDefaults.set(numbers, forKey: allowedNumbersKey)
        userDefaults.synchronize()
    }

    func isNumberAllowed(_ value: String) -> Bool {
        let allowedNumbers = getAllowedNumbers()

        // Case-insensitive kontrol
        return allowedNumbers.contains { existingValue in
            existingValue.uppercased() == value.uppercased()
        }
    }

    // MARK: - Settings

    func isFilterEnabled() -> Bool {
        // Eğer key hiç ayarlanmamışsa (ilk açılış), false döndür
        if userDefaults.object(forKey: "filterEnabled") == nil {
            return false
        }
        return userDefaults.bool(forKey: "filterEnabled")
    }

    func setFilterEnabled(_ enabled: Bool) {
        userDefaults.set(enabled, forKey: "filterEnabled")
        userDefaults.synchronize()
    }

    // MARK: - Filter Rules Management

    func getFilterRules() -> [[String: String]] {
        return userDefaults.array(forKey: filterRulesKey) as? [[String: String]] ?? []
    }

    func addFilterRule(keyword: String, category: String) {
        var rules = getFilterRules()
        let newRule: [String: String] = [
            "keyword": keyword.lowercased(),
            "category": category,
        ]
        rules.append(newRule)
        userDefaults.set(rules, forKey: filterRulesKey)
        userDefaults.synchronize()
    }

    func removeFilterRule(keyword: String) {
        var rules = getFilterRules()
        rules.removeAll { rule in
            rule["keyword"]?.lowercased() == keyword.lowercased()
        }
        userDefaults.set(rules, forKey: filterRulesKey)
        userDefaults.synchronize()
    }

    func getCategoryForMessage(_ messageBody: String) -> String? {
        let rules = getFilterRules()
        let lowercasedMessage = messageBody.lowercased()

        // Mesaj içinde anahtar kelime var mı kontrol et
        for rule in rules {
            if let keyword = rule["keyword"],
                let category = rule["category"],
                lowercasedMessage.contains(keyword.lowercased())
            {
                return category
            }
        }

        return nil
    }
}
