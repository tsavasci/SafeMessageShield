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

    private func incrementStatistic(key: String) {
        let suiteName = "group.tsavasci.SafeMessageShield"
        // Keep this function extremely fast and non-blocking.
        // Only try a lightweight UserDefaults write and return.
        guard let sharedDefaults = UserDefaults(suiteName: suiteName) else {
            logger.error("❌ Could not access shared UserDefaults (suiteName: \(suiteName))")
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
        guard let sharedDefaults = UserDefaults(suiteName: "group.tsavasci.SafeMessageShield"),
            let sender = queryRequest.sender
        else {
            logger.error("❌ Could not access shared defaults or sender is nil")
            return (.none, .none)
        }

        logger.debug("🔍 Sender: \(sender)")

        let allowedNumbers = sharedDefaults.array(forKey: "allowedNumbers") as? [String] ?? []
        let blockedNumbers = sharedDefaults.array(forKey: "blockedNumbers") as? [String] ?? []
        let filterRules = sharedDefaults.array(forKey: "filterRules") as? [[String: String]] ?? []
        let numberFilterRules =
            sharedDefaults.array(forKey: "numberFilterRules") as? [[String: String]] ?? []

        let cleanSender = sender.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        let senderUppercase = sender.uppercased()

        // Mesaj içeriğini al (varsa)
        let messageBody = queryRequest.messageBody?.lowercased() ?? ""

        logger.debug(
            "📋 Allowed numbers: \(allowedNumbers.count), Blocked numbers: \(blockedNumbers.count), Filter rules: \(filterRules.count), Number filter rules: \(numberFilterRules.count)"
        )

        // 1. ÖNCELİK: Whitelist kontrolü - Güvenli numaralardaysa geçir
        for allowedEntry in allowedNumbers {
            let cleanAllowed = allowedEntry.components(
                separatedBy: CharacterSet.decimalDigits.inverted
            ).joined()

            // Eğer sadece harf içeriyorsa (isim), kesin ve case-insensitive karşılaştır
            if cleanAllowed.isEmpty {
                // normalize and compare uppercase strings to avoid partial matches
                let allowedUpper = allowedEntry.uppercased()
                if senderUppercase == allowedUpper || senderUppercase.contains(allowedUpper) {
                    logger.info("✅ Allowed by whitelist (name): \(allowedEntry)")
                    return (.none, .none)
                }
            } else {
                // Bu bir numara: daha sıkı eşleştirme yapıyoruz.
                // Sadece tam eşleşme veya suffix eşleşmesi (ülke kodu/farklı formatlar için)
                if cleanSender == cleanAllowed || cleanSender.hasSuffix(cleanAllowed) {
                    logger.info("✅ Allowed by whitelist (number): \(allowedEntry)")
                    return (.none, .none)
                }
            }
        }

        // 2. Filtre Kuralları kontrolü - Mesaj içeriğine göre kategorize et
        if !messageBody.isEmpty {
            for rule in filterRules {
                if let keyword = rule["keyword"],
                    let category = rule["category"],
                    messageBody.contains(keyword.lowercased())
                {
                    // Kategoriyi belirle ve mesajı filtrele
                    let subAction = getSubAction(for: category)

                    // Kategorize edildi sayacını artır
                    incrementStatistic(key: "smsCategorizedCount")
                    logger.info("📂 Categorized by rule: keyword=\(keyword), category=\(category)")

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

        // 2.5. Numara filtre kuralları kontrolü
            // Helper functions to normalize and flexibly match prefixes/suffixes/contains
            func digitsOnly(_ s: String) -> String {
                return s.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            }

            func generateVariantsForSender(_ s: String) -> [String] {
                var variants: [String] = [s]
                if s.count > 1 { variants.append(String(s.dropFirst(1))) }
                if s.count > 2 { variants.append(String(s.dropFirst(2))) }
                if s.count > 3 { variants.append(String(s.dropFirst(3))) }
                // unique
                return Array(Set(variants))
            }

            func generateVariantsForRule(_ r: String) -> [String] {
                var variants: [String] = [r]
                if let first = r.first, first == "0" {
                    variants.append(String(r.dropFirst(1)))
                } else {
                    variants.append("0" + r)
                }
                // also try with possible country code prefix attempt (e.g., add '90' or drop leading zeros handled above)
                if r.count > 0 { variants.append("90" + r) }
                return Array(Set(variants))
            }

            func matchesPrefix(ruleValue: String, sender: String) -> Bool {
                let r = digitsOnly(ruleValue)
                guard !r.isEmpty else { return false }
                let sVariants = generateVariantsForSender(sender)
                let rVariants = generateVariantsForRule(r)
                for sv in sVariants {
                    for rv in rVariants {
                        if sv.hasPrefix(rv) { return true }
                    }
                }
                return false
            }

            func matchesSuffix(ruleValue: String, sender: String) -> Bool {
                let r = digitsOnly(ruleValue)
                guard !r.isEmpty else { return false }
                let sVariants = generateVariantsForSender(sender)
                let rVariants = generateVariantsForRule(r)
                for sv in sVariants {
                    for rv in rVariants {
                        if sv.hasSuffix(rv) { return true }
                    }
                }
                return false
            }

            func matchesContains(ruleValue: String, sender: String) -> Bool {
                let r = digitsOnly(ruleValue)
                guard !r.isEmpty else { return false }
                let sVariants = generateVariantsForSender(sender)
                let rVariants = generateVariantsForRule(r)
                for sv in sVariants {
                    for rv in rVariants {
                        if sv.contains(rv) { return true }
                    }
                }
                return false
            }

            for rule in numberFilterRules {
                if let prefix = rule["prefix"], matchesPrefix(ruleValue: prefix, sender: cleanSender) {
                    incrementStatistic(key: "smsJunkCount")
                    logger.info("🚫 Blocked as junk by number rule: prefix=\(prefix)")
                    // record last junk sender for app UI to allow 'Not Junk' action
                    sharedDefaults.set(sender, forKey: "lastJunkSender")
                    return (.junk, .none)
                }
                if let suffix = rule["suffix"], matchesSuffix(ruleValue: suffix, sender: cleanSender) {
                    incrementStatistic(key: "smsJunkCount")
                    logger.info("🚫 Blocked as junk by number rule: suffix=\(suffix)")
                    sharedDefaults.set(sender, forKey: "lastJunkSender")
                    return (.junk, .none)
                }
                if let contains = rule["contains"], matchesContains(ruleValue: contains, sender: cleanSender) {
                    incrementStatistic(key: "smsJunkCount")
                    logger.info("🚫 Blocked as junk by number rule: contains=\(contains)")
                    sharedDefaults.set(sender, forKey: "lastJunkSender")
                    return (.junk, .none)
                }
            }

        // 3. Blocklist kontrolü - Engellenenlerdeyse spam olarak işaretle
        for blockedNumber in blockedNumbers {
            let cleanBlocked = blockedNumber.components(
                separatedBy: CharacterSet.decimalDigits.inverted
            ).joined()

            // Eğer cleanBlocked boş ise (metin-tabanlı gönderici adı), case-insensitive tam eşleştirme yap
            if cleanBlocked.isEmpty {
                let blockedUpper = blockedNumber.uppercased()
                if senderUppercase == blockedUpper {
                    incrementStatistic(key: "smsJunkCount")
                    logger.info("🚫 Blocked as junk (text sender): \(blockedNumber)")
                    sharedDefaults.set(sender, forKey: "lastJunkSender")
                    return (.junk, .none)
                }
            } else if cleanSender == cleanBlocked || cleanSender.hasSuffix(cleanBlocked)
                || cleanBlocked.hasSuffix(cleanSender) || cleanSender.contains(cleanBlocked)
                || cleanBlocked.contains(cleanSender)
            {

                // Junk sayacını artır
                incrementStatistic(key: "smsJunkCount")
                logger.info("🚫 Blocked as junk: number=\(blockedNumber)")
                sharedDefaults.set(sender, forKey: "lastJunkSender")

                return (.junk, .none)
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
}
