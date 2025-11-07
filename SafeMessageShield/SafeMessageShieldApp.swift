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
        ])
        
        // App Group konteynerini kullan
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kAppGroupIdentifier) else {
            fatalError("App Group container bulunamadı. Capabilities ayarlarını kontrol edin.")
        }
        
        let modelURL = appGroupURL.appendingPathComponent("SafeMessageShield.sqlite")
        let modelConfiguration = ModelConfiguration(schema: schema, url: modelURL, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
