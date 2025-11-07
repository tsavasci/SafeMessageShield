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
        let response = ILMessageFilterCapabilitiesQueryResponse()
        response.transactionalSubActions = [.transactionalFinance, .transactionalOrders, .transactionalReminders, .transactionalHealth, .transactionalWeather, .transactionalCarrier, .transactionalRewards, .transactionalPublicServices, .transactionalOthers]
        response.promotionalSubActions = [.promotionalOffers, .promotionalCoupons, .promotionalOthers]
        completion(response)
    }

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        let (offlineAction, offlineSubAction) = self.offlineAction(for: queryRequest)
        
        let response = ILMessageFilterQueryResponse()
        response.action = offlineAction
        response.subAction = offlineSubAction
        completion(response)
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        guard let sharedDefaults = UserDefaults(suiteName: "group.tsavasci.SafeMessageShield"),
              let sender = queryRequest.sender else {
            return (.none, .none)
        }
        
        let allowedNumbers = sharedDefaults.array(forKey: "allowedNumbers") as? [String] ?? []
        let blockedNumbers = sharedDefaults.array(forKey: "blockedNumbers") as? [String] ?? []
        let filterRules = sharedDefaults.array(forKey: "filterRules") as? [[String: String]] ?? []
        
        let cleanSender = sender.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let senderUppercase = sender.uppercased()
        
        // Mesaj içeriğini al (varsa)
        let messageBody = queryRequest.messageBody?.lowercased() ?? ""
        
        // 1. ÖNCELİK: Whitelist kontrolü - Güvenli numaralardaysa geçir
        for allowedEntry in allowedNumbers {
            let cleanAllowed = allowedEntry.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            // Eğer sadece harf içeriyorsa (isim), direkt karşılaştır
            if cleanAllowed.isEmpty {
                // Bu bir isim (örn: "ARASKARGO", "MİGROS")
                if senderUppercase.contains(allowedEntry) || allowedEntry.contains(senderUppercase) {
                    return (.none, .none) // Mesajı geçir
                }
            } else {
                // Bu bir numara, numara karşılaştırması yap
                if cleanSender == cleanAllowed ||
                   cleanSender.hasSuffix(cleanAllowed) ||
                   cleanAllowed.hasSuffix(cleanSender) ||
                   cleanSender.contains(cleanAllowed) ||
                   cleanAllowed.contains(cleanSender) {
                    return (.none, .none) // Mesajı geçir
                }
            }
        }
        
        // 2. Filtre Kuralları kontrolü - Mesaj içeriğine göre kategorize et
        if !messageBody.isEmpty {
            for rule in filterRules {
                if let keyword = rule["keyword"],
                   let category = rule["category"],
                   messageBody.contains(keyword.lowercased()) {
                    // Kategoriyi belirle ve mesajı filtrele
                    let subAction = getSubAction(for: category)
                    
                    // Kategorize edildi sayacını artır
                    sharedDefaults.set((sharedDefaults.integer(forKey: "smsCategorizedCount") + 1), forKey: "smsCategorizedCount")
                    sharedDefaults.set((sharedDefaults.integer(forKey: "smsFilterCount") + 1), forKey: "smsFilterCount")
                    sharedDefaults.set(Date(), forKey: "lastSMSFilterDate")
                    sharedDefaults.synchronize()
                    
                    // Transactional kategoriler için .transaction kullan
                    if category.hasPrefix("transactional") {
                        return (.transaction, subAction)
                    }
                    // Promotional kategoriler için .promotion kullan
                    else if category.hasPrefix("promotional") {
                        return (.promotion, subAction)
                    }
                }
            }
        }
        
        // 3. Blocklist kontrolü - Engellenenlerdeyse spam olarak işaretle
        for blockedNumber in blockedNumbers {
            let cleanBlocked = blockedNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if cleanSender == cleanBlocked ||
               cleanSender.hasSuffix(cleanBlocked) ||
               cleanBlocked.hasSuffix(cleanSender) ||
               cleanSender.contains(cleanBlocked) ||
               cleanBlocked.contains(cleanSender) {
                
                // Junk sayacını artır
                sharedDefaults.set((sharedDefaults.integer(forKey: "smsJunkCount") + 1), forKey: "smsJunkCount")
                sharedDefaults.set((sharedDefaults.integer(forKey: "smsFilterCount") + 1), forKey: "smsFilterCount")
                sharedDefaults.set(Date(), forKey: "lastSMSFilterDate")
                sharedDefaults.synchronize()
                
                return (.junk, .none)
            }
        }
        
        return (.none, .none)
    }
    
    // Kategori string'inden ILMessageFilterSubAction döndür
    private func getSubAction(for category: String) -> ILMessageFilterSubAction {
        switch category {
        // Transactional
        case "transactionalFinance":
            return .transactionalFinance
        case "transactionalOrders":
            return .transactionalOrders
        case "transactionalReminders":
            return .transactionalReminders
        case "transactionalHealth":
            return .transactionalHealth
        case "transactionalWeather":
            return .transactionalWeather
        case "transactionalCarrier":
            return .transactionalCarrier
        case "transactionalRewards":
            return .transactionalRewards
        case "transactionalPublicServices":
            return .transactionalPublicServices
        case "transactionalOthers":
            return .transactionalOthers
        // Promotional
        case "promotionalOffers":
            return .promotionalOffers
        case "promotionalCoupons":
            return .promotionalCoupons
        case "promotionalOthers":
            return .promotionalOthers
        default:
            return .none
        }
    }

    private func networkAction(for networkResponse: ILNetworkResponse) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        return (.none, .none)
    }
}
