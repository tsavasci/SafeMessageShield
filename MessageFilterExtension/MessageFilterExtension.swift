//
//  MessageFilterExtension.swift
//  MessageFilterExtension
//
//  Created by Tamer Savaşcı on 6.11.2025.
//

import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling {
    func handle(_ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void) {
        NSLog("🛡️ SafeMessageShield: Capabilities query çağrıldı")
        
        let response = ILMessageFilterCapabilitiesQueryResponse()
        
        // Tüm sub-action'ları desteklediğimizi belirt
        response.transactionalSubActions = [.transactionalFinance, .transactionalOrders, .transactionalReminders, .transactionalHealth, .transactionalWeather, .transactionalCarrier, .transactionalRewards, .transactionalPublicServices, .transactionalOthers]
        response.promotionalSubActions = [.promotionalOffers, .promotionalCoupons, .promotionalOthers]

        completion(response)
    }

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        NSLog("🛡️ SafeMessageShield: SMS FİLTRE QUERY ÇAĞRILDI!")
        
        // Gelen mesajın bilgilerini logla
        let sender = queryRequest.sender ?? "bilinmeyen"
        let messageBody = queryRequest.messageBody ?? ""
        
        NSLog("🛡️ SafeMessageShield: Gönderici: \(sender)")
        NSLog("🛡️ SafeMessageShield: Mesaj gövdesi: \(messageBody)")

        // Debug: App Group sayaçlarını güncelle (her çağrıda 1 artır)
        if let defaults = UserDefaults(suiteName: "group.tsavasci.SafeMessageShield") {
            let count = defaults.integer(forKey: "smsFilterCount")
            defaults.set(count + 1, forKey: "smsFilterCount")
            defaults.set(Date().timeIntervalSince1970, forKey: "smsFilterLastHandleAt")
        } else {
            NSLog("🛡️ SafeMessageShield: ⚠️ App Group erişimi yok (handle)")
        }
        
        // Offline action'ı kontrol et
        let (offlineAction, offlineSubAction) = self.offlineAction(for: queryRequest)
        
        NSLog("🛡️ SafeMessageShield: Karar: \(offlineAction.rawValue)")

        let response = ILMessageFilterQueryResponse()
        response.action = offlineAction
        response.subAction = offlineSubAction

        completion(response)
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        NSLog("🛡️ SafeMessageShield: offlineAction fonksiyonu çağrıldı")
        
        // App Group'tan engellenen numaraları al
        guard let sharedDefaults = UserDefaults(suiteName: "group.tsavasci.SafeMessageShield") else {
            NSLog("🛡️ SafeMessageShield: ❌ App Group'a erişilemedi!")
            return (.none, .none)
        }
        
        let blockedNumbers = sharedDefaults.array(forKey: "blockedNumbers") as? [String] ?? []
        NSLog("🛡️ SafeMessageShield: Engellenen numara sayısı: \(blockedNumbers.count)")
        NSLog("🛡️ SafeMessageShield: Engellenen numaralar: \(blockedNumbers)")
        
        guard let sender = queryRequest.sender else {
            NSLog("🛡️ SafeMessageShield: ⚠️ Gönderici bilgisi yok")
            return (.none, .none)
        }
        
        // Gönderen numarayı temizle (sadece rakamlar)
        let cleanSender = sender.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        NSLog("🛡️ SafeMessageShield: Temizlenmiş gönderici: \(cleanSender)")
        
        // Engellenen numaralarla karşılaştır
        for blockedNumber in blockedNumbers {
            let cleanBlocked = blockedNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            NSLog("🛡️ SafeMessageShield: Karşılaştırılıyor - Temizlenmiş engelli: \(cleanBlocked)")
            
            // Çeşitli eşleşme yöntemleri dene
            if cleanSender == cleanBlocked {
                NSLog("🛡️ SafeMessageShield: ✅ TAM EŞLEŞME BULUNDU - Mesaj JUNK olarak işaretlenecek")
                
                // İstatistikleri güncelle
                let currentCount = sharedDefaults.integer(forKey: "smsFilterCount")
                sharedDefaults.set(currentCount + 1, forKey: "smsFilterCount")
                
                return (.junk, .none)
            } else if cleanSender.hasSuffix(cleanBlocked) || cleanBlocked.hasSuffix(cleanSender) {
                NSLog("🛡️ SafeMessageShield: ✅ SON EK EŞLEŞME BULUNDU - Mesaj JUNK olarak işaretlenecek")
                
                // İstatistikleri güncelle
                let currentCount = sharedDefaults.integer(forKey: "smsFilterCount")
                sharedDefaults.set(currentCount + 1, forKey: "smsFilterCount")
                
                return (.junk, .none)
            } else if cleanSender.contains(cleanBlocked) || cleanBlocked.contains(cleanSender) {
                NSLog("🛡️ SafeMessageShield: ✅ KISMI EŞLEŞME BULUNDU - Mesaj JUNK olarak işaretlenecek")
                
                // İstatistikleri güncelle
                let currentCount = sharedDefaults.integer(forKey: "smsFilterCount")
                sharedDefaults.set(currentCount + 1, forKey: "smsFilterCount")
                
                return (.junk, .none)
            }
        }
        
        NSLog("🛡️ SafeMessageShield: ℹ️ Eşleşme bulunamadı - Mesaj izin verilecek")
        return (.none, .none)
    }

    private func networkAction(for networkResponse: ILNetworkResponse) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        // Network deferral kullanmıyoruz
        NSLog("🛡️ SafeMessageShield: networkAction çağrıldı (kullanılmıyor)")
        return (.none, .none)
    }

}
