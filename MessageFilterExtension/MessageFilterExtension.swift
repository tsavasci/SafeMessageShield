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

        // 1) Öncelikle shared UserDefaults'a yazmayı dene
        if let sharedDefaults = UserDefaults(suiteName: suiteName) {
            let currentCount = sharedDefaults.integer(forKey: key)
            let newCount = currentCount + 1
            sharedDefaults.set(newCount, forKey: key)
            sharedDefaults.set(Date(), forKey: "lastSMSFilterDate")
            sharedDefaults.synchronize()  // best-effort

            // Doğrulama: yazma gerçekten gerçekleşti mi?
            let verify = sharedDefaults.integer(forKey: key)
            if verify == newCount {
                logger.info("✅ Updated \(key) via UserDefaults: \(newCount)")
                return
            } else {
                logger.warning(
                    "⚠️ Shared UserDefaults write didn't persist for key: \(key). Falling back to file."
                )
            }
        } else {
            logger.error("❌ Could not access shared UserDefaults (suiteName: \(suiteName))")
        }

        // 2) Fallback: App Group container içinde dosyaya yaz (JSON)
        if let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: suiteName)
        {
            let statsFile = containerURL.appendingPathComponent("SafeMessageShield_stats.json")
            var stats: [String: Any] = [:]

            // Mevcut dosyayı oku ve merge et
            if let data = try? Data(contentsOf: statsFile),
                let obj = try? JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any]
            {
                stats = obj
            }

            // Anahtar için mevcut değeri al, artır
            let current = (stats[key] as? Int) ?? 0
            let newCount = current + 1
            stats[key] = newCount

            // Tarihi ISO8601 formatında sakla
            stats["lastSMSFilterDate"] = ISO8601DateFormatter().string(from: Date())

            // JSON olarak yaz
            if let newData = try? JSONSerialization.data(
                withJSONObject: stats, options: [.prettyPrinted])
            {
                do {
                    try newData.write(to: statsFile, options: .atomic)
                    logger.info("✅ Fallback wrote \(key) to \(statsFile.path) -> \(newCount)")
                } catch {
                    logger.error(
                        "❌ Fallback write failed for \(statsFile.path): \(error.localizedDescription)"
                    )
                }
            } else {
                logger.error("❌ Could not serialize stats for fallback write")
            }
        } else {
            logger.error(
                "❌ Could not access app group container for fallback (suiteName: \(suiteName))")
        }
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

        let cleanSender = sender.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        let senderUppercase = sender.uppercased()

        // Mesaj içeriğini al (varsa)
        let messageBody = queryRequest.messageBody?.lowercased() ?? ""

        logger.debug(
            "📋 Allowed numbers: \(allowedNumbers.count), Blocked numbers: \(blockedNumbers.count), Filter rules: \(filterRules.count)"
        )

        // 1. ÖNCELİK: Whitelist kontrolü - Güvenli numaralardaysa geçir
        for allowedEntry in allowedNumbers {
            let cleanAllowed = allowedEntry.components(
                separatedBy: CharacterSet.decimalDigits.inverted
            ).joined()

            // Eğer sadece harf içeriyorsa (isim), direkt karşılaştır
            if cleanAllowed.isEmpty {
                // Bu bir isim (örn: "ARASKARGO", "MİGROS")
                if senderUppercase.contains(allowedEntry) || allowedEntry.contains(senderUppercase)
                {
                    logger.info("✅ Allowed by whitelist (name): \(allowedEntry)")
                    return (.none, .none)  // Mesajı geçir
                }
            } else {
                // Bu bir numara, numara karşılaştırması yap
                if cleanSender == cleanAllowed || cleanSender.hasSuffix(cleanAllowed)
                    || cleanAllowed.hasSuffix(cleanSender) || cleanSender.contains(cleanAllowed)
                    || cleanAllowed.contains(cleanSender)
                {
                    logger.info("✅ Allowed by whitelist (number): \(allowedEntry)")
                    return (.none, .none)  // Mesajı geçir
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

        // 3. Blocklist kontrolü - Engellenenlerdeyse spam olarak işaretle
        for blockedNumber in blockedNumbers {
            let cleanBlocked = blockedNumber.components(
                separatedBy: CharacterSet.decimalDigits.inverted
            ).joined()

            if cleanSender == cleanBlocked || cleanSender.hasSuffix(cleanBlocked)
                || cleanBlocked.hasSuffix(cleanSender) || cleanSender.contains(cleanBlocked)
                || cleanBlocked.contains(cleanSender)
            {

                // Junk sayacını artır
                incrementStatistic(key: "smsJunkCount")
                logger.info("🚫 Blocked as junk: number=\(blockedNumber)")

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
