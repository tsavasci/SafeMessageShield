//
//  ManagementView.swift
//  SafeMessageShield
//

import CallKit
import Contacts
import SwiftData
import SwiftUI

struct ManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var blockedNumbers: [BlockedNumber]
    @Query private var allowedNumbers: [AllowedNumber]
    @Query private var filterRules: [FilterRule]
    @Query(sort: \NumberFilterRule.addedAt, order: .reverse) private var numberRules: [NumberFilterRule]
    @ObservedObject private var languageManager = LanguageManager.shared

    @State private var selectedSegment: ManagementSegment = .blocked
    @State private var showingAddBlocked = false
    @State private var showingAddAllowed = false
    @State private var showingAddKeywordRule = false
    @State private var showingAddNumberRule = false
    @State private var pendingDeletion: PendingDeletion?

    var body: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        headerCard
                        segmentPicker
                        selectedContent
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle(NSLocalizedString("management.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: showAddSheet) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                    .accessibilityLabel(NSLocalizedString("add", comment: ""))
                }
            }
            .sheet(isPresented: $showingAddBlocked) {
                AddBlockedSenderView()
                    .appLanguageEnvironment()
            }
            .sheet(isPresented: $showingAddAllowed) {
                AddAllowedNumberView()
                    .appLanguageEnvironment()
            }
            .sheet(isPresented: $showingAddKeywordRule) {
                AddFilterRuleView()
                    .appLanguageEnvironment()
            }
            .sheet(isPresented: $showingAddNumberRule) {
                AddNumberFilterRuleView()
                    .appLanguageEnvironment()
            }
            .alert(
                NSLocalizedString("delete.confirm.title", comment: ""),
                isPresented: Binding(
                    get: { pendingDeletion != nil },
                    set: { if !$0 { pendingDeletion = nil } }
                ),
                presenting: pendingDeletion
            ) { deletion in
                Button(NSLocalizedString("delete", comment: ""), role: .destructive) {
                    deletion.perform()
                    pendingDeletion = nil
                }
                Button(NSLocalizedString("cancel", comment: ""), role: .cancel) {
                    pendingDeletion = nil
                }
            } message: { deletion in
                Text(String(format: NSLocalizedString("delete.confirm.message", comment: ""), deletion.title))
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
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("management.title", comment: ""))
                        .font(.headline.weight(.semibold))
                    Text(NSLocalizedString("management.subtitle", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
        }
    }

    private var segmentPicker: some View {
        ShieldSegmentedPicker(
            items: ManagementSegment.allCases.map {
                (selection: $0, title: $0.title, systemImage: $0.systemImage)
            },
            selection: $selectedSegment
        )
    }

    @ViewBuilder
    private var selectedContent: some View {
        switch selectedSegment {
        case .blocked:
            listCard(
                title: NSLocalizedString("management.blocked.title", comment: ""),
                count: blockedNumbers.count,
                emptyTitle: NSLocalizedString("no.blocked.title", comment: ""),
                emptyMessage: NSLocalizedString("no.blocked.message.manage", comment: ""),
                emptyIcon: "phone.down.circle",
                emptyColor: ShieldTheme.Colors.danger
            ) {
                ForEach(blockedNumbers) { number in
                    managementRow(
                        title: PhoneNumberService.shared.displayString(forStored: number.phoneNumber),
                        subtitle: languageManager.formatted(number.addedAt, date: .abbreviated, time: .omitted),
                        systemImage: "minus.circle.fill",
                        color: ShieldTheme.Colors.danger
                    ) {
                        deleteBlocked(number)
                    }
                }
            }

        case .allowed:
            listCard(
                title: NSLocalizedString("management.allowed.title", comment: ""),
                count: allowedNumbers.count,
                emptyTitle: NSLocalizedString("no.allowed.title", comment: ""),
                emptyMessage: NSLocalizedString("no.allowed.message", comment: ""),
                emptyIcon: "checkmark.shield",
                emptyColor: ShieldTheme.Colors.success
            ) {
                ForEach(allowedNumbers) { number in
                    managementRow(
                        title: PhoneNumberService.shared.displayString(forStored: number.phoneNumber),
                        subtitle: languageManager.formatted(number.addedAt, date: .abbreviated, time: .omitted),
                        systemImage: "checkmark.circle.fill",
                        color: ShieldTheme.Colors.success
                    ) {
                        deleteAllowed(number)
                    }
                }
            }

        case .keywords:
            listCard(
                title: NSLocalizedString("management.keywords.title", comment: ""),
                count: filterRules.count,
                emptyTitle: NSLocalizedString("no.filter.rules.title", comment: ""),
                emptyMessage: NSLocalizedString("no.filter.rules.message", comment: ""),
                emptyIcon: "slider.horizontal.3",
                emptyColor: ShieldTheme.Colors.primary
            ) {
                ForEach(filterRules) { rule in
                    let category = MessageCategory(rawValue: rule.category)
                    managementRow(
                        title: rule.keyword,
                        subtitle: category?.localizedName ?? rule.category,
                        systemImage: category?.icon ?? "tag.fill",
                        color: ShieldTheme.Colors.primary
                    ) {
                        deleteKeywordRule(rule)
                    }
                }
            }

        case .numbers:
            listCard(
                title: NSLocalizedString("management.number.rules.title", comment: ""),
                count: numberRules.count,
                emptyTitle: NSLocalizedString("no.number.rules.title", comment: ""),
                emptyMessage: NSLocalizedString("no.number.rules.message", comment: ""),
                emptyIcon: "phone.arrow.down.left",
                emptyColor: ShieldTheme.Colors.secondary
            ) {
                ForEach(numberRules) { rule in
                    managementRow(
                        title: rule.value,
                        subtitle: ruleTypeText(rule.ruleType),
                        systemImage: "number.circle.fill",
                        color: ShieldTheme.Colors.secondary
                    ) {
                        deleteNumberRule(rule)
                    }
                }
            }
        }
    }

    private func listCard<Rows: View>(
        title: String,
        count: Int,
        emptyTitle: String,
        emptyMessage: String,
        emptyIcon: String,
        emptyColor: Color,
        @ViewBuilder rows: () -> Rows
    ) -> some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(title)
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Text("\(count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                }

                if count == 0 {
                    ShieldEmptyState(
                        title: emptyTitle,
                        message: emptyMessage,
                        systemImage: emptyIcon,
                        color: emptyColor
                    )
                } else {
                    VStack(spacing: 0) {
                        rows()
                    }
                }
            }
        }
    }

    private func managementRow(title: String, subtitle: String, systemImage: String, color: Color, deleteAction: @escaping () -> Void) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(color)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Button(role: .destructive) {
                // Silmeden önce kullanıcıdan onay al
                pendingDeletion = PendingDeletion(title: title, perform: deleteAction)
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
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.leading, 40)
        }
    }

    private func showAddSheet() {
        switch selectedSegment {
        case .blocked:
            showingAddBlocked = true
        case .allowed:
            showingAddAllowed = true
        case .keywords:
            showingAddKeywordRule = true
        case .numbers:
            showingAddNumberRule = true
        }
    }

    private func deleteBlocked(_ number: BlockedNumber) {
        DataManager.shared.removeBlockedNumber(number.phoneNumber)
        modelContext.delete(number)
        reloadCallDirectory()
    }

    private func deleteAllowed(_ number: AllowedNumber) {
        DataManager.shared.removeAllowedNumber(number.phoneNumber)
        modelContext.delete(number)
    }

    private func deleteKeywordRule(_ rule: FilterRule) {
        DataManager.shared.removeFilterRule(keyword: rule.keyword)
        modelContext.delete(rule)
    }

    private func deleteNumberRule(_ rule: NumberFilterRule) {
        DataManager.shared.removeNumberFilterRule(ruleType: rule.ruleType, value: rule.value)
        modelContext.delete(rule)
    }

    private func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(
            withIdentifier: "tsavasci.SafeMessageShield.CallDirectoryExtension"
        ) { _ in }
    }

    private func ruleTypeText(_ ruleType: String) -> String {
        switch ruleType {
        case "prefix":
            return NSLocalizedString("rule.type.prefix", comment: "")
        case "suffix":
            return NSLocalizedString("rule.type.suffix", comment: "")
        case "contains":
            return NSLocalizedString("rule.type.contains", comment: "")
        default:
            return ruleType.capitalized
        }
    }
}

private struct AddBlockedSenderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var sender = ""
    @State private var reason = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var showingContactPicker = false
    // Ülke kodu olmadan yazılan numaraların ait olduğu ülke; en son seçilen ülkeyle başlar
    @State private var regionCode = RegionManager.shared.lastUsedRegionCode

    var body: some View {
        NavigationStack {
            ShieldSurface {
                Form {
                    Section {
                        HStack {
                            // Gönderici adı yazılırken ülke seçimi anlamsız, gizle
                            if sender.rangeOfCharacter(from: .letters) == nil {
                                CountryCodeButton(regionCode: $regionCode)
                                    // Seçimi bir sonraki form için hatırla
                                    .onChange(of: regionCode) { _, newValue in
                                        RegionManager.shared.lastUsedRegionCode = newValue
                                    }
                            }

                            TextField(NSLocalizedString("phone.number.or.sender", comment: ""), text: $sender, axis: .vertical)
                                .lineLimit(1...2)
                                .keyboardType(.default)
                                .textContentType(.telephoneNumber)
                                .textInputAutocapitalization(.characters)

                            Button(action: checkContactsPermission) {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.title2)
                                    .foregroundStyle(ShieldTheme.Colors.primary)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(NSLocalizedString("menu.contacts", comment: ""))
                        }

                        TextField(NSLocalizedString("reason.optional", comment: ""), text: $reason)
                    } header: {
                        Text(NSLocalizedString("number.info", comment: ""))
                    } footer: {
                        Text(NSLocalizedString("number.info.footer.extended", comment: ""))
                    }

                    Section {
                        Button(action: addBlockedSender) {
                            Label(NSLocalizedString("block.number", comment: ""), systemImage: "plus.circle.fill")
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(sender.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .foregroundStyle(ShieldTheme.Colors.danger)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(NSLocalizedString("add.number", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("cancel", comment: "")) {
                        dismiss()
                    }
                }
            }
            .alert(NSLocalizedString("error", comment: ""), isPresented: $showingError) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showingContactPicker) {
                ContactNumberSelectionView { phoneNumber in
                    sender = phoneNumber
                    showingContactPicker = false
                } onCancel: {
                    showingContactPicker = false
                }
                .appLanguageEnvironment()
            }
        }
    }

    private func addBlockedSender() {
        // Numara, kısa numara veya gönderici adı olarak çöz; numarayı seçili ülkeye göre doğrula
        let entry: PhoneNumberEntry
        switch RegionManager.shared.entry(for: sender, regionCode: regionCode) {
        case .success(let value):
            entry = value
        case .failure(let error):
            errorMessage = RegionManager.shared.message(for: error, regionCode: regionCode)
            showingError = true
            return
        }

        if DataManager.shared.isNumberBlocked(entry.storageValue) {
            errorMessage = NSLocalizedString("number.already.blocked", comment: "")
            showingError = true
            return
        }

        DataManager.shared.addBlockedNumber(entry.storageValue, reason: reason, modelContext: modelContext)
        reloadCallDirectory()
        dismiss()
    }

    private func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(
            withIdentifier: "tsavasci.SafeMessageShield.CallDirectoryExtension"
        ) { _ in }
    }

    private func checkContactsPermission() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        showingContactPicker = true
                    } else {
                        errorMessage = NSLocalizedString("contacts.permission.denied", comment: "")
                        showingError = true
                    }
                }
            }
        case .authorized, .limited:
            showingContactPicker = true
        case .denied, .restricted:
            errorMessage = NSLocalizedString("contacts.permission.denied", comment: "")
            showingError = true
        @unknown default:
            errorMessage = NSLocalizedString("contacts.permission.error", comment: "")
            showingError = true
        }
    }
}

private struct ContactNumberSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let onSelect: (String) -> Void
    let onCancel: () -> Void

    @State private var contacts: [ContactNumberOption] = []
    @State private var searchText = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ShieldSurface {
                Group {
                    if let errorMessage {
                        ShieldEmptyState(
                            title: NSLocalizedString("error", comment: ""),
                            message: errorMessage,
                            systemImage: "exclamationmark.triangle.fill",
                            color: ShieldTheme.Colors.warning
                        )
                    } else if filteredContacts.isEmpty {
                        ShieldEmptyState(
                            title: NSLocalizedString("management.contacts.empty.title", comment: ""),
                            message: NSLocalizedString("management.contacts.empty.message", comment: ""),
                            systemImage: "person.crop.circle.badge.questionmark",
                            color: ShieldTheme.Colors.primary
                        )
                    } else {
                        List(filteredContacts) { contact in
                            Button {
                                onSelect(contact.phoneNumber)
                                dismiss()
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(ShieldTheme.Colors.primary)
                                        .frame(width: 30)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(contact.displayName)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.primary)
                                        Text(contact.phoneNumber)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()
                                }
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("menu.contacts", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("cancel", comment: "")) {
                        onCancel()
                        dismiss()
                    }
                }
            }
            .task {
                await loadContacts()
            }
        }
    }

    private var filteredContacts: [ContactNumberOption] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return contacts }
        return contacts.filter {
            $0.displayName.localizedCaseInsensitiveContains(query)
                || $0.phoneNumber.localizedCaseInsensitiveContains(query)
        }
    }

    private func loadContacts() async {
        let unknownSender = NSLocalizedString("unknown.sender", comment: "")
        do {
            let results = try await Task.detached(priority: .userInitiated) {
                try Self.fetchContactNumbers(unknownSender: unknownSender)
            }.value
            contacts = results
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    nonisolated private static func fetchContactNumbers(unknownSender: String) throws -> [ContactNumberOption] {
        var results: [ContactNumberOption] = []
        let store = CNContactStore()
        let keys: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        let request = CNContactFetchRequest(keysToFetch: keys)
        request.sortOrder = .userDefault

        try store.enumerateContacts(with: request) { contact, _ in
            let name = displayName(for: contact, unknownSender: unknownSender)
            for phone in contact.phoneNumbers {
                let phoneNumber = phone.value.stringValue
                guard !phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
                results.append(ContactNumberOption(displayName: name, phoneNumber: phoneNumber))
            }
        }

        return results
    }

    nonisolated private static func displayName(for contact: CNContact, unknownSender: String) -> String {
        let fullName = [contact.givenName, contact.familyName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        if !fullName.isEmpty { return fullName }

        let organization = contact.organizationName.trimmingCharacters(in: .whitespacesAndNewlines)
        return organization.isEmpty ? unknownSender : organization
    }
}

/// Onay bekleyen silme işlemi: gösterilecek başlık ve onaylanınca çalışacak eylem
private struct PendingDeletion {
    let title: String
    let perform: () -> Void
}

private struct ContactNumberOption: Identifiable, Sendable {
    let id = UUID()
    let displayName: String
    let phoneNumber: String
}

private enum ManagementSegment: CaseIterable, Hashable {
    case blocked
    case allowed
    case keywords
    case numbers

    var title: String {
        switch self {
        case .blocked:
            return NSLocalizedString("management.segment.blocked", comment: "")
        case .allowed:
            return NSLocalizedString("management.segment.allowed", comment: "")
        case .keywords:
            return NSLocalizedString("management.segment.keywords", comment: "")
        case .numbers:
            return NSLocalizedString("management.segment.numbers", comment: "")
        }
    }

    var systemImage: String {
        switch self {
        case .blocked:
            return "phone.down.fill"
        case .allowed:
            return "checkmark.shield.fill"
        case .keywords:
            return "tag.fill"
        case .numbers:
            return "number.circle.fill"
        }
    }
}

#Preview {
    ManagementView()
        .modelContainer(for: [BlockedNumber.self, AllowedNumber.self, FilterRule.self, NumberFilterRule.self], inMemory: true)
}
