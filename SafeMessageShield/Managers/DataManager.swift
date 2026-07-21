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
    private let numberFilterRulesKey = "numberFilterRules"
    private let allowedNumbersNormalizedKey = "allowedNumbersNormalized"
    private let allowedSenderNamesNormalizedKey = "allowedSenderNamesNormalized"
    private let blockedNumbersNormalizedKey = "blockedNumbersNormalized"
    private let blockedSenderNamesNormalizedKey = "blockedSenderNamesNormalized"
    private let lastAppGroupSyncDateKey = "lastAppGroupSyncDate"

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
            // Telefon numaralarını bütün bileşenlerde aynı rakam-only biçimde sakla.
            valueToProcess = PhoneNumberNormalizer.normalize(trimmedInput)
        }
        
        return valueToProcess.isEmpty ? nil : valueToProcess
    }
    
    private func isSenderName(_ input: String) -> Bool {
        return input.rangeOfCharacter(from: .letters) != nil
    }

    private func valuesAreEquivalent(_ lhs: String, _ rhs: String) -> Bool {
        guard let left = processNumberOrSender(lhs), let right = processNumberOrSender(rhs) else {
            return false
        }
        return left.caseInsensitiveCompare(right) == .orderedSame
    }
    
    private func updateAllowedNormalizedLists(from values: [String]) {
        var numbers: [String] = []
        var names: [String] = []
        
        for value in values {
            if isSenderName(value) {
                let cleaned = value.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                if !cleaned.isEmpty { names.append(cleaned) }
            } else {
                let cleaned = PhoneNumberNormalizer.normalize(value)
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
                let cleaned = PhoneNumberNormalizer.normalize(value)
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
        if !numbers.contains(where: { valuesAreEquivalent($0, valueToBlock) }) {
            numbers.append(valueToBlock)
            userDefaults.set(numbers, forKey: blockedNumbersKey)
            updateBlockedNormalizedLists(from: numbers)
        }
    }

    /// SwiftData uyumlu ekleme: isteğe bağlı `ModelContext` verildiğinde
    /// SwiftData modeline de ekler ve UserDefaults'u günceller.
    func addBlockedNumber(_ phoneNumber: String, reason: String? = nil, modelContext: ModelContext?) {
        guard let valueToBlock = processNumberOrSender(phoneNumber) else { return }

        // SwiftData tarafına ekle (eğer context verilmişse)
        if let context = modelContext {
            let descriptor = FetchDescriptor<BlockedNumber>(predicate: #Predicate { $0.phoneNumber == valueToBlock })
            do {
                if try context.fetchCount(descriptor) == 0 {
                    let blocked = BlockedNumber(phoneNumber: valueToBlock, addedAt: Date(), reason: normalizedReason(reason))
                    context.insert(blocked)
                }
            } catch {
                print("Failed to fetch count for blocked number: \(error)")
            }
        }

        // UserDefaults güncellemesini tek yerden yap
        var numbers = getBlockedNumbers()
        if !numbers.contains(where: { valuesAreEquivalent($0, valueToBlock) }) {
            numbers.append(valueToBlock)
            userDefaults.set(numbers, forKey: blockedNumbersKey)
            updateBlockedNormalizedLists(from: numbers)
        }
    }

    func removeBlockedNumber(_ phoneNumber: String) {
        guard let valueToRemove = processNumberOrSender(phoneNumber) else { return }
        var numbers = getBlockedNumbers()
        numbers.removeAll { valuesAreEquivalent($0, valueToRemove) }
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
        numbers.removeAll { valuesAreEquivalent($0, valueToRemove) }
        userDefaults.set(numbers, forKey: blockedNumbersKey)
        updateBlockedNormalizedLists(from: numbers)

        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<BlockedNumber>(
            predicate: #Predicate { $0.phoneNumber == valueToRemove }
        )
        do {
            for model in try context.fetch(descriptor) {
                context.delete(model)
            }
        } catch {
            print("Failed to remove blocked number from SwiftData: \(error)")
        }
    }

    func isNumberBlocked(_ phoneNumber: String) -> Bool {
        guard let valueToCompare = processNumberOrSender(phoneNumber) else { return false }
        return getBlockedNumbers().contains { valuesAreEquivalent($0, valueToCompare) }
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
            valuesAreEquivalent(existingValue, valueToAllow)
        }

        if !exists {
            numbers.append(valueToAllow)
            userDefaults.set(numbers, forKey: allowedNumbersKey)
            updateAllowedNormalizedLists(from: numbers)
        }
    }

    func addAllowedNumber(_ value: String, reason: String? = nil, modelContext: ModelContext?) {
        guard let valueToAllow = processNumberOrSender(value) else { return }

        if let context = modelContext {
            let descriptor = FetchDescriptor<AllowedNumber>(predicate: #Predicate { $0.phoneNumber == valueToAllow })
            do {
                if try context.fetchCount(descriptor) == 0 {
                    let allowed = AllowedNumber(phoneNumber: valueToAllow, addedAt: Date(), reason: normalizedReason(reason))
                    context.insert(allowed)
                }
            } catch {
                print("Failed to fetch count for allowed number: \(error)")
            }
        }

        var numbers = getAllowedNumbers()

        let exists = numbers.contains { existingValue in
            valuesAreEquivalent(existingValue, valueToAllow)
        }

        if !exists {
            numbers.append(valueToAllow)
            userDefaults.set(numbers, forKey: allowedNumbersKey)
            updateAllowedNormalizedLists(from: numbers)
        }
    }

    func removeAllowedNumber(_ value: String) {
        guard let valueToRemove = processNumberOrSender(value) else { return }
        var numbers = getAllowedNumbers()

        // Case-insensitive silme
        numbers.removeAll { existingValue in
            valuesAreEquivalent(existingValue, valueToRemove)
        }

        userDefaults.set(numbers, forKey: allowedNumbersKey)
        updateAllowedNormalizedLists(from: numbers)
    }

    func removeAllowedNumber(_ value: String, modelContext: ModelContext?) {
        guard let valueToRemove = processNumberOrSender(value) else { return }
        removeAllowedNumber(valueToRemove)

        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<AllowedNumber>(
            predicate: #Predicate { $0.phoneNumber == valueToRemove }
        )
        do {
            for model in try context.fetch(descriptor) {
                context.delete(model)
            }
        } catch {
            print("Failed to remove allowed number from SwiftData: \(error)")
        }
    }

    func isNumberAllowed(_ value: String) -> Bool {
        guard let valueToCompare = processNumberOrSender(value) else { return false }
        let allowedNumbers = getAllowedNumbers()

        // Case-insensitive kontrol
        return allowedNumbers.contains { existingValue in
            valuesAreEquivalent(existingValue, valueToCompare)
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

    func smsJunkCount() -> Int {
        userDefaults.integer(forKey: "smsJunkCount")
    }

    func smsCategorizedCount() -> Int {
        userDefaults.integer(forKey: "smsCategorizedCount")
    }

    func lastSMSFilterDate() -> Date? {
        userDefaults.object(forKey: "lastSMSFilterDate") as? Date
    }

    func lastJunkSender() -> String? {
        userDefaults.string(forKey: "lastJunkSender")
    }

    func lastAppGroupSyncDate() -> Date? {
        userDefaults.object(forKey: lastAppGroupSyncDateKey) as? Date
    }

    func recordCallDirectoryReloadError(_ error: Error?) {
        if let error {
            userDefaults.set(error.localizedDescription, forKey: "lastCallDirectoryError")
        } else {
            userDefaults.removeObject(forKey: "lastCallDirectoryError")
            userDefaults.set(Date(), forKey: "lastCallDirectoryReloadDate")
        }
    }

    func lastCallDirectoryError() -> String? {
        userDefaults.string(forKey: "lastCallDirectoryError")
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
        let allowedStrings = allowed.compactMap { model -> String? in
            guard let normalized = processNumberOrSender(model.phoneNumber) else { return nil }
            if model.phoneNumber != normalized { model.phoneNumber = normalized }
            return normalized
        }
        userDefaults.set(allowedStrings, forKey: allowedNumbersKey)
        updateAllowedNormalizedLists(from: allowedStrings)

        // Blocked numbers as plain strings
        let blockedStrings = blocked.compactMap { model -> String? in
            guard let normalized = processNumberOrSender(model.phoneNumber) else { return nil }
            if model.phoneNumber != normalized { model.phoneNumber = normalized }
            return normalized
        }
        userDefaults.set(blockedStrings, forKey: blockedNumbersKey)
        updateBlockedNormalizedLists(from: blockedStrings)

        // Filter rules as dictionaries
        let rules = filterRules.map { rule in
            ["keyword": rule.keyword.lowercased(), "category": rule.category]
        }
        userDefaults.set(rules, forKey: filterRulesKey)
        
        // Number filter rules as dictionaries
        syncNumberFilterRules(from: numberRules)
        userDefaults.set(Date(), forKey: lastAppGroupSyncDateKey)
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
        return userDefaults.array(forKey: numberFilterRulesKey) as? [[String: String]] ?? []
    }

    func syncNumberFilterRules(from numberRules: [NumberFilterRule]) {
        let numberFilterRulesDict = numberRules.map { rule in
            [rule.ruleType: rule.value]
        }
        userDefaults.set(numberFilterRulesDict, forKey: numberFilterRulesKey)
    }

    func addNumberFilterRule(ruleType: String, value: String, modelContext: ModelContext?) {
        let cleanedValue = PhoneNumberNormalizer.normalize(value)
        guard ["prefix", "suffix", "contains"].contains(ruleType), cleanedValue.count >= 3 else {
            return
        }

        var rules = getNumberFilterRules()
        let exists = rules.contains { $0[ruleType] == cleanedValue }
        guard !exists else { return }

        if let context = modelContext {
            context.insert(NumberFilterRule(ruleType: ruleType, value: cleanedValue))
        }

        rules.append([ruleType: cleanedValue])
        userDefaults.set(rules, forKey: "numberFilterRules")
    }

    func removeNumberFilterRule(ruleType: String, value: String) {
        let cleanedValue = PhoneNumberNormalizer.normalize(value)
        var rules = getNumberFilterRules()
        rules.removeAll { $0[ruleType] == cleanedValue }
        userDefaults.set(rules, forKey: "numberFilterRules")
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

    private func normalizedReason(_ reason: String?) -> String? {
        let cleaned = reason?.trimmingCharacters(in: .whitespacesAndNewlines)
        return cleaned?.isEmpty == false ? cleaned : nil
    }
}
