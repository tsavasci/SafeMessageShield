//
//  RuleBackupManager.swift
//  SafeMessageShield
//

import Foundation
import SwiftData

/// Kuralların JSON olarak dışa ve içe aktarılmasını yöneten servis.
/// Kullanıcının cihaz değiştirme veya veri koruma ihtiyaçlarını karşılar.
final class RuleBackupManager {
    static let shared = RuleBackupManager()

    nonisolated struct BackupPayload: Codable, Equatable, Sendable {
        let version: Int
        let exportedAt: Date
        let blockedNumbers: [BlockedEntry]
        let allowedNumbers: [AllowedEntry]
        let filterRules: [FilterEntry]
        let numberFilterRules: [NumberRuleEntry]

        nonisolated struct BlockedEntry: Codable, Equatable, Sendable {
            let phoneNumber: String
            let reason: String?
            let addedAt: Date
        }

        nonisolated struct AllowedEntry: Codable, Equatable, Sendable {
            let phoneNumber: String
            let reason: String?
            let addedAt: Date
        }

        nonisolated struct FilterEntry: Codable, Equatable, Sendable {
            let keyword: String
            let category: String
            let createdAt: Date
        }

        nonisolated struct NumberRuleEntry: Codable, Equatable, Sendable {
            let ruleType: String
            let value: String
            let addedAt: Date
        }
    }

    nonisolated struct ImportSummary: Equatable, Sendable {
        let addedBlocked: Int
        let addedAllowed: Int
        let addedFilterRules: Int
        let addedNumberRules: Int

        var blockedCount: Int { addedBlocked }
        var allowedCount: Int { addedAllowed }
        var filterRuleCount: Int { addedFilterRules }
        var numberFilterRuleCount: Int { addedNumberRules }

        var totalAdded: Int {
            addedBlocked + addedAllowed + addedFilterRules + addedNumberRules
        }
    }

    /// Mevcut verileri JSON string olarak üretir
    func exportToJSON(
        blocked: [BlockedNumber],
        allowed: [AllowedNumber],
        filterRules: [FilterRule],
        numberFilterRules: [NumberFilterRule]
    ) throws -> String {
        let payload = BackupPayload(
            version: 1,
            exportedAt: Date(),
            blockedNumbers: blocked.map {
                .init(phoneNumber: $0.phoneNumber, reason: $0.reason, addedAt: $0.addedAt)
            },
            allowedNumbers: allowed.map {
                .init(phoneNumber: $0.phoneNumber, reason: $0.reason, addedAt: $0.addedAt)
            },
            filterRules: filterRules.map {
                .init(keyword: $0.keyword, category: $0.category, createdAt: $0.createdAt)
            },
            numberFilterRules: numberFilterRules.map {
                .init(ruleType: $0.ruleType, value: $0.value, addedAt: $0.addedAt)
            }
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(payload)
        guard let string = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "RuleBackupManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Encoding error"])
        }
        return string
    }

    /// JSON içeriğini çözümler ve veritabanına ekler
    func importFromJSON(
        _ jsonString: String,
        existingBlocked: [BlockedNumber],
        existingAllowed: [AllowedNumber],
        existingFilterRules: [FilterRule],
        existingNumberRules: [NumberFilterRule],
        modelContext: ModelContext
    ) throws -> ImportSummary {
        guard let data = jsonString.data(using: .utf8) else {
            throw NSError(domain: "RuleBackupManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let payload = try decoder.decode(BackupPayload.self, from: data)

        let existingBlockedSet = Set(existingBlocked.map { $0.phoneNumber })
        let existingAllowedSet = Set(existingAllowed.map { $0.phoneNumber })
        let existingFilterKeywords = Set(existingFilterRules.map { $0.keyword.lowercased() })
        let existingNumberTuples = Set(existingNumberRules.map { "\($0.ruleType):\($0.value)" })

        var addedBlocked = 0
        var addedAllowed = 0
        var addedFilter = 0
        var addedNumberRules = 0

        for item in payload.blockedNumbers {
            if !existingBlockedSet.contains(item.phoneNumber) {
                let blocked = BlockedNumber(phoneNumber: item.phoneNumber, reason: item.reason)
                modelContext.insert(blocked)
                addedBlocked += 1
            }
        }

        for item in payload.allowedNumbers {
            if !existingAllowedSet.contains(item.phoneNumber) {
                let allowed = AllowedNumber(phoneNumber: item.phoneNumber, reason: item.reason)
                modelContext.insert(allowed)
                addedAllowed += 1
            }
        }

        for item in payload.filterRules {
            let keyLower = item.keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if !existingFilterKeywords.contains(keyLower) && !keyLower.isEmpty {
                let rule = FilterRule(keyword: item.keyword, category: item.category)
                modelContext.insert(rule)
                addedFilter += 1
            }
        }

        for item in payload.numberFilterRules {
            let key = "\(item.ruleType):\(item.value)"
            if !existingNumberTuples.contains(key) {
                let rule = NumberFilterRule(ruleType: item.ruleType, value: item.value)
                modelContext.insert(rule)
                addedNumberRules += 1
            }
        }

        try modelContext.save()
        return ImportSummary(
            addedBlocked: addedBlocked,
            addedAllowed: addedAllowed,
            addedFilterRules: addedFilter,
            addedNumberRules: addedNumberRules
        )
    }
}
