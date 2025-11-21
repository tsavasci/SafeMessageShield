//
//  SyncDataView.swift
//  SafeMessageShield
//

import SwiftUI
import SwiftData

struct SyncDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allowedModels: [AllowedNumber]
    @Query private var blockedModels: [BlockedNumber]
    @Query private var ruleModels: [FilterRule]
    @Query private var numberRuleModels: [NumberFilterRule]

    @Environment(\.dismiss) private var dismiss
    @State private var message = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Sync Status")) {
                    Text("Allowed: \(allowedModels.count)")
                    Text("Blocked: \(blockedModels.count)")
                    Text("Filter rules: \(ruleModels.count)")
                    Text("Number filter rules: \(numberRuleModels.count)")
                }

                Section {
                    Button(action: doSync) {
                        HStack {
                            Spacer()
                            Text("Sync to App Group")
                            Spacer()
                        }
                    }

                    if !message.isEmpty {
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Sync Data")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func doSync() {
        DataManager.shared.syncFromSwiftData(allowed: allowedModels, blocked: blockedModels, filterRules: ruleModels, numberRules: numberRuleModels)
        message = "Synced to App Group UserDefaults. Extensions can now read the data."

        // small delay and dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            dismiss()
        }
    }
}

#Preview {
    SyncDataView()
        .modelContainer(for: AllowedNumber.self, inMemory: true)
}
