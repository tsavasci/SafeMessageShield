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
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

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
