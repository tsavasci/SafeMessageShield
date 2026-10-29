//
//  FilterCustomizationView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 7.11.2025.
//

import SwiftUI
import SwiftData

struct FilterCustomizationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var filterRules: [FilterRule]
    @State private var showingAddRule = false
    @State private var pendingDeletion: FilterRule?
    
    var body: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        headerCard
                        rulesList
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle(NSLocalizedString("filter.customization", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("cancel", comment: "")) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { showingAddRule = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddRule) {
                AddFilterRuleView()
                    .appLanguageEnvironment()
            }
            .alert(
                NSLocalizedString("delete.confirm.title", comment: ""),
                isPresented: Binding(
                    get: { pendingDeletion != nil },
                    set: { if !$0 { pendingDeletion = nil } }
                ),
                presenting: pendingDeletion
            ) { rule in
                Button(NSLocalizedString("delete", comment: ""), role: .destructive) {
                    deleteRule(rule)
                    pendingDeletion = nil
                }
                Button(NSLocalizedString("cancel", comment: ""), role: .cancel) {
                    pendingDeletion = nil
                }
            } message: { rule in
                Text(String(format: NSLocalizedString("delete.confirm.message", comment: ""), rule.keyword))
            }
        }
    }

    private var headerCard: some View {
        ShieldCard {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(ShieldTheme.Colors.primaryGradient)
                        .frame(width: 52, height: 52)
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("filter.customization", comment: ""))
                        .font(.headline.weight(.semibold))
                    Text(NSLocalizedString("filter.explanation", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
        }
    }

    private var rulesList: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(NSLocalizedString("filter.rules", comment: ""))
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Text("\(filterRules.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                }

                if filterRules.isEmpty {
                    ShieldEmptyState(
                        title: NSLocalizedString("no.filter.rules.title", comment: ""),
                        message: NSLocalizedString("no.filter.rules.message", comment: ""),
                        systemImage: "slider.horizontal.3",
                        color: ShieldTheme.Colors.primary
                    )
                } else {
                    VStack(spacing: 0) {
                        ForEach(filterRules) { rule in
                            let category = MessageCategory(rawValue: rule.category)
                            HStack(spacing: 12) {
                                Image(systemName: category?.icon ?? "tag.fill")
                                    .font(.headline)
                                    .foregroundStyle(ShieldTheme.Colors.primary)
                                    .frame(width: 28)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(rule.keyword)
                                        .font(.subheadline.weight(.semibold))
                                    Text(category?.localizedName ?? rule.category)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Button(role: .destructive) {
                                    pendingDeletion = rule
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(ShieldTheme.Colors.danger)
                                        .frame(width: 34, height: 34)
                                        .background(ShieldTheme.Colors.danger.opacity(0.10), in: Circle())
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel(NSLocalizedString("delete", comment: ""))
                            }
                            .padding(.vertical, 10)

                            if rule.id != filterRules.last?.id {
                                Divider().padding(.leading, 40)
                            }
                        }
                    }
                }
            }
        }
    }

    private func deleteRule(_ rule: FilterRule) {
        DataManager.shared.removeFilterRule(keyword: rule.keyword)
        modelContext.delete(rule)
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
            ShieldSurface {
                Form {
                    Section {
                        TextField(NSLocalizedString("keyword.placeholder", comment: ""), text: $keyword)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    } header: {
                        Text(NSLocalizedString("keyword", comment: ""))
                    } footer: {
                        Text(NSLocalizedString("keyword.footer", comment: ""))
                    }
                    
                    Section {
                        Picker(NSLocalizedString("filter.category", comment: ""), selection: $selectedCategory) {
                            Section(header: Text(NSLocalizedString("transactional.messages", comment: ""))) {
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
                            
                            Section(header: Text(NSLocalizedString("promotional.messages", comment: ""))) {
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
                                .foregroundStyle(ShieldTheme.Colors.primary)
                            Text(selectedCategory.localizedName)
                                .font(.headline)
                        }
                        
                        Text(NSLocalizedString("filter.rule.explanation", comment: ""))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .scrollContentBackground(.hidden)
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
        
        // Centralize: let DataManager handle SwiftData insert + UserDefaults update
        DataManager.shared.addFilterRule(keyword: cleanedKeyword, category: selectedCategory.rawValue, modelContext: modelContext)
        
        // Puanlama yöneticisinde pozitif aksiyon kaydet
        StoreReviewManager.shared.recordPositiveAction()
        
        dismiss()
    }
}

#Preview {
    FilterCustomizationView()
        .modelContainer(for: FilterRule.self, inMemory: true)
}
