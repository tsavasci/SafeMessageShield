//
//  FilterSimulatorEngine.swift
//  SafeMessageShield
//

import Foundation

/// Gerçek iOS MessageFilterExtension karar motorunu simüle eden servis.
/// Kullanıcının kural ve kara listelerini test etmesini sağlar.
final class FilterSimulatorEngine {
    static let shared = FilterSimulatorEngine()

    /// Verilen gönderen ve mesaj metnini mevcut kurallarla analiz eder.
    func simulate(
        sender: String,
        messageBody: String,
        allowedNumbers: [String],
        blockedNumbers: [String],
        filterRules: [(keyword: String, category: String)],
        numberFilterRules: [(type: String, value: String)],
        region: DialingRegion?
    ) -> FilterSimulationResult {
        let trimmedSender = sender.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBody = messageBody.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedSender.isEmpty else {
            return FilterSimulationResult(
                outcome: .allowedDefault,
                explanation: NSLocalizedString("sim.error.empty.sender", comment: ""),
                senderEvaluated: sender,
                messageBodyEvaluated: messageBody
            )
        }

        let isSenderAlphabetic = trimmedSender.rangeOfCharacter(from: .letters) != nil
        let senderUpper = MessageFilterMatcher.normalizedSenderName(trimmedSender)

        // 1. Whitelist / Güvenli Liste Kontrolü
        for allowed in allowedNumbers {
            let isAllowedAlphabetic = allowed.rangeOfCharacter(from: .letters) != nil
            if isSenderAlphabetic && isAllowedAlphabetic {
                if MessageFilterMatcher.senderNamesMatch(stored: allowed, sender: trimmedSender) {
                    let text = String(format: NSLocalizedString("sim.explanation.allowed.name", comment: ""), allowed)
                    return FilterSimulationResult(
                        outcome: .allowedByWhitelist(allowed),
                        explanation: text,
                        senderEvaluated: trimmedSender,
                        messageBodyEvaluated: trimmedBody
                    )
                }
            } else if !isSenderAlphabetic && !isAllowedAlphabetic {
                if MessageFilterMatcher.numbersMatch(stored: allowed, sender: trimmedSender, region: region) {
                    let display = PhoneNumberService.shared.displayString(forStored: allowed)
                    let text = String(format: NSLocalizedString("sim.explanation.allowed.number", comment: ""), display)
                    return FilterSimulationResult(
                        outcome: .allowedByWhitelist(allowed),
                        explanation: text,
                        senderEvaluated: trimmedSender,
                        messageBodyEvaluated: trimmedBody
                    )
                }
            }
        }

        // 2. Blocklist / Engelli Numara Kontrolü
        for blocked in blockedNumbers {
            let isBlockedAlphabetic = blocked.rangeOfCharacter(from: .letters) != nil
            if isSenderAlphabetic && isBlockedAlphabetic {
                if MessageFilterMatcher.senderNamesMatch(stored: blocked, sender: trimmedSender) {
                    let text = String(format: NSLocalizedString("sim.explanation.blocked.name", comment: ""), blocked)
                    return FilterSimulationResult(
                        outcome: .blockedByBlocklist(blocked),
                        explanation: text,
                        senderEvaluated: trimmedSender,
                        messageBodyEvaluated: trimmedBody
                    )
                }
            } else if !isSenderAlphabetic && !isBlockedAlphabetic {
                if MessageFilterMatcher.numbersMatch(stored: blocked, sender: trimmedSender, region: region) {
                    let display = PhoneNumberService.shared.displayString(forStored: blocked)
                    let text = String(format: NSLocalizedString("sim.explanation.blocked.number", comment: ""), display)
                    return FilterSimulationResult(
                        outcome: .blockedByBlocklist(blocked),
                        explanation: text,
                        senderEvaluated: trimmedSender,
                        messageBodyEvaluated: trimmedBody
                    )
                }
            }
        }

        // 3. Numara Kuralı Kontrolü (Prefix, Suffix, Contains)
        if !isSenderAlphabetic {
            for rule in numberFilterRules {
                if MessageFilterMatcher.numberRuleMatches(type: rule.type, value: rule.value, sender: trimmedSender, region: region) {
                    let ruleTypeName: String
                    switch rule.type {
                    case "prefix": ruleTypeName = NSLocalizedString("rule.type.prefix", comment: "")
                    case "suffix": ruleTypeName = NSLocalizedString("rule.type.suffix", comment: "")
                    default: ruleTypeName = NSLocalizedString("rule.type.contains", comment: "")
                    }
                    let text = String(format: NSLocalizedString("sim.explanation.blocked.rule", comment: ""), ruleTypeName, rule.value)
                    return FilterSimulationResult(
                        outcome: .blockedByNumberRule(ruleType: rule.type, pattern: rule.value),
                        explanation: text,
                        senderEvaluated: trimmedSender,
                        messageBodyEvaluated: trimmedBody
                    )
                }
            }
        }

        // 4. Mesaj İçi Kelime Kuralı Kontrolü
        if !trimmedBody.isEmpty {
            let lowercasedBody = trimmedBody.lowercased()
            for rule in filterRules {
                let lowercasedKeyword = rule.keyword.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                guard !lowercasedKeyword.isEmpty else { continue }

                if lowercasedBody.contains(lowercasedKeyword) {
                    let cat = MessageCategory(rawValue: rule.category)
                    let catName = cat?.localizedName ?? rule.category
                    let text = String(format: NSLocalizedString("sim.explanation.filtered.keyword", comment: ""), rule.keyword, catName)
                    return FilterSimulationResult(
                        outcome: .filteredByKeyword(keyword: rule.keyword, categoryName: catName),
                        explanation: text,
                        senderEvaluated: trimmedSender,
                        messageBodyEvaluated: trimmedBody
                    )
                }
            }
        }

        // 5. Eşleşme yok -> Normal Gelen Kutusu
        let normalText = NSLocalizedString("sim.explanation.default.inbox", comment: "")
        return FilterSimulationResult(
            outcome: .allowedDefault,
            explanation: normalText,
            senderEvaluated: trimmedSender,
            messageBodyEvaluated: trimmedBody
        )
    }
}
