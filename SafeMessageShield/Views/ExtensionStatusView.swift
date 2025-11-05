//
//  ExtensionStatusView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI
import CallKit

struct ExtensionStatusView: View {
    @State private var blockedNumbers: [String] = []
    @State private var smsFilterCount: Int = 0
    @State private var callBlockCount: Int = 0
    @State private var lastRefresh = Date()
    @State private var appGroupAvailable = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: appGroupAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(appGroupAvailable ? .green : .red)
                        Text("App Group Status")
                        Spacer()
                        Text(appGroupAvailable ? "✅ OK" : "❌ Error")
                            .foregroundStyle(appGroupAvailable ? .green : .red)
                    }
                } header: {
                    Text("Extension Status")
                } footer: {
                    Text("Extensions need App Group to access blocked numbers")
                }
                
                Section {
                    HStack {
                        Text("Blocked Numbers Count:")
                        Spacer()
                        Text("\(blockedNumbers.count)")
                            .bold()
                            .foregroundStyle(blockedNumbers.count > 0 ? .green : .orange)
                    }
                    
                    if blockedNumbers.isEmpty {
                        Text("No blocked numbers found")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    } else {
                        ForEach(blockedNumbers, id: \.self) { number in
                            HStack {
                                Image(systemName: "phone.down.circle")
                                    .foregroundStyle(.red)
                                Text(number)
                                    .font(.system(.body, design: .monospaced))
                            }
                        }
                    }
                } header: {
                    Text("App Group Data")
                } footer: {
                    Text("These numbers are stored in the shared App Group container")
                }
                
                Section {
                    HStack {
                        Text("SMS Filtered:")
                        Spacer()
                        Text("\(smsFilterCount)")
                            .bold()
                    }
                    
                    HStack {
                        Text("Calls Blocked:")
                        Spacer()
                        Text("\(callBlockCount)")
                            .bold()
                    }
                } header: {
                    Text("Statistics")
                }
                
                Section {
                    HStack {
                        Text("Last Refresh:")
                        Spacer()
                        Text(lastRefresh, style: .time)
                            .foregroundStyle(.secondary)
                    }
                } footer: {
                    Text("App Group ID: \(kAppGroupIdentifier)")
                        .font(.caption)
                }
                
                Section {
                    Button(action: { checkStatus() }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh Status")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Button(action: { addTestNumber() }) {
                        HStack {
                            Image(systemName: "number.circle.fill")
                            Text("Add Test Number (1234567890)")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Button(action: { openSMSSettings() }) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Open SMS Settings")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Button(action: { testCallDirectory() }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Reload Call Directory")
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Debug Info")
            .onAppear {
                checkStatus()
            }
        }
    }
    
    private func checkStatus() {
        lastRefresh = Date()
        
        // App Group'tan engellenen numaraları al
        if let userDefaults = UserDefaults(suiteName: kAppGroupIdentifier) {
            appGroupAvailable = true
            blockedNumbers = userDefaults.stringArray(forKey: "blockedNumbers") ?? []
            smsFilterCount = userDefaults.integer(forKey: "smsFilterCount")
            callBlockCount = userDefaults.integer(forKey: "callBlockCount")
            
            NSLog("🛡️ Debug: Blocked numbers in App Group: \(blockedNumbers)")
            NSLog("🛡️ Debug: SMS Filter Count: \(smsFilterCount)")
            NSLog("🛡️ Debug: Call Block Count: \(callBlockCount)")
        } else {
            appGroupAvailable = false
            NSLog("❌ Debug: App Group unavailable!")
        }
    }
    
    private func addTestNumber() {
        let testNumber = "1234567890"
        DataManager.shared.addBlockedNumber(testNumber)
        NSLog("🛡️ Debug: Test number added: \(testNumber)")
        checkStatus()
    }
    
    private func testCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(
            withIdentifier: "tsavasci.SafeMessageShield.CallDirectoryExtension"
        ) { error in
            if let error = error {
                NSLog("❌ Call Directory reload error: \(error.localizedDescription)")
            } else {
                NSLog("✅ Call Directory reloaded successfully")
            }
            
            DispatchQueue.main.async {
                checkStatus()
            }
        }
    }
    
    private func openSMSSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    ExtensionStatusView()
}
