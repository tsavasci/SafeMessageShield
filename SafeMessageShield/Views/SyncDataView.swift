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
                Section(header: Text(NSLocalizedString("sync.status", comment: ""))) {
                    Text(String(format: NSLocalizedString("sync.allowed.count", comment: ""), allowedModels.count))
                    Text(String(format: NSLocalizedString("sync.blocked.count", comment: ""), blockedModels.count))
                    Text(String(format: NSLocalizedString("sync.filter.rules.count", comment: ""), ruleModels.count))
                    Text(String(format: NSLocalizedString("sync.number.filter.rules.count", comment: ""), numberRuleModels.count))
                }

                Section {
                    Button(action: doSync) {
                        HStack {
                            Spacer()
                            Text(NSLocalizedString("sync.to.app.group", comment: ""))
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
            .navigationTitle(NSLocalizedString("sync.data.title", comment: ""))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "")) { dismiss() }
                }
            }
        }
    }

    private func doSync() {
        DataManager.shared.syncFromSwiftData(allowed: allowedModels, blocked: blockedModels, filterRules: ruleModels, numberRules: numberRuleModels)
        message = NSLocalizedString("sync.completed.message", comment: "")

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
