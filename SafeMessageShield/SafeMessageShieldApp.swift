//
//  SafeMessageShieldApp.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI
import SwiftData

@main
struct SafeMessageShieldApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BlockedNumber.self,
            AllowedNumber.self,
            FilterRule.self,
            NumberFilterRule.self,
        ])
        
        // App Group konteynerini güvenli şekilde al, yoksa Application Support fallback kullan
        let modelURL: URL = {
            if let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kAppGroupIdentifier) {
                return appGroupURL.appendingPathComponent("SafeMessageShield.sqlite")
            }
            let fallbackDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
                ?? URL(fileURLWithPath: NSTemporaryDirectory())
            try? FileManager.default.createDirectory(at: fallbackDir, withIntermediateDirectories: true)
            return fallbackDir.appendingPathComponent("SafeMessageShield.sqlite")
        }()
        
        let modelConfiguration = ModelConfiguration(schema: schema, url: modelURL, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Model yüklenemezse kullanıcı deneyimini bozmamak için in-memory yedeğe geç
            do {
                let memoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                return try ModelContainer(for: schema, configurations: [memoryConfig])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .appLanguageEnvironment()
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "safemessageshield" else { return }

        // Parse: safemessageshield://mark-not-junk?sender=08501234567
        if url.host == "mark-not-junk" {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let queryItems = components.queryItems,
               let senderParam = queryItems.first(where: { $0.name == "sender" })?.value
            {
                // Gönderen yerel biçimde gelmiş olabilir; varsayılan ülkeye göre çöz
                let value: String
                if case .success(let entry) = RegionManager.shared.entry(for: senderParam) {
                    value = entry.storageValue
                } else {
                    value = senderParam
                }
                if !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    let context = sharedModelContainer.mainContext
                    DataManager.shared.addAllowedNumber(value, modelContext: context)
                    DataManager.shared.removeBlockedNumber(value, modelContext: context)
                }
            }
        }
    }
}
