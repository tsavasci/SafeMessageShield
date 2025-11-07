//
//  CallDirectoryHandler.swift
//  CallDirectoryExtension
//
//  Created by Tamer Savaşcı on 6.11.2025.
//

import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        NSLog("🛡️ SafeMessageShield: Call Directory extension başlatıldı")
        NSLog("🛡️ SafeMessageShield: Incremental request: \(context.isIncremental)")

        // Debug: App Group sayaçlarını güncelle
        if let defaults = UserDefaults(suiteName: "group.tsavasci.SafeMessageShield") {
            let count = defaults.integer(forKey: "callBlockCount")
            defaults.set(count + 1, forKey: "callBlockCount")
            defaults.set(Date().timeIntervalSince1970, forKey: "callDirectoryLastLoadAt")
        } else {
            NSLog("🛡️ SafeMessageShield: ⚠️ App Group erişimi yok (beginRequest)")
        }

        // Her zaman tüm numaraları yükle (incremental update şimdilik desteklenmez)
        addAllBlockingPhoneNumbers(to: context)

        context.completeRequest()
        NSLog("🛡️ SafeMessageShield: Call Directory request tamamlandı")
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        NSLog("🛡️ SafeMessageShield: addAllBlockingPhoneNumbers çağrıldı")
        
        // App Group'tan engellenen numaraları al
        guard let sharedDefaults = UserDefaults(suiteName: "group.tsavasci.SafeMessageShield") else {
            NSLog("🛡️ SafeMessageShield: ❌ App Group'a erişilemedi!")
            return
        }
        
        let blockedNumbers = sharedDefaults.array(forKey: "blockedNumbers") as? [String] ?? []
        NSLog("🛡️ SafeMessageShield: Engellenen numara sayısı: \(blockedNumbers.count)")
        NSLog("🛡️ SafeMessageShield: Engellenen numaralar: \(blockedNumbers)")
        
        // Numaraları CXCallDirectoryPhoneNumber'a çevir ve sırala
        var phoneNumbers: [CXCallDirectoryPhoneNumber] = []
        
        for number in blockedNumbers {
            // Sadece rakamları al
            var cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            // Türk numarası formatı dönüştürme
            // 0505... -> 90505...
            // +90505... -> 90505...
            // 905... -> 905... (değişmez)
            if cleanNumber.hasPrefix("0") && cleanNumber.count == 11 {
                // Türk numarası 0 ile başlıyorsa, 0'ı at ve başına 90 ekle
                cleanNumber = "90" + cleanNumber.dropFirst()
                NSLog("🛡️ SafeMessageShield: Format dönüşümü: 0xxx -> 90xxx")
            }
            
            // CXCallDirectoryPhoneNumber'a çevir
            if let phoneNumber = CXCallDirectoryPhoneNumber(cleanNumber) {
                phoneNumbers.append(phoneNumber)
                NSLog("🛡️ SafeMessageShield: Numara ekleniyor: \(cleanNumber) -> \(phoneNumber)")
            } else {
                NSLog("🛡️ SafeMessageShield: ⚠️ Geçersiz numara: \(cleanNumber)")
            }
        }
        
        // Numaraları artan sırada sırala (CallKit requirement)
        phoneNumbers.sort()
        
        // Her numarayı blocking listesine ekle
        for phoneNumber in phoneNumbers {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
            NSLog("🛡️ SafeMessageShield: ✅ Blocking entry eklendi: \(phoneNumber)")
        }
        
        NSLog("🛡️ SafeMessageShield: Toplam \(phoneNumbers.count) numara blocking listesine eklendi")
    }

    private func addOrRemoveIncrementalBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Incremental update şimdilik kullanılmıyor
        NSLog("🛡️ SafeMessageShield: Incremental blocking update (şimdilik desteklenmiyor)")
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Identification şimdilik kullanılmıyor
        NSLog("🛡️ SafeMessageShield: Identification phone numbers (şimdilik desteklenmiyor)")
    }

    private func addOrRemoveIncrementalIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Incremental identification update şimdilik kullanılmıyor
        NSLog("🛡️ SafeMessageShield: Incremental identification update (şimdilik desteklenmiyor)")
    }

}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        NSLog("🛡️ SafeMessageShield: ❌ Call Directory request başarısız: \(error.localizedDescription)")
        NSLog("🛡️ SafeMessageShield: ❌ Error details: \(error)")
    }

}
