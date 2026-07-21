//
//  FilterByNumberView.swift
//  SafeMessageShield
//
//  Created by GitHub Copilot on behalf of user.
//

import SwiftUI
import SwiftData

struct FilterByNumberView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NumberFilterRule.addedAt, order: .reverse) private var numberRules: [NumberFilterRule]

    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            ShieldSurface {
                VStack {
                if numberRules.isEmpty {
                    ShieldEmptyState(
                        title: NSLocalizedString("no.number.rules.title", comment: ""),
                        message: NSLocalizedString("no.number.rules.message", comment: ""),
                        systemImage: "phone.arrow.down.left",
                        color: ShieldTheme.Colors.secondary
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(numberRules) { rule in
                            FilterNumberRow(rule: rule)
                                .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            }
            .navigationTitle(NSLocalizedString("number.filter.rules", comment: ""))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("done", comment: "Done")) {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddNumberFilterRuleView()
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let rule = numberRules[index]
                DataManager.shared.removeNumberFilterRule(ruleType: rule.ruleType, value: rule.value)
                modelContext.delete(rule)
            }
        }
    }
}

struct FilterNumberRow: View {
    let rule: NumberFilterRule

    var ruleTypeText: String {
        switch rule.ruleType {
        case "prefix":
            return NSLocalizedString("rule.type.prefix", comment: "Prefix")
        case "suffix":
            return NSLocalizedString("rule.type.suffix", comment: "Suffix")
        case "contains":
            return NSLocalizedString("rule.type.contains", comment: "Contains")
        default:
            return rule.ruleType.capitalized
        }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(rule.value)
                    .font(.headline)
                    .monospaced()
                Text(ruleTypeText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

struct AddNumberFilterRuleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var ruleType: String = "prefix"
    @State private var value: String = ""

    var body: some View {
        NavigationStack {
            ShieldSurface {
                Form {
                    Section {
                        Picker(NSLocalizedString("rule.type", comment: "Rule Type"), selection: $ruleType) {
                            Text(NSLocalizedString("rule.type.prefix", comment: "Prefix")).tag("prefix")
                            Text(NSLocalizedString("rule.type.suffix", comment: "Suffix")).tag("suffix")
                            Text(NSLocalizedString("rule.type.contains", comment: "Contains")).tag("contains")
                        }
                        .pickerStyle(.segmented)

                        TextField(NSLocalizedString("enter.value.numbers.only", comment: "Enter value (numbers only)"), text: $value)
                            .keyboardType(.numberPad)
                    } header: {
                        Text(NSLocalizedString("rule.details", comment: "Rule Details"))
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(NSLocalizedString("add.number.rule", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("cancel", comment: "")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("add", comment: "")) {
                        addRule()
                    }
                    .disabled(value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined().count < 3)
                }
            }
        }
    }

    private func addRule() {
        let cleanedValue = value.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        guard !cleanedValue.isEmpty else { return }

        guard cleanedValue.count >= 3 else { return }
        DataManager.shared.addNumberFilterRule(
            ruleType: ruleType,
            value: cleanedValue,
            modelContext: modelContext
        )
        
        dismiss()
    }
}

#Preview {
    FilterByNumberView()
}
