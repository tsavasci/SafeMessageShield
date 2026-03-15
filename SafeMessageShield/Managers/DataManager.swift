//
//  DataManager.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import Foundation
import SwiftData

/// App Group ID - Ana uygulama ve extension'lar arasında veri paylaşımı için
let kAppGroupIdentifier = "group.tsavasci.SafeMessageShield"

class DataManager {
    static let shared = DataManager()

    private let userDefaults: UserDefaults
    private let blockedNumbersKey = "blockedNumbers"
    private let allowedNumbersKey = "allowedNumbers"
    private let filterRulesKey = "filterRules"
    private let allowedNumbersNormalizedKey = "allowedNumbersNormalized"
    private let allowedSenderNamesNormalizedKey = "allowedSenderNamesNormalized"
    private let blockedNumbersNormalizedKey = "blockedNumbersNormalized"
    private let blockedSenderNamesNormalizedKey = "blockedSenderNamesNormalized"

    private init() {
        guard let defaults = UserDefaults(suiteName: kAppGroupIdentifier) else {
            fatalError("App Group oluşturulamadı. Capabilities ayarlarını kontrol edin.")
        }
        self.userDefaults = defaults
    }

    // MARK: - Blocked Numbers Management

    private func processNumberOrSender(_ input: String) -> String? {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return nil }
        
        let valueToProcess: String
        // Giriş harf içeriyorsa, metin olarak kabul et (örn: VODAFONE)
        if trimmedInput.rangeOfCharacter(from: .letters) != nil {
            valueToProcess = trimmedInput.uppercased()
        } else {
            // Harf içermiyorsa, telefon numarası olarak kabul et ve temizle
            valueToProcess = trimmedInput.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        }
        
        return valueToProcess.isEmpty ? nil : valueToProcess
    }
    
    private func isSenderName(_ input: String) -> Bool {
        return input.rangeOfCharacter(from: .letters) != nil
    }
    
    private func digitsOnly(_ input: String) -> String {
        return input.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
    }
    
    private func updateAllowedNormalizedLists(from values: [String]) {
        var numbers: [String] = []
        var names: [String] = []
        
        for value in values {
            if isSenderName(value) {
                let cleaned = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                if !cleaned.isEmpty { names.append(cleaned) }
            } else {
                let cleaned = digitsOnly(value)
                if !cleaned.isEmpty { numbers.append(cleaned) }
            }
        }
        
        userDefaults.set(numbers, forKey: allowedNumbersNormalizedKey)
        userDefaults.set(names, forKey: allowedSenderNamesNormalizedKey)
    }
    
    private func updateBlockedNormalizedLists(from values: [String]) {
        var numbers: [String] = []
        var names: [String] = []
        
        for value in values {
            if isSenderName(value) {
                let cleaned = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                if !cleaned.isEmpty { names.append(cleaned) }
            } else {
                let cleaned = digitsOnly(value)
                if !cleaned.isEmpty { numbers.append(cleaned) }
            }
        }
        
        userDefaults.set(numbers, forKey: blockedNumbersNormalizedKey)
        userDefaults.set(names, forKey: blockedSenderNamesNormalizedKey)
    }

    func getBlockedNumbers() -> [String] {
        return userDefaults.stringArray(forKey: blockedNumbersKey) ?? []
    }

    func addBlockedNumber(_ phoneNumber: String) {
        guard let valueToBlock = processNumberOrSender(phoneNumber) else { return }
        var numbers = getBlockedNumbers()
        if !numbers.contains(where: { $0.caseInsensitiveCompare(valueToBlock) == .orderedSame }) {
            numbers.append(valueToBlock)
            userDefaults.set(numbers, forKey: blockedNumbersKey)
            updateBlockedNormalizedLists(from: numbers)
        }
    }

    /// SwiftData uyumlu ekleme: isteğe bağlı `ModelContext` verildiğinde
    /// SwiftData modeline de ekler ve UserDefaults'u günceller.
    func addBlockedNumber(_ phoneNumber: String, modelContext: ModelContext?) {
        guard let valueToBlock = processNumberOrSender(phoneNumber) else { return }

        // SwiftData tarafına ekle (eğer context verilmişse)
        if let context = modelContext {
            let descriptor = FetchDescriptor<BlockedNumber>(predicate: #Predicate { $0.phoneNumber == valueToBlock })
            do {
                if try context.fetchCount(descriptor) == 0 {
                    let blocked = BlockedNumber(phoneNumber: valueToBlock, addedAt: Date(), reason: nil)
                    context.insert(blocked)
                }
            } catch {
                print("Failed to fetch count for blocked number: \(error)")
            }
        }

        // UserDefaults güncellemesini tek yerden yap
        var numbers = getBlockedNumbers()
        if !numbers.contains(where: { $0.caseInsensitiveCompare(valueToBlock) == .orderedSame }) {
            numbers.append(valueToBlock)
            userDefaults.set(numbers, forKey: blockedNumbersKey)
            updateBlockedNormalizedLists(from: numbers)
        }
    }

    func removeBlockedNumber(_ phoneNumber: String) {
        guard let valueToRemove = processNumberOrSender(phoneNumber) else { return }
        var numbers = getBlockedNumbers()
        numbers.removeAll { $0.caseInsensitiveCompare(valueToRemove) == .orderedSame }
        userDefaults.set(numbers, forKey: blockedNumbersKey)
        updateBlockedNormalizedLists(from: numbers)
    }

    /// SwiftData uyumlu silme: isteğe bağlı `ModelContext` verilirse
    /// sadece UserDefaults güncellemesi değil, aynı zamanda SwiftData
    /// içindeki modeli silmek geliştirici tarafından yapılabilir.
    func removeBlockedNumber(_ phoneNumber: String, modelContext: ModelContext?) {
        guard let valueToRemove = processNumberOrSender(phoneNumber) else { return }

        // UserDefaults güncelle
        var numbers = getBlockedNumbers()
        numbers.removeAll { $0.caseInsensitiveCompare(valueToRemove) == .orderedSame }
        userDefaults.set(numbers, forKey: blockedNumbersKey)
        updateBlockedNormalizedLists(from: numbers)
    }

    func isNumberBlocked(_ phoneNumber: String) -> Bool {
        guard let valueToCompare = processNumberOrSender(phoneNumber) else { return false }
        return getBlockedNumbers().contains { $0.caseInsensitiveCompare(valueToCompare) == .orderedSame }
    }

    // MARK: - Allowed Numbers Management (Whitelist)

    func getAllowedNumbers() -> [String] {
        return userDefaults.stringArray(forKey: allowedNumbersKey) ?? []
    }

    func addAllowedNumber(_ value: String) {
        guard let valueToAllow = processNumberOrSender(value) else { return }
        var numbers = getAllowedNumbers()

        // Değer zaten listede mi kontrol et (case-insensitive)
        let exists = numbers.contains { existingValue in
            existingValue.uppercased() == valueToAllow.uppercased()
        }

        if !exists {
            numbers.append(valueToAllow)
            userDefaults.set(numbers, forKey: allowedNumbersKey)
            updateAllowedNormalizedLists(from: numbers)
        }
    }

    func addAllowedNumber(_ value: String, modelContext: ModelContext?) {
        guard let valueToAllow = processNumberOrSender(value) else { return }
        var numbers = getAllowedNumbers()

        let exists = numbers.contains { existingValue in
            existingValue.uppercased() == valueToAllow.uppercased()
        }

        if !exists {
            numbers.append(valueToAllow)
            userDefaults.set(numbers, forKey: allowedNumbersKey)
            updateAllowedNormalizedLists(from: numbers)
        }

        // SwiftData tarafına ekleme gerekiyorsa UI katmanı yapmalıdır.
    }

    func removeAllowedNumber(_ value: String) {
        guard let valueToRemove = processNumberOrSender(value) else { return }
        var numbers = getAllowedNumbers()

        // Case-insensitive silme
        numbers.removeAll { existingValue in
            existingValue.uppercased() == valueToRemove.uppercased()
        }

        userDefaults.set(numbers, forKey: allowedNumbersKey)
        updateAllowedNormalizedLists(from: numbers)
    }

    func isNumberAllowed(_ value: String) -> Bool {
        guard let valueToCompare = processNumberOrSender(value) else { return false }
        let allowedNumbers = getAllowedNumbers()

        // Case-insensitive kontrol
        return allowedNumbers.contains { existingValue in
            existingValue.uppercased() == valueToCompare.uppercased()
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

    }

    // MARK: - Sync helpers

    /// Sync SwiftData model arrays into App Group UserDefaults so extensions can read them.
    func syncFromSwiftData(allowed: [AllowedNumber], blocked: [BlockedNumber], filterRules: [FilterRule], numberRules: [NumberFilterRule]) {
        // Allowed numbers as plain strings
        let allowedStrings = allowed.map { $0.phoneNumber }
        userDefaults.set(allowedStrings, forKey: allowedNumbersKey)
        updateAllowedNormalizedLists(from: allowedStrings)

        // Blocked numbers as plain strings
        let blockedStrings = blocked.map { $0.phoneNumber }
        userDefaults.set(blockedStrings, forKey: blockedNumbersKey)
        updateBlockedNormalizedLists(from: blockedStrings)

        // Filter rules as dictionaries
        let rules = filterRules.map { rule in
            ["keyword": rule.keyword.lowercased(), "category": rule.category]
        }
        userDefaults.set(rules, forKey: filterRulesKey)
        
        // Number filter rules as dictionaries
        let numberFilterRulesDict = numberRules.map { rule in
            [rule.ruleType: rule.value]
        }
        userDefaults.set(numberFilterRulesDict, forKey: "numberFilterRules")
    }

    /// SwiftData uyumlu filtre kuralı ekleme. Eğer `modelContext` verilirse
    /// SwiftData modeline de kaydeder; ayrıca UserDefaults'u günceller.
    func addFilterRule(keyword: String, category: String, modelContext: ModelContext?) {
        let cleanedKeyword = keyword.lowercased()

        // SwiftData'ya ekle
        if let context = modelContext {
            let rule = FilterRule(keyword: cleanedKeyword, category: category)
            context.insert(rule)
        }

        // UserDefaults güncelle
        var rules = getFilterRules()
        let newRule: [String: String] = ["keyword": cleanedKeyword, "category": category]
        rules.append(newRule)
        userDefaults.set(rules, forKey: filterRulesKey)
    }

    func removeFilterRule(keyword: String) {
        var rules = getFilterRules()
        rules.removeAll { rule in
            rule["keyword"]?.lowercased() == keyword.lowercased()
        }
        userDefaults.set(rules, forKey: filterRulesKey)

    }

    // MARK: - Number Filter Rules (prefix/suffix/contains)

    func getNumberFilterRules() -> [[String: String]] {
        return userDefaults.array(forKey: "numberFilterRules") as? [[String: String]] ?? []
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
