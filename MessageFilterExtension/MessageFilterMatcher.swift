import Foundation

enum MessageFilterMatcher {
    static func normalizedPhoneNumber(_ input: String) -> String {
        PhoneNumberNormalizer.normalize(input)
    }

    static func numbersMatch(stored: String, sender: String) -> Bool {
        let storedDigits = normalizedPhoneNumber(stored)
        let senderDigits = normalizedPhoneNumber(sender)
        guard !storedDigits.isEmpty, !senderDigits.isEmpty else { return false }
        if storedDigits == senderDigits { return true }

        let shorterCount = min(storedDigits.count, senderDigits.count)
        let lengthDifference = abs(storedDigits.count - senderDigits.count)
        guard shorterCount >= 7, lengthDifference <= 3 else { return false }
        return storedDigits.hasSuffix(senderDigits) || senderDigits.hasSuffix(storedDigits)
    }

    static func normalizedSenderName(_ input: String) -> String {
        input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }

    static func senderNamesMatch(stored: String, sender: String) -> Bool {
        let storedName = normalizedSenderName(stored)
        let senderName = normalizedSenderName(sender)
        return !storedName.isEmpty && storedName == senderName
    }

    static func numberRuleMatches(type: String, value: String, sender: String) -> Bool {
        let rule = normalizedPhoneNumber(value)
        let senderDigits = normalizedPhoneNumber(sender)
        guard rule.count >= 3, !senderDigits.isEmpty else { return false }

        let senderVariants = phoneVariants(senderDigits)
        let ruleVariants = phoneVariants(rule)
        for senderVariant in senderVariants {
            for ruleVariant in ruleVariants {
                switch type {
                case "prefix" where senderVariant.hasPrefix(ruleVariant): return true
                case "suffix" where senderVariant.hasSuffix(ruleVariant): return true
                case "contains" where senderVariant.contains(ruleVariant): return true
                default: continue
                }
            }
        }
        return false
    }

    private static func phoneVariants(_ value: String) -> Set<String> {
        var variants: Set<String> = [value]
        if value.count == 12, value.hasPrefix("90") {
            let national = String(value.dropFirst(2))
            variants.insert(national)
            variants.insert("0" + national)
        } else if value.count == 11, value.hasPrefix("0") {
            variants.insert(String(value.dropFirst()))
        }
        return variants
    }
}
