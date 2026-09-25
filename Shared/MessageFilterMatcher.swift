import Foundation

nonisolated enum MessageFilterMatcher {
    /// Saklanan değerler zaten uluslararası biçimdedir; yalnızca rakamlarına indirgenir.
    static func normalizedPhoneNumber(_ input: String) -> String {
        PhoneNumberNormalizer.normalize(input)
    }

    /// Gönderenin olası biçimleri: ham rakamlar ve (bölge biliniyorsa) uluslararası biçim.
    static func senderCandidates(_ sender: String, region: DialingRegion?) -> Set<String> {
        var candidates: Set<String> = [PhoneNumberNormalizer.normalize(sender)]
        candidates.insert(PhoneNumberNormalizer.normalize(sender, region: region))
        candidates.remove("")
        return candidates
    }

    static func numbersMatch(stored: String, sender: String, region: DialingRegion? = nil) -> Bool {
        guard sender.rangeOfCharacter(from: .letters) == nil else { return false }
        let storedDigits = normalizedPhoneNumber(stored)
        let candidates = senderCandidates(sender, region: region)
        guard !storedDigits.isEmpty, !candidates.isEmpty else { return false }
        if candidates.contains(storedDigits) { return true }

        // Bölge bilinmediğinde yerel/uluslararası biçim farkını son hanelerle tolere et.
        for senderDigits in candidates {
            let shorterCount = min(storedDigits.count, senderDigits.count)
            let lengthDifference = abs(storedDigits.count - senderDigits.count)
            guard shorterCount >= 7, lengthDifference <= 3 else { continue }
            if storedDigits.hasSuffix(senderDigits) || senderDigits.hasSuffix(storedDigits) {
                return true
            }
        }
        return false
    }

    static func normalizedSenderName(_ input: String) -> String {
        input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }

    static func senderNamesMatch(stored: String, sender: String) -> Bool {
        let storedName = normalizedSenderName(stored)
        let senderName = normalizedSenderName(sender)
        return !storedName.isEmpty && storedName == senderName
    }

    static func numberRuleMatches(type: String, value: String, sender: String, region: DialingRegion? = nil) -> Bool {
        guard sender.rangeOfCharacter(from: .letters) == nil else { return false }
        let rule = normalizedPhoneNumber(value)
        let senderDigits = normalizedPhoneNumber(sender)
        guard rule.count >= 3, !senderDigits.isEmpty else { return false }

        let senderVariants = phoneVariants(senderDigits, region: region)
        let ruleVariants = phoneVariants(rule, region: region)
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

    /// Aynı numaranın uluslararası, ulusal ve önekli ulusal biçimleri
    /// (örn. TR: 905551234567, 5551234567, 05551234567).
    private static func phoneVariants(_ value: String, region: DialingRegion?) -> Set<String> {
        var variants: Set<String> = [value]
        guard let region, value.count > PhoneNumberNormalizer.shortCodeMaxLength else { return variants }

        let national: String
        if let nationalPrefix = region.nationalPrefix, value.hasPrefix(nationalPrefix) {
            national = String(value.dropFirst(nationalPrefix.count))
        } else if value.hasPrefix(region.countryCode) {
            national = String(value.dropFirst(region.countryCode.count))
        } else {
            national = value
        }

        variants.insert(national)
        variants.insert(region.countryCode + national)
        if let nationalPrefix = region.nationalPrefix {
            variants.insert(nationalPrefix + national)
        }
        return variants
    }
}
