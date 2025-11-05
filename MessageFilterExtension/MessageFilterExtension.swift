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
        let response = ILMessageFilterCapabilitiesQueryResponse()

        // TODO: Update subActions from ILMessageFilterSubAction enum
        // response.transactionalSubActions = [...]
        // response.promotionalSubActions   = [...]

        completion(response)
    }

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        // First, check whether to filter using offline data (if possible).
        let (offlineAction, offlineSubAction) = self.offlineAction(for: queryRequest)

        switch offlineAction {
        case .allow, .junk, .promotion, .transaction:
            // Based on offline data, we know this message should either be Allowed, Filtered as Junk, Promotional or Transactional. Send response immediately.
            let response = ILMessageFilterQueryResponse()
            response.action = offlineAction
            response.subAction = offlineSubAction

            completion(response)

        case .none:
            // Based on offline data, we do not know whether this message should be Allowed or Filtered. Defer to network.
            // Note: Deferring requests to network requires the extension target's Info.plist to contain a key with a URL to use. See documentation for details.
            context.deferQueryRequestToNetwork() { (networkResponse, error) in
                let response = ILMessageFilterQueryResponse()
                response.action = .none
                response.subAction = .none

                if let networkResponse = networkResponse {
                    // If we received a network response, parse it to determine an action to return in our response.
                    (response.action, response.subAction) = self.networkAction(for: networkResponse)
                } else {
                    NSLog("Error deferring query request to network: \(String(describing: error))")
                }

                completion(response)
            }

        @unknown default:
            break
        }
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        guard let sender = queryRequest.sender else {
            return (.none, .none)
        }
        
        // App Group'tan engellenen numaraları al
        guard let userDefaults = UserDefaults(suiteName: kAppGroupIdentifier),
              let blockedNumbers = userDefaults.stringArray(forKey: "blockedNumbers") else {
            return (.none, .none)
        }
        
        // Gönderenin numarasını temizle
        let cleanedSender = sender.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        
        // Numara engellenmiş mi kontrol et
        if blockedNumbers.contains(where: { cleanedSender.contains($0) || $0.contains(cleanedSender) }) {
            NSLog("🛡️ SafeMessageShield: SMS filtrelendi - Gönderen: \(sender)")
            
            // İstatistiği güncelle
            incrementSMSFilterCount()
            
            return (.junk, .none)
        }
        
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
