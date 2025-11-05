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
}
