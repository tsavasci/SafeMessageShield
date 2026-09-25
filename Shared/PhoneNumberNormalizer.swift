import Foundation

/// Yerel biçimde yazılmış numaraları uluslararası biçime çevirmek için gereken ülke bilgisi.
/// Uygulama, PhoneNumberKit metadata'sından üretip App Group'a yazar; uzantılar
/// PhoneNumberKit yüklemeden (bellek limitleri düşük) bu küçük değeri okur.
nonisolated struct DialingRegion: Equatable, Sendable {
    /// ISO 3166 bölge kodu, örn. "TR"
    let regionCode: String
    /// Ülke arama kodu, "+" olmadan, örn. "90"
    let countryCode: String
    /// Ülke içi arama öneki, örn. "0" (TR), "8" (RU); yoksa nil (US, IT)
    let nationalPrefix: String?

    static let storageKey = "defaultDialingRegion"

    init(regionCode: String, countryCode: String, nationalPrefix: String?) {
        self.regionCode = regionCode
        self.countryCode = countryCode
        let trimmedPrefix = nationalPrefix?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.nationalPrefix = (trimmedPrefix?.isEmpty ?? true) ? nil : trimmedPrefix
    }

    /// App Group'tan okur; kayıt yoksa nil döner (bu durumda numaralar yalnızca rakamlarına indirgenir).
    static func load(from defaults: UserDefaults?) -> DialingRegion? {
        guard let dictionary = defaults?.dictionary(forKey: storageKey) as? [String: String],
              let regionCode = dictionary["regionCode"],
              let countryCode = dictionary["countryCode"],
              !countryCode.isEmpty
        else { return nil }
        return DialingRegion(regionCode: regionCode, countryCode: countryCode, nationalPrefix: dictionary["nationalPrefix"])
    }

    func save(to defaults: UserDefaults?) {
        var dictionary = ["regionCode": regionCode, "countryCode": countryCode]
        if let nationalPrefix { dictionary["nationalPrefix"] = nationalPrefix }
        defaults?.set(dictionary, forKey: Self.storageKey)
    }
}

nonisolated enum PhoneNumberNormalizer {
    /// Bu uzunluğa kadar olan rakam dizileri kısa numara (örn. 4567) kabul edilir; ülke kodu eklenmez.
    static let shortCodeMaxLength = 6

    /// Girdideki rakamlar dışındaki her şeyi atar.
    static func digitsOnly(_ input: String) -> String {
        input.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    /// Numarayı karşılaştırma/saklama biçimine getirir: ülke kodu dahil, "+" olmadan yalnızca rakamlar.
    ///
    /// - "+" veya "00" ile başlayan numaralar zaten uluslararasıdır; yalnızca rakamlarına indirgenir.
    /// - `region` verilirse yerel numaralar (örn. TR için "0555…") o ülkenin koduyla tamamlanır.
    /// - `region` verilmezse ya da girdi kısa numaraysa hiçbir ülke kodu varsayılmaz.
    static func normalize(_ input: String, region: DialingRegion? = nil) -> String {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        let digits = digitsOnly(trimmed)

        if trimmed.hasPrefix("+") {
            return digits
        }
        if digits.hasPrefix("00") {
            return String(digits.dropFirst(2))
        }
        guard let region, digits.count > shortCodeMaxLength else {
            return digits
        }
        if let nationalPrefix = region.nationalPrefix, digits.hasPrefix(nationalPrefix) {
            return region.countryCode + digits.dropFirst(nationalPrefix.count)
        }
        if digits.hasPrefix(region.countryCode) {
            // "+" yazılmadan girilmiş uluslararası numara (örn. 905551234567)
            return digits
        }
        return region.countryCode + digits
    }

    static func isValidCallDirectoryNumber(_ value: String) -> Bool {
        (3...15).contains(value.count) && value.first != "0"
    }
}
