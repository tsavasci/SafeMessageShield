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
    private let smsFilterCountKey = "smsFilterCount"
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
    
    // MARK: - Statistics
    
    /// SMS filtreleme sayacını artır (MessageFilterExtension tarafından çağrılır)
    func incrementSMSFilterCount() {
        let currentCount = userDefaults.integer(forKey: smsFilterCountKey)
        userDefaults.set(currentCount + 1, forKey: smsFilterCountKey)
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
    
    /// Toplam SMS filtreleme sayısı
    func getTotalSMSFilterCount() -> Int {
        return userDefaults.integer(forKey: smsFilterCountKey)
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
    
    /// İstatistikleri sıfırla
    func resetStatistics() {
        userDefaults.removeObject(forKey: smsFilterCountKey)
        userDefaults.removeObject(forKey: callBlockCountKey)
        userDefaults.removeObject(forKey: lastSMSFilterDateKey)
        userDefaults.removeObject(forKey: lastCallBlockDateKey)
        userDefaults.synchronize()
    }
}
