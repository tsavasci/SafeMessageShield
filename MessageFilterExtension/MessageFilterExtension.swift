//
//  MessageFilterExtension.swift
//  MessageFilterExtension
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import IdentityLookup
import Foundation

/// App Group ID - Ana uygulama ile veri paylaşımı için
let kAppGroupIdentifier = "group.tsavasci.SafeMessageShield"

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling {
    func handle(_ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void) {
        NSLog("🛡️ SafeMessageShield: Capabilities query çağrıldı")
        
        let response = ILMessageFilterCapabilitiesQueryResponse()
        
        // iOS'a tüm SMS'leri offline filtreleyebileceğimizi söyle
        // Bu olmadan iOS extension'ı çağırmayabilir
        response.transactionalSubActions = [
            ILMessageFilterSubAction.transactionalOthers
        ]
        response.promotionalSubActions = [
            ILMessageFilterSubAction.promotionalOthers
        ]

        NSLog("🛡️ SafeMessageShield: Capabilities yanıtı gönderildi - Transactional ve Promotional filtreleme aktif")
        completion(response)
    }

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        // =================== GEÇİCİ TEST KODU ===================
        // Bu kod, bilinmeyen her göndericiden gelen SMS'i JUNK olarak işaretler.
        // Sorunun data okumada mı yoksa extension'ın kendisinde mi olduğunu anlamak için.
        
        NSLog("🛡️ SafeMessageShield: 💣 HEPSİNİ ENGELLEME MODU AKTİF 💣")
        
        let response = ILMessageFilterQueryResponse()
        
        // Gönderen "kişiler" listesinde değilse, direkt JUNK yap.
        if queryRequest.sender != nil {
            response.action = .junk
            NSLog("🛡️ SafeMessageShield: ✅ JUNK olarak işaretlendi (Test Modu)")
        } else {
            response.action = .none
            NSLog("🛡️ SafeMessageShield: ℹ️ Gönderen nil, dokunulmadı (Test Modu)")
        }
        
        completion(response)
        
        /*
        // =================== ORİJİNAL KOD ===================
        NSLog("🛡️ SafeMessageShield: ============================================")
        NSLog("🛡️ SafeMessageShield: SMS FİLTRE QUERY ÇAĞRILDI!")
        NSLog("🛡️ SafeMessageShield: Gönderen: \(queryRequest.sender ?? "nil")")
        NSLog("🛡️ SafeMessageShield: Mesaj içeriği var mı: \(queryRequest.messageBody != nil)")
        NSLog("🛡️ SafeMessageShield: ============================================")
        // First, check whether to filter using offline data (if possible).
        let (offlineAction, offlineSubAction) = self.offlineAction(for: queryRequest)

        switch offlineAction {
        case .allow, .junk, .promotion, .transaction:
            // Based on offline data, we know this message should either be Allowed, Filtered as Junk, Promotional or Transactional. Send response immediately.
            let response = ILMessageFilterQueryResponse()
            response.action = offlineAction
            response.subAction = offlineSubAction
            
            NSLog("🛡️ SafeMessageShield: Yanıt gönderiliyor - Action: \(offlineAction.rawValue)")
            completion(response)

        case .none:
            // Offline veriye göre karar veremiyoruz, mesajı geçir
            let response = ILMessageFilterQueryResponse()
            response.action = .none
            response.subAction = .none
            
            NSLog("🛡️ SafeMessageShield: SMS geçirildi (engelli değil)")
            completion(response)

        @unknown default:
            let response = ILMessageFilterQueryResponse()
            response.action = .none
            response.subAction = .none
            completion(response)
        }
        */
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        guard let sender = queryRequest.sender else {
            NSLog("🛡️ SafeMessageShield: ⚠️ Gönderen bilgisi yok!")
            return (.none, .none)
        }
        
        // App Group'tan engellenen numaraları al
        guard let userDefaults = UserDefaults(suiteName: kAppGroupIdentifier),
              let blockedNumbers = userDefaults.stringArray(forKey: "blockedNumbers") else {
            NSLog("🛡️ SafeMessageShield: ❌ UserDefaults veya blockedNumbers alınamadı")
            return (.none, .none)
        }
        
        // Gönderenin numarasını temizle (sadece rakamlar ve +)
        let cleanedSender = sender.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        
        NSLog("🛡️ SafeMessageShield: 📨 SMS kontrol ediliyor")
        NSLog("🛡️ SafeMessageShield:    Gönderen (orijinal): \(sender)")
        NSLog("🛡️ SafeMessageShield:    Gönderen (temizlenmiş): \(cleanedSender)")
        NSLog("🛡️ SafeMessageShield:    Engelli numara sayısı: \(blockedNumbers.count)")
        
        // Eğer liste boşsa
        if blockedNumbers.isEmpty {
            NSLog("🛡️ SafeMessageShield: ℹ️ Engelli numara listesi boş")
            return (.none, .none)
        }
        
        // Her engelli numarayı kontrol et
        for (index, blockedNumber) in blockedNumbers.enumerated() {
            let cleanedBlocked = blockedNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
            
            NSLog("🛡️ SafeMessageShield:    [\(index+1)/\(blockedNumbers.count)] Kontrol: \(blockedNumber) → \(cleanedBlocked)")
            
            // Farklı eşleşme senaryoları
            let exactMatch = cleanedSender == cleanedBlocked
            let senderEndsWith = cleanedSender.hasSuffix(cleanedBlocked)
            let blockedEndsWith = cleanedBlocked.hasSuffix(cleanedSender)
            let senderContains = cleanedSender.contains(cleanedBlocked)
            let blockedContains = cleanedBlocked.contains(cleanedSender)
            
            if exactMatch {
                NSLog("🛡️ SafeMessageShield: ✅✅✅ SMS FİLTRELENDİ - TAM EŞLEŞME!")
                incrementSMSFilterCount()
                return (.junk, .none)
            } else if senderEndsWith {
                NSLog("🛡️ SafeMessageShield: ✅✅ SMS FİLTRELENDİ - Gönderen numarası engelli numara ile bitiyor")
                incrementSMSFilterCount()
                return (.junk, .none)
            } else if blockedEndsWith {
                NSLog("🛡️ SafeMessageShield: ✅ SMS FİLTRELENDİ - Engelli numara gönderen ile bitiyor")
                incrementSMSFilterCount()
                return (.junk, .none)
            } else if cleanedBlocked.count >= 7 && senderContains {
                NSLog("🛡️ SafeMessageShield: ✅ SMS FİLTRELENDİ - Gönderen içerisinde engelli numara var")
                incrementSMSFilterCount()
                return (.junk, .none)
            } else if cleanedSender.count >= 7 && blockedContains {
                NSLog("🛡️ SafeMessageShield: ✅ SMS FİLTRELENDİ - Engelli numara içerisinde gönderen var")
                incrementSMSFilterCount()
                return (.junk, .none)
            }
        }
        
        NSLog("🛡️ SafeMessageShield: ❌ SMS GEÇİRİLDİ - Gönderen engelli listesinde değil")
        return (.none, .none)
    }
    
    /// SMS filtreleme sayacını artır
    private func incrementSMSFilterCount() {
        guard let userDefaults = UserDefaults(suiteName: kAppGroupIdentifier) else { return }
        
        let currentCount = userDefaults.integer(forKey: "smsFilterCount")
        userDefaults.set(currentCount + 1, forKey: "smsFilterCount")
        userDefaults.set(Date(), forKey: "lastSMSFilterDate")
        userDefaults.synchronize()
        
        NSLog("🛡️ SafeMessageShield: Toplam SMS filtreleme: \(currentCount + 1)")
    }

    private func networkAction(for networkResponse: ILNetworkResponse) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        // TODO: Replace with logic to parse the HTTP response and data payload of `networkResponse` to return an action.
        return (.none, .none)
    }

}
