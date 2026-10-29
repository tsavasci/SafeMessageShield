//
//  ProtectionPreset.swift
//  SafeMessageShield
//

import Foundation

/// Akıllı Spam Koruma Şablon Paketi Modeli
struct ProtectionPreset: Identifiable, Hashable {
    let id: String
    let icon: String
    let titleKey: String
    let descriptionKey: String
    let category: MessageCategory
    let localizedKeywords: [String: [String]]

    /// Verilen dil kodu (örn. "tr", "en") için anahtar kelimeleri döner.
    /// Dil bulunamazsa İngilizce veya ilk listeyi döner.
    func keywords(for languageCode: String) -> [String] {
        let code = languageCode.split(separator: "-").first.map(String.init) ?? languageCode
        if let list = localizedKeywords[languageCode] ?? localizedKeywords[code] {
            return list
        }
        return localizedKeywords["en"] ?? localizedKeywords.values.first ?? []
    }
}
