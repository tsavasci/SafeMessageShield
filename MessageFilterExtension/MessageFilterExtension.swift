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
        let cleanSender = sender.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let senderUppercase = sender.uppercased()
        
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
        
        // 2. Blocklist kontrolü - Engellenenlerdeyse filtrele
        for blockedNumber in blockedNumbers {
            let cleanBlocked = blockedNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if cleanSender == cleanBlocked ||
               cleanSender.hasSuffix(cleanBlocked) ||
               cleanBlocked.hasSuffix(cleanSender) ||
               cleanSender.contains(cleanBlocked) ||
               cleanBlocked.contains(cleanSender) {
                return (.junk, .none)
            }
        }
        
        return (.none, .none)
    }

    private func networkAction(for networkResponse: ILNetworkResponse) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        return (.none, .none)
    }
}
