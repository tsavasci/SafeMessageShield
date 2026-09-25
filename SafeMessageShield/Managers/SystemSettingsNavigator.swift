//
//  SystemSettingsNavigator.swift
//  SafeMessageShield
//

import CallKit
import UIKit

/// Kullanıcıyı uzantıları etkinleştireceği doğru iOS Ayarlar ekranına yönlendirir.
enum SystemSettingsNavigator {
    static let callDirectoryExtensionIdentifier = "tsavasci.SafeMessageShield.CallDirectoryExtension"

    /// Ayarlar → Uygulamalar → Telefon → Arama Engelleme ve Kimlik Belirleme ekranını açar.
    /// CallKit ekranı açamazsa uygulamanın kendi Ayarlar sayfasına düşer.
    @MainActor
    static func openCallBlockingSettings() {
        CXCallDirectoryManager.sharedInstance.openSettings { error in
            if let error {
                print("⚠️ Arama engelleme ayarları açılamadı: \(error.localizedDescription)")
                DispatchQueue.main.async { openAppSettings() }
            }
        }
    }

    /// Mesaj filtresi ayarına doğrudan bağlantı veren herkese açık bir API yok;
    /// bu yüzden iOS Ayarlar'da uygulamanın sayfası açılır, kullanıcı talimatları izler.
    @MainActor
    static func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    /// Arama engelleme uzantısının iOS Ayarlar'da açık olup olmadığını sistemden okur.
    /// Durum belirlenemezse `nil` döner.
    static func callBlockingEnabledStatus() async -> Bool? {
        await withCheckedContinuation { continuation in
            CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(
                withIdentifier: callDirectoryExtensionIdentifier
            ) { status, error in
                guard error == nil else {
                    continuation.resume(returning: nil)
                    return
                }
                switch status {
                case .enabled: continuation.resume(returning: true)
                case .disabled: continuation.resume(returning: false)
                default: continuation.resume(returning: nil)
                }
            }
        }
    }
}
