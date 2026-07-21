//
//  MessageFilterExtension.swift
//  MessageFilterExtension
//
//  Created by Tamer Savaşcı on 6.11.2025.
//

import Foundation
import IdentityLookup
import os.log

final class MessageFilterExtension: ILMessageFilterExtension {
    private let logger = Logger(
        subsystem: "tsavasci.SafeMessageShield.MessageFilter", category: "filtering")
    private let suiteName = "group.tsavasci.SafeMessageShield"
    private let allowedNumbersNormalizedKey = "allowedNumbersNormalized"
    private let allowedSenderNamesNormalizedKey = "allowedSenderNamesNormalized"
    private let blockedNumbersNormalizedKey = "blockedNumbersNormalized"
    private let blockedSenderNamesNormalizedKey = "blockedSenderNamesNormalized"

    private func incrementStatistic(key: String) {
        // Keep this function extremely fast and non-blocking.
        // Only try a lightweight UserDefaults write and return.
        guard let sharedDefaults = UserDefaults(suiteName: self.suiteName) else {
            logger.error("❌ Could not access shared UserDefaults (suiteName: \(self.suiteName))")
            return
        }

        let current = sharedDefaults.integer(forKey: key)
        let newCount = current + 1
        // Fast set; avoid `synchronize()` and any file I/O to prevent timeouts.
        sharedDefaults.set(newCount, forKey: key)
        sharedDefaults.set(Date(), forKey: "lastSMSFilterDate")

        logger.debug("Updated stat \(key)=\(newCount) via shared UserDefaults")
    }
}

extension MessageFilterExtension: ILMessageFilterQueryHandling,
    ILMessageFilterCapabilitiesQueryHandling
{
    func handle(
        _ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest,
        context: ILMessageFilterExtensionContext,
        completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void
    ) {
        let response = ILMessageFilterCapabilitiesQueryResponse()
        response.transactionalSubActions = [
            .transactionalFinance, .transactionalOrders, .transactionalReminders,
            .transactionalHealth, .transactionalWeather, .transactionalCarrier,
            .transactionalRewards, .transactionalPublicServices, .transactionalOthers,
        ]
        response.promotionalSubActions = [
            .promotionalOffers, .promotionalCoupons, .promotionalOthers,
        ]
        completion(response)
    }

    func handle(
        _ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext,
        completion: @escaping (ILMessageFilterQueryResponse) -> Void
    ) {
        logger.info("📨 Filtering request received from: \(queryRequest.sender ?? "unknown")")

        let (offlineAction, offlineSubAction) = self.offlineAction(for: queryRequest)

        logger.info(
            "✅ Filter result: action=\(String(describing: offlineAction.rawValue)), subAction=\(String(describing: offlineSubAction.rawValue))"
        )

        let response = ILMessageFilterQueryResponse()
        response.action = offlineAction
        response.subAction = offlineSubAction
        completion(response)
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (
        ILMessageFilterAction, ILMessageFilterSubAction
    ) {
        guard let sharedDefaults = UserDefaults(suiteName: suiteName),
            let sender = queryRequest.sender
        else {
            logger.error("❌ Could not access shared defaults or sender is nil")
            return (.none, .none)
        }

        logger.debug("🔍 Sender: \(sender)")

        let allowedNumbersRaw = sharedDefaults.array(forKey: "allowedNumbers") as? [String] ?? []
        let blockedNumbersRaw = sharedDefaults.array(forKey: "blockedNumbers") as? [String] ?? []
        let filterRules = sharedDefaults.array(forKey: "filterRules") as? [[String: String]] ?? []
        let numberFilterRules =
            sharedDefaults.array(forKey: "numberFilterRules") as? [[String: String]] ?? []

        let cleanSender = MessageFilterMatcher.normalizedPhoneNumber(sender)
        let senderUppercase = MessageFilterMatcher.normalizedSenderName(sender)

        // Mesaj içeriğini al (varsa)
        let messageBody = queryRequest.messageBody ?? ""

        logger.debug(
            "📋 Allowed numbers: \(allowedNumbersRaw.count), Blocked numbers: \(blockedNumbersRaw.count), Filter rules: \(filterRules.count), Number filter rules: \(numberFilterRules.count)"
        )

        let allowedNumbersNormalized = sharedDefaults.array(forKey: allowedNumbersNormalizedKey) as? [String] ?? []
        let allowedSenderNamesNormalized = sharedDefaults.array(forKey: allowedSenderNamesNormalizedKey) as? [String] ?? []
        let blockedNumbersNormalized = sharedDefaults.array(forKey: blockedNumbersNormalizedKey) as? [String] ?? []
        let blockedSenderNamesNormalized = sharedDefaults.array(forKey: blockedSenderNamesNormalizedKey) as? [String] ?? []

        let (allowedNumbers, allowedNames) = MessageFilterExtension.useNormalizedIfAvailable(
            numbers: allowedNumbersNormalized,
            names: allowedSenderNamesNormalized,
            fallback: allowedNumbersRaw
        )
        let (blockedNumbers, blockedNames) = MessageFilterExtension.useNormalizedIfAvailable(
            numbers: blockedNumbersNormalized,
            names: blockedSenderNamesNormalized,
            fallback: blockedNumbersRaw
        )

        let normalizedAllowedNumbers = allowedNumbers.map(MessageFilterMatcher.normalizedPhoneNumber).filter { !$0.isEmpty }
        let normalizedBlockedNumbers = blockedNumbers.map(MessageFilterMatcher.normalizedPhoneNumber).filter { !$0.isEmpty }

        let allowedNumbersSet = Set(normalizedAllowedNumbers)
        let blockedNumbersSet = Set(normalizedBlockedNumbers)
        let allowedNamesSet = Set(allowedNames)
        let blockedNamesSet = Set(blockedNames)

        // 1. ÖNCELİK: Whitelist kontrolü - Güvenli numaralardaysa geçir
        if !allowedNamesSet.isEmpty {
            if allowedNamesSet.contains(senderUppercase) {
                logger.info("✅ Allowed by whitelist (name exact): \(senderUppercase)")
                return (.none, .none)
            }
            for allowedUpper in allowedNames where MessageFilterMatcher.senderNamesMatch(stored: allowedUpper, sender: sender) {
                logger.info("✅ Allowed by whitelist (name): \(allowedUpper)")
                return (.none, .none)
            }
        }

        if !allowedNumbersSet.isEmpty {
            if allowedNumbersSet.contains(cleanSender) {
                logger.info("✅ Allowed by whitelist (number exact): \(cleanSender)")
                return (.none, .none)
            }
            for allowedDigits in allowedNumbers where MessageFilterMatcher.numbersMatch(stored: allowedDigits, sender: sender) {
                logger.info("✅ Allowed by whitelist (number): \(allowedDigits)")
                return (.none, .none)
            }
        }

        // 2. Numara filtre kuralları kontrolü
            for rule in numberFilterRules {
                if let prefix = rule["prefix"], MessageFilterMatcher.numberRuleMatches(type: "prefix", value: prefix, sender: sender) {
                    incrementStatistic(key: "smsJunkCount")
                    logger.info("🚫 Blocked as junk by number rule: prefix=\(prefix)")
                    // record last junk sender for app UI to allow 'Not Junk' action
                    sharedDefaults.set(sender, forKey: "lastJunkSender")
                    return (.junk, .none)
                }
                if let suffix = rule["suffix"], MessageFilterMatcher.numberRuleMatches(type: "suffix", value: suffix, sender: sender) {
                    incrementStatistic(key: "smsJunkCount")
                    logger.info("🚫 Blocked as junk by number rule: suffix=\(suffix)")
                    sharedDefaults.set(sender, forKey: "lastJunkSender")
                    return (.junk, .none)
                }
                if let contains = rule["contains"], MessageFilterMatcher.numberRuleMatches(type: "contains", value: contains, sender: sender) {
                    incrementStatistic(key: "smsJunkCount")
                    logger.info("🚫 Blocked as junk by number rule: contains=\(contains)")
                    sharedDefaults.set(sender, forKey: "lastJunkSender")
                    return (.junk, .none)
                }
            }

        // 3. Blocklist kontrolü - açık kullanıcı kararı kategori kurallarından önce gelir.
        if !blockedNamesSet.isEmpty {
            if blockedNamesSet.contains(senderUppercase) {
                incrementStatistic(key: "smsJunkCount")
                logger.info("🚫 Blocked as junk (text sender exact): \(senderUppercase)")
                sharedDefaults.set(sender, forKey: "lastJunkSender")
                return (.junk, .none)
            }
        }

        for blockedName in blockedNames where MessageFilterMatcher.senderNamesMatch(stored: blockedName, sender: sender) {
            incrementStatistic(key: "smsJunkCount")
            logger.info("🚫 Blocked as junk (text sender): \(blockedName)")
            sharedDefaults.set(sender, forKey: "lastJunkSender")
            return (.junk, .none)
        }

        for blockedDigits in normalizedBlockedNumbers {
            if blockedNumbersSet.contains(cleanSender)
                || MessageFilterMatcher.numbersMatch(stored: blockedDigits, sender: sender) {
                // Junk sayacını artır
                incrementStatistic(key: "smsJunkCount")
                logger.info("🚫 Blocked as junk: number=\(blockedDigits)")
                sharedDefaults.set(sender, forKey: "lastJunkSender")
                return (.junk, .none)
            }
        }

        // 4. Filtre kuralları - açık whitelist/blocklist kararından sonra kategorize et.
        for rule in filterRules {
            if let keyword = rule["keyword"], let category = rule["category"] {
                if sender.range(of: keyword, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                    || messageBody.range(of: keyword, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                {
                    let subAction = getSubAction(for: category)
                    incrementStatistic(key: "smsCategorizedCount")
                    logger.info(
                        "📂 Categorized by rule: keyword=\(keyword) in sender or body, category=\(category)"
                    )
                    if category.hasPrefix("transactional") {
                        return (.transaction, subAction)
                    } else if category.hasPrefix("promotional") {
                        return (.promotion, subAction)
                    }
                }
            }
        }

        logger.debug("➡️ No filter applied, message passes through")
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

    private func networkAction(for networkResponse: ILNetworkResponse) -> (
        ILMessageFilterAction, ILMessageFilterSubAction
    ) {
        return (.none, .none)
    }

    private static func splitNumbersAndNames(_ values: [String]) -> (numbers: [String], names: [String]) {
        var numbers: [String] = []
        var names: [String] = []
        for value in values {
            if value.rangeOfCharacter(from: .letters) != nil {
                let cleaned = MessageFilterMatcher.normalizedSenderName(value)
                if !cleaned.isEmpty { names.append(cleaned) }
            } else {
                let cleaned = MessageFilterMatcher.normalizedPhoneNumber(value)
                if !cleaned.isEmpty { numbers.append(cleaned) }
            }
        }
        return (numbers, names)
    }

    private static func useNormalizedIfAvailable(numbers: [String], names: [String], fallback: [String]) -> (numbers: [String], names: [String]) {
        if !numbers.isEmpty || !names.isEmpty {
            return (numbers, names)
        }
        return splitNumbersAndNames(fallback)
    }

}
