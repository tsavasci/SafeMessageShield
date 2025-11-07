//
//  FilterCustomizationView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 7.11.2025.
//

import SwiftUI
import SwiftData

struct FilterCustomizationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var filterRules: [FilterRule]
    
    @State private var showingAddRule = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if filterRules.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        
                        Text(NSLocalizedString("no.filter.rules.title", comment: ""))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(NSLocalizedString("no.filter.rules.message", comment: ""))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filterRules) { rule in
                            FilterRuleRow(rule: rule)
                        }
                        .onDelete(perform: deleteRules)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("filter.customization", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddRule = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddRule) {
                AddFilterRuleView()
            }
        }
    }
    
    private func deleteRules(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let rule = filterRules[index]
                DataManager.shared.removeFilterRule(keyword: rule.keyword)
                modelContext.delete(rule)
            }
        }
    }
}

// MARK: - Filter Rule Row
struct FilterRuleRow: View {
    let rule: FilterRule
    
    var category: MessageCategory? {
        MessageCategory(rawValue: rule.category)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: category?.icon ?? "questionmark.circle")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(rule.keyword)
                    .font(.headline)
                
                Text(category?.localizedName ?? rule.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Add Filter Rule View
struct AddFilterRuleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var keyword = ""
    @State private var selectedCategory: MessageCategory = .promotionalOffers
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(NSLocalizedString("filter.keyword.placeholder", comment: ""), text: $keyword)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text(NSLocalizedString("filter.keyword", comment: ""))
                } footer: {
                    Text(NSLocalizedString("filter.keyword.footer", comment: ""))
                }
                
                Section {
                    Picker(NSLocalizedString("filter.category", comment: ""), selection: $selectedCategory) {
                        // Transactional kategoriler
                        Section(header: Text(NSLocalizedString("category.group.transactional", comment: ""))) {
                            ForEach([
                                MessageCategory.transactionalFinance,
                                .transactionalOrders,
                                .transactionalReminders,
                                .transactionalHealth,
                                .transactionalWeather,
                                .transactionalCarrier,
                                .transactionalRewards,
                                .transactionalPublicServices,
                                .transactionalOthers
                            ]) { category in
                                HStack {
                                    Image(systemName: category.icon)
                                    Text(category.localizedName)
                                }
                                .tag(category)
                            }
                        }
                        
                        // Promotional kategoriler
                        Section(header: Text(NSLocalizedString("category.group.promotional", comment: ""))) {
                            ForEach([
                                MessageCategory.promotionalOffers,
                                .promotionalCoupons,
                                .promotionalOthers
                            ]) { category in
                                HStack {
                                    Image(systemName: category.icon)
                                    Text(category.localizedName)
                                }
                                .tag(category)
                            }
                        }
                    }
                } header: {
                    Text(NSLocalizedString("filter.category", comment: ""))
                }
                
                Section {
                    HStack {
                        Image(systemName: selectedCategory.icon)
                            .foregroundStyle(.blue)
                        Text(selectedCategory.localizedName)
                            .font(.headline)
                    }
                    
                    Text(NSLocalizedString("filter.rule.explanation", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(NSLocalizedString("add.filter.rule", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("cancel", comment: "")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("add", comment: "")) {
                        addRule()
                    }
                    .disabled(keyword.isEmpty)
                }
            }
            .alert(NSLocalizedString("error", comment: ""), isPresented: $showError) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func addRule() {
        let cleanedKeyword = keyword.trimmingCharacters(in: .whitespaces).lowercased()
        
        guard !cleanedKeyword.isEmpty else {
            errorMessage = NSLocalizedString("invalid.keyword", comment: "")
            showError = true
            return
        }
        
        // SwiftData'ya kaydet
        let filterRule = FilterRule(
            keyword: cleanedKeyword,
            category: selectedCategory.rawValue
        )
        modelContext.insert(filterRule)
        
        // UserDefaults'a da kaydet (Extension erişimi için)
        DataManager.shared.addFilterRule(keyword: cleanedKeyword, category: selectedCategory.rawValue)
        
        dismiss()
    }
}

#Preview {
    FilterCustomizationView()
        .modelContainer(for: FilterRule.self, inMemory: true)
}
