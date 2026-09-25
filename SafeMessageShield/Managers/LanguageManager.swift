//
//  LanguageManager.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import Foundation
import SwiftUI
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "AppLanguage")
            Bundle.setLanguage(currentLanguage)
            // View'ları yenilemek için tetikleyici
            objectWillChange.send()
        }
    }
    
    let supportedLanguages: [(code: String, name: String, nativeName: String)] = [
        ("tr", "Turkish", "Türkçe"),
        ("en", "English", "English"),
        ("de", "German", "Deutsch"),
        ("fr", "French", "Français"),
        ("es", "Spanish", "Español"),
        ("zh-Hans", "Chinese", "简体中文"),
        ("ar", "Arabic", "العربية"),
        ("ja", "Japanese", "日本語"),
        ("ko", "Korean", "한국어"),
        ("hi", "Hindi", "हिन्दी"),
        ("ru", "Russian", "Русский")
    ]
    
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "AppLanguage") {
            currentLanguage = savedLanguage
        } else {
            // Sistem dilini al
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            currentLanguage = supportedLanguages.contains(where: { $0.code.hasPrefix(systemLanguage) }) ? systemLanguage : "en"
        }
        Bundle.setLanguage(currentLanguage)
    }
    
    /// Uygulama içinde seçilen dile ait locale (tarih/sayı biçimlendirme için)
    var locale: Locale {
        Locale(identifier: currentLanguage)
    }

    /// Arapça gibi sağdan sola yazılan diller için arayüz yönü
    var layoutDirection: LayoutDirection {
        Locale.Language(identifier: currentLanguage).characterDirection == .rightToLeft ? .rightToLeft : .leftToRight
    }

    /// Tarihi cihaz bölgesi yerine uygulama diline göre biçimlendirir
    func formatted(_ date: Date, date dateStyle: Date.FormatStyle.DateStyle, time timeStyle: Date.FormatStyle.TimeStyle) -> String {
        date.formatted(Date.FormatStyle(date: dateStyle, time: timeStyle, locale: locale))
    }
}

/// Seçilen uygulama dilinin locale ve yazı yönünü görünüme uygular
private struct AppLanguageEnvironment: ViewModifier {
    @ObservedObject private var languageManager = LanguageManager.shared

    func body(content: Content) -> some View {
        content
            .environment(\.locale, languageManager.locale)
            .environment(\.layoutDirection, languageManager.layoutDirection)
    }
}

extension View {
    /// Tarih metinleri ve yazı yönü (RTL) uygulama içinde seçilen dili izlesin
    func appLanguageEnvironment() -> some View {
        modifier(AppLanguageEnvironment())
    }
}

extension Bundle {
    private static var bundleKey: UInt8 = 0
    
    class func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    var bundlePath: String? {
        return objc_getAssociatedObject(self, &Bundle.bundleKey) as? String
    }
}

class AnyLanguageBundle: Bundle, @unchecked Sendable {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = bundlePath, let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}
