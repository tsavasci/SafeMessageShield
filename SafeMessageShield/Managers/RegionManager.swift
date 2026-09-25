//
//  RegionManager.swift
//  SafeMessageShield
//

import Foundation
import SwiftUI
import Combine

/// Ülke kodu olmadan yazılan numaraların hangi ülkeye ait sayılacağını yönetir.
/// Varsayılan değer uygulama dilinden değil, cihazın bölge ayarından gelir.
final class RegionManager: ObservableObject {
    static let shared = RegionManager()

    private static let regionCodeKey = "defaultRegionCode"
    private static let lastUsedRegionCodeKey = "lastUsedRegionCode"
    private let defaults = UserDefaults(suiteName: kAppGroupIdentifier)

    /// Varsayılan ülke; uzantılar yerel numaraları buna göre çözer
    @Published var regionCode: String {
        didSet {
            // Ayarlar'da ülke seçildiğinde (aynı ülke olsa bile) formlar bu ülkeyle başlasın
            lastUsedRegionCode = regionCode
            guard regionCode != oldValue else { return }
            persist()
        }
    }

    /// Numara formlarında en son seçilen ülke; formlar bununla açılır
    @Published var lastUsedRegionCode: String {
        didSet {
            guard lastUsedRegionCode != oldValue else { return }
            defaults?.set(lastUsedRegionCode, forKey: Self.lastUsedRegionCodeKey)
        }
    }

    private init() {
        let saved = defaults?.string(forKey: Self.regionCodeKey)
        let initialRegion: String
        if let saved, PhoneNumberService.shared.region(for: saved) != nil {
            initialRegion = saved
        } else {
            initialRegion = PhoneNumberService.shared.deviceRegionCode()
        }
        regionCode = initialRegion

        let savedLastUsed = defaults?.string(forKey: Self.lastUsedRegionCodeKey)
        if let savedLastUsed, PhoneNumberService.shared.region(for: savedLastUsed) != nil {
            lastUsedRegionCode = savedLastUsed
        } else {
            lastUsedRegionCode = initialRegion
        }
        persist()
    }

    var region: PhoneRegion? {
        PhoneNumberService.shared.region(for: regionCode)
    }

    /// Kullanıcı girdisini seçilen ülkeye (verilmezse varsayılan ülkeye) göre çözer
    func entry(for input: String, regionCode: String? = nil) -> Result<PhoneNumberEntry, PhoneNumberEntryError> {
        PhoneNumberService.shared.entry(for: input, regionCode: regionCode ?? self.regionCode)
    }

    /// Hata için kullanıcıya gösterilecek, yerelleştirilmiş mesaj
    func message(for error: PhoneNumberEntryError, regionCode: String? = nil) -> String {
        switch error {
        case .empty:
            return NSLocalizedString("enter.phone.number", comment: "")
        case .invalidNumber:
            let code = regionCode ?? self.regionCode
            let name = LanguageManager.shared.locale.localizedString(forRegionCode: code) ?? code
            return String(format: NSLocalizedString("number.invalid.for.country", comment: ""), name)
        }
    }

    /// Kaydı ve uzantıların okuduğu arama bilgisini günceller
    private func persist() {
        defaults?.set(regionCode, forKey: Self.regionCodeKey)
        PhoneNumberService.shared.dialingRegion(for: regionCode)?.save(to: defaults)
    }
}
