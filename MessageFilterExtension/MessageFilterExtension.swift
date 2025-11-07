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
        
        let blockedNumbers = sharedDefaults.array(forKey: "blockedNumbers") as? [String] ?? []
        let cleanSender = sender.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
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
