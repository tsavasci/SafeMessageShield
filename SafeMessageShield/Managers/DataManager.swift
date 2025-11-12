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
    private let smsJunkCountKey = "smsJunkCount"
    private let smsCategorizedCountKey = "smsCategorizedCount"
    private let callBlockCountKey = "callBlockCount"
    private let lastSMSFilterDateKey = "lastSMSFilterDate"
    private let lastCallBlockDateKey = "lastCallBlockDate"
    private let installDateKey = "installDate"
    
    private init() {
        guard let defaults = UserDefaults(suiteName: kAppGroupIdentifier) else {
            fatalError("App Group oluşturulamadı. Capabilities ayarlarını kontrol edin.")
        }
        self.userDefaults = defaults
        
        // İlk yükleme tarihini kaydet
        if userDefaults.object(forKey: installDateKey) == nil {
            userDefaults.set(Date(), forKey: installDateKey)
        }
    }
    
    // MARK: - Blocked Numbers Management
    
    func getBlockedNumbers() -> [String] {
        return userDefaults.stringArray(forKey: blockedNumbersKey) ?? []
    }
    
    func addBlockedNumber(_ phoneNumber: String) {
        var numbers = getBlockedNumbers()
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        
        if !numbers.contains(cleanedNumber) {
            numbers.append(cleanedNumber)
            userDefaults.set(numbers, forKey: blockedNumbersKey)
            userDefaults.synchronize()
        }
    }
    
    func removeBlockedNumber(_ phoneNumber: String) {
        var numbers = getBlockedNumbers()
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        
        numbers.removeAll { $0 == cleanedNumber }
        userDefaults.set(numbers, forKey: blockedNumbersKey)
        userDefaults.synchronize()
    }
    
    func isNumberBlocked(_ phoneNumber: String) -> Bool {
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
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
            "category": category
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
               lowercasedMessage.contains(keyword.lowercased()) {
                return category
            }
        }
        
        return nil
    }
    
    // MARK: - Statistics
    
    /// Junk'a gönderilen SMS sayacını artır
    func incrementSMSJunkCount() {
        let currentCount = userDefaults.integer(forKey: smsJunkCountKey)
        userDefaults.set(currentCount + 1, forKey: smsJunkCountKey)
        userDefaults.set(Date(), forKey: lastSMSFilterDateKey)
        userDefaults.synchronize()
    }
    
    /// Kategorize edilen SMS sayacını artır
    func incrementSMSCategorizedCount() {
        let currentCount = userDefaults.integer(forKey: smsCategorizedCountKey)
        userDefaults.set(currentCount + 1, forKey: smsCategorizedCountKey)
        userDefaults.set(Date(), forKey: lastSMSFilterDateKey)
        userDefaults.synchronize()
    }
    
    /// Arama engelleme sayacını artır (CallDirectoryExtension tarafından çağrılır)
    func incrementCallBlockCount() {
        let currentCount = userDefaults.integer(forKey: callBlockCountKey)
        userDefaults.set(currentCount + 1, forKey: callBlockCountKey)
        userDefaults.set(Date(), forKey: lastCallBlockDateKey)
        userDefaults.synchronize()
    }
    
    /// Toplam SMS filtreleme sayısı (Junk + Kategorize)
    func getTotalSMSFilterCount() -> Int {
        let junkCount = userDefaults.integer(forKey: smsJunkCountKey)
        let categorizedCount = userDefaults.integer(forKey: smsCategorizedCountKey)
        return junkCount + categorizedCount
    }
    
    /// Junk'a gönderilen SMS sayısı
    func getSMSJunkCount() -> Int {
        return userDefaults.integer(forKey: smsJunkCountKey)
    }
    
    /// Kategorize edilen SMS sayısı
    func getSMSCategorizedCount() -> Int {
        return userDefaults.integer(forKey: smsCategorizedCountKey)
    }
    
    /// Toplam arama engelleme sayısı
    func getTotalCallBlockCount() -> Int {
        return userDefaults.integer(forKey: callBlockCountKey)
    }
    
    /// Son SMS filtreleme tarihi
    func getLastSMSFilterDate() -> Date? {
        return userDefaults.object(forKey: lastSMSFilterDateKey) as? Date
    }
    
    /// Son arama engelleme tarihi
    func getLastCallBlockDate() -> Date? {
        return userDefaults.object(forKey: lastCallBlockDateKey) as? Date
    }
    
    /// Uygulamanın yüklenme tarihi
    func getInstallDate() -> Date? {
        return userDefaults.object(forKey: installDateKey) as? Date
    }
    
    /// Aktif gün sayısı
    func getActiveDays() -> Int {
        guard let installDate = getInstallDate() else { return 0 }
        let days = Calendar.current.dateComponents([.day], from: installDate, to: Date()).day ?? 0
        return max(days, 0)
    }
    
    /// İstatistikleri sıfırla (Sadece sayaçları sıfırlar, engellenen numaraları silmez)
    func resetStatistics() {
        userDefaults.removeObject(forKey: smsJunkCountKey)
        userDefaults.removeObject(forKey: smsCategorizedCountKey)
        userDefaults.removeObject(forKey: callBlockCountKey)
        userDefaults.removeObject(forKey: lastSMSFilterDateKey)
        userDefaults.removeObject(forKey: lastCallBlockDateKey)
        userDefaults.synchronize()
    }
}
