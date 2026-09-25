import Foundation
import PhoneNumberKit

/// Kullanıcının yazdığı değerin saklanacak hâli.
nonisolated enum PhoneNumberEntry: Equatable, Sendable {
    /// Uluslararası numara, "+" ile (örn. "+905551234567")
    case number(String)
    /// Kısa numara, ülke kodu eklenmez (örn. "4567")
    case shortCode(String)
    /// Alfanümerik gönderici adı (örn. "VODAFONE")
    case senderName(String)

    /// DataManager'a verilecek değer
    var storageValue: String {
        switch self {
        case .number(let value), .shortCode(let value), .senderName(let value):
            return value
        }
    }

    /// Kullanıcıya gösterilecek, saklanan biçimle aynı değer
    var displayValue: String {
        switch self {
        case .number(let value):
            return PhoneNumberNormalizer.digitsOnly(value)
        case .shortCode(let value), .senderName(let value):
            return value
        }
    }
}

nonisolated enum PhoneNumberEntryError: Error, Equatable, Sendable {
    case empty
    /// Numara seçilen ülke için geçerli değil
    case invalidNumber
}

/// Ülke seçiminde gösterilecek bölge
nonisolated struct PhoneRegion: Identifiable, Hashable, Sendable {
    let code: String
    let countryCode: UInt64

    var id: String { code }

    /// Bölge kodundan bayrak emojisi üretir (örn. "TR" → 🇹🇷)
    var flag: String {
        code.unicodeScalars.reduce(into: "") { result, scalar in
            if let flagScalar = UnicodeScalar(127397 + scalar.value) {
                result.unicodeScalars.append(flagScalar)
            }
        }
    }

    /// "+90" gibi arama kodu; sağdan sola dillerde "+" yanlış tarafa geçmesin diye soldan sağa yalıtılır
    var dialCode: String {
        "\u{2066}+\(countryCode)\u{2069}"
    }

    func localizedName(locale: Locale) -> String {
        locale.localizedString(forRegionCode: code) ?? code
    }
}

/// PhoneNumberKit ile numara çözümleme ve doğrulama. Yalnızca uygulamada kullanılır;
/// uzantılar bellek limitleri nedeniyle `PhoneNumberNormalizer` + `DialingRegion` kullanır.
nonisolated final class PhoneNumberService: @unchecked Sendable {
    static let shared = PhoneNumberService()

    // PhoneNumberUtility metadata'yı yükler; tek örnek kullanılır ve erişim kilitle korunur.
    private let utility: PhoneNumberUtility
    private let lock = NSLock()

    init() {
        PhoneNumberUtility.canUseContactsFramework = false
        utility = PhoneNumberUtility()
    }

    /// Girdiyi saklanacak değere çevirir.
    /// - "+" ile başlayan numaralarda seçili ülke yok sayılır.
    /// - 3–6 haneli kısa numaralar ve harf içeren gönderici adları olduğu gibi kalır.
    func entry(for input: String, regionCode: String) -> Result<PhoneNumberEntry, PhoneNumberEntryError> {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return .failure(.empty) }

        if trimmed.rangeOfCharacter(from: .letters) != nil {
            return .success(.senderName(trimmed.uppercased()))
        }

        let digits = PhoneNumberNormalizer.digitsOnly(trimmed)
        let isInternational = trimmed.hasPrefix("+") || digits.hasPrefix("00")
        if !isInternational, (3...PhoneNumberNormalizer.shortCodeMaxLength).contains(digits.count) {
            return .success(.shortCode(digits))
        }

        lock.lock()
        defer { lock.unlock() }
        do {
            let parsed = try utility.parse(trimmed, withRegion: regionCode.uppercased())
            return .success(.number(utility.format(parsed, toType: .e164)))
        } catch {
            return .failure(.invalidNumber)
        }
    }

    /// Uzantıların yerel numaraları çözebilmesi için ülke bilgisi
    func dialingRegion(for regionCode: String) -> DialingRegion? {
        lock.lock()
        defer { lock.unlock() }
        let code = regionCode.uppercased()
        guard let countryCode = utility.countryCode(for: code) else { return nil }
        return DialingRegion(
            regionCode: code,
            countryCode: String(countryCode),
            nationalPrefix: utility.metadata(for: code)?.nationalPrefix
        )
    }

    /// Seçilebilir tüm ülkeler
    func allRegions() -> [PhoneRegion] {
        lock.lock()
        defer { lock.unlock() }
        return utility.allCountries()
            .filter { $0.count == 2 }
            .compactMap { code in
                utility.countryCode(for: code).map { PhoneRegion(code: code, countryCode: $0) }
            }
    }

    func region(for regionCode: String) -> PhoneRegion? {
        lock.lock()
        defer { lock.unlock() }
        let code = regionCode.uppercased()
        return utility.countryCode(for: code).map { PhoneRegion(code: code, countryCode: $0) }
    }

    /// Cihazın bölge ayarı (uygulama dili değil); desteklenmiyorsa "US"
    func deviceRegionCode() -> String {
        let code = Locale.current.region?.identifier.uppercased() ?? "US"
        return region(for: code) == nil ? "US" : code
    }
}
