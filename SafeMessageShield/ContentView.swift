//
//  ContentView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import CallKit
import ContactsUI
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var blockedNumbers: [BlockedNumber]
    @Query private var allowedNumbersList: [AllowedNumber]
    @Query private var filterRulesList: [FilterRule]
    @Query private var numberFilterRulesList: [NumberFilterRule]
    @ObservedObject private var languageManager = LanguageManager.shared

    @State private var showingAddNumberSheet = false
    @State private var showingContactPicker = false
    @State private var showingReportedJunk = false
    @State private var showingSuccessAlert = false
    @State private var lastBlockedNumber = ""
    @State private var selectedTab = 0
    @State private var dashboardFilterEnabled = false
    @State private var dashboardJunkCount = 0
    @State private var dashboardCategorizedCount = 0
    @State private var dashboardLastFilterDate: Date?
    @State private var dashboardLastJunkSender: String?
    @State private var dashboardLastSyncDate: Date?

    // ViewModel'i burada da kullanalım
    @StateObject private var contactViewModel = ContactPickerViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            // Ana Liste Sekmesi
            mainListView
                .tabItem {
                    Label(NSLocalizedString("tab.list", comment: ""), systemImage: "list.bullet")
                }
                .tag(0)

            ManagementView()
                .tabItem {
                    Label(
                        NSLocalizedString("management.title", comment: ""),
                        systemImage: "list.bullet.rectangle.portrait")
                }
                .tag(1)

            // Ayarlar Sekmesi
            SettingsView()
                .tabItem {
                    Label(NSLocalizedString("tab.settings", comment: ""), systemImage: "gear")
                }
                .tag(2)
        }
        .onAppear {
            // Perform a one-time sync from SwiftData -> App Group so extensions can read current data
            if !didInitialSync {
                DataManager.shared.syncFromSwiftData(allowed: allowedNumbersList, blocked: blockedNumbers, filterRules: filterRulesList, numberRules: numberFilterRulesList)
                didInitialSync = true
            }
        }
    }

    @State private var didInitialSync = false

    private var mainListView: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        dashboardHeader
                        protectionHeroCard
                        setupChecklistCard
                        metricsGrid
                        quickActionsCard
                        lastJunkCard
                        recentBlockedSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingAddNumberSheet) {
                AddNumberView()
            }
            .sheet(isPresented: $showingContactPicker) {
                ContactPickerView()
                    .environmentObject(contactViewModel)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showingReportedJunk) {
                ReportedJunkView()
            }
            .onAppear {
                refreshDashboard()
            }
            .onChange(of: selectedTab) { _, _ in
                refreshDashboard()
            }
            .onChange(of: contactViewModel.selectedPhoneNumber) { oldValue, newValue in
                // ViewModel'de numara değiştiğinde engelleme işlemini tetikle
                if !newValue.isEmpty && newValue != oldValue {
                    addNumberFromContact(phoneNumber: newValue)
                }
            }
            .alert(NSLocalizedString("success", comment: ""), isPresented: $showingSuccessAlert) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) {}
            } message: {
                Text(
                    String(
                        format: NSLocalizedString("number.blocked.success", comment: ""),
                        lastBlockedNumber))
            }
        }
    }

    private var dashboardHeader: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(NSLocalizedString("app.title", comment: ""))
                    .font(.title2.weight(.bold))
                Text(NSLocalizedString("dashboard.subtitle", comment: ""))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ShieldStatusPill(
                title: dashboardFilterEnabled
                    ? NSLocalizedString("protection.active", comment: "")
                    : NSLocalizedString("protection.inactive", comment: ""),
                color: dashboardFilterEnabled ? ShieldTheme.Colors.success : ShieldTheme.Colors.warning
            )

            Button(action: { selectedTab = 2 }) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private var protectionHeroCard: some View {
        ShieldCard(padding: 20) {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(ShieldTheme.Colors.primaryGradient)
                            .frame(width: 58, height: 58)
                        Image(systemName: dashboardFilterEnabled ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(dashboardFilterEnabled ? NSLocalizedString("protection.active", comment: "") : NSLocalizedString("protection.inactive", comment: ""))
                            .font(.title3.weight(.bold))
                        Text(dashboardFilterEnabled ? NSLocalizedString("dashboard.setup.user.confirmed", comment: "") : NSLocalizedString("enable.from.settings", comment: ""))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()
                }

                HStack(spacing: 10) {
                    Button(action: openSettings) {
                        Label(NSLocalizedString("open.settings", comment: ""), systemImage: "arrow.up.forward.app.fill")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(ShieldTheme.Colors.primaryGradient)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    Button(action: {
                        DataManager.shared.setFilterEnabled(true)
                        refreshDashboard()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .frame(width: 44, height: 44)
                            .background(ShieldTheme.Colors.success.opacity(0.12), in: RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(ShieldTheme.Colors.success)
                }
            }
        }
    }

    private var setupChecklistCard: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(NSLocalizedString("dashboard.setup.title", comment: ""))
                        .font(.headline.weight(.semibold))
                    Spacer()
                    ShieldStatusPill(
                        title: setupCompletedCountText,
                        color: setupCompletedCount == 3 ? ShieldTheme.Colors.success : ShieldTheme.Colors.warning
                    )
                }

                VStack(spacing: 12) {
                    setupRow(
                        title: NSLocalizedString("dashboard.setup.ios.settings", comment: ""),
                        subtitle: NSLocalizedString("dashboard.setup.ios.settings.subtitle", comment: ""),
                        systemImage: "switch.2",
                        isComplete: dashboardFilterEnabled
                    )

                    setupRow(
                        title: NSLocalizedString("dashboard.setup.data.synced", comment: ""),
                        subtitle: lastSyncText,
                        systemImage: "arrow.triangle.2.circlepath",
                        isComplete: dashboardLastSyncDate != nil
                    )

                    setupRow(
                        title: NSLocalizedString("dashboard.setup.filter.activity", comment: ""),
                        subtitle: dashboardLastFilterDate == nil ? NSLocalizedString("dashboard.setup.waiting.activity", comment: "") : filterActivityText,
                        systemImage: "waveform.badge.magnifyingglass",
                        isComplete: dashboardLastFilterDate != nil || dashboardJunkCount > 0 || dashboardCategorizedCount > 0
                    )
                }
            }
        }
    }

    private func setupRow(title: String, subtitle: String, systemImage: String, isComplete: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .font(.headline)
                .foregroundStyle(isComplete ? ShieldTheme.Colors.success : ShieldTheme.Colors.warning)
                .frame(width: 24)

            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
    }

    private var metricsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ShieldMetricCard(
                title: NSLocalizedString("dashboard.blocked.metric", comment: ""),
                value: "\(blockedNumbers.count)",
                systemImage: "phone.down.fill",
                color: ShieldTheme.Colors.danger
            )
            ShieldMetricCard(
                title: NSLocalizedString("dashboard.allowed.metric", comment: ""),
                value: "\(allowedNumbersList.count)",
                systemImage: "checkmark.shield.fill",
                color: ShieldTheme.Colors.success
            )
            ShieldMetricCard(
                title: NSLocalizedString("dashboard.junk.metric", comment: ""),
                value: "\(dashboardJunkCount)",
                systemImage: "message.badge.filled.fill",
                color: ShieldTheme.Colors.warning
            )
            ShieldMetricCard(
                title: NSLocalizedString("dashboard.rules.metric", comment: ""),
                value: "\(filterRulesList.count + numberFilterRulesList.count)",
                systemImage: "slider.horizontal.3",
                color: ShieldTheme.Colors.primary
            )
        }
    }

    private var quickActionsCard: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                Text(NSLocalizedString("dashboard.quick.actions", comment: ""))
                    .font(.headline.weight(.semibold))

                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        ShieldActionButton(title: NSLocalizedString("menu.manual", comment: ""), systemImage: "square.and.pencil", color: ShieldTheme.Colors.danger) {
                            showingAddNumberSheet = true
                        }
                        ShieldActionButton(title: NSLocalizedString("menu.contacts", comment: ""), systemImage: "person.crop.circle.badge.plus", color: ShieldTheme.Colors.primary) {
                            showingContactPicker = true
                        }
                    }

                    HStack(spacing: 10) {
                        ShieldActionButton(title: NSLocalizedString("filter.customization", comment: ""), systemImage: "slider.horizontal.3", color: ShieldTheme.Colors.secondary) {
                            selectedTab = 1
                        }
                        ShieldActionButton(title: NSLocalizedString("dashboard.last.junk", comment: ""), systemImage: "tray.full.fill", color: ShieldTheme.Colors.warning) {
                            showingReportedJunk = true
                        }
                    }
                }
            }
        }
    }

    private var lastJunkCard: some View {
        ShieldCard {
            HStack(spacing: 14) {
                Image(systemName: "waveform.badge.magnifyingglass")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(ShieldTheme.Colors.secondary)
                    .frame(width: 34)

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("dashboard.filter.activity", comment: ""))
                        .font(.headline.weight(.semibold))
                    Text(filterActivityText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
        }
    }

    private var recentBlockedSection: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(NSLocalizedString("tab.list", comment: ""))
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Text(String(format: NSLocalizedString("blocked.count", comment: ""), blockedNumbers.count))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                if blockedNumbers.isEmpty {
                    ShieldEmptyState(
                        title: NSLocalizedString("no.blocked.title", comment: ""),
                        message: NSLocalizedString("no.blocked.message", comment: ""),
                        systemImage: "phone.down.circle",
                        color: ShieldTheme.Colors.primary
                    )
                } else {
                    VStack(spacing: 0) {
                        ForEach(blockedNumbers) { number in
                            HStack(spacing: 12) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(ShieldTheme.Colors.danger)
                                BlockedNumberRow(blockedNumber: number)
                                Spacer()
                                Button(role: .destructive) {
                                    deleteBlockedNumber(number)
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(ShieldTheme.Colors.danger)
                                        .frame(width: 34, height: 34)
                                        .background(ShieldTheme.Colors.danger.opacity(0.10), in: Circle())
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 8)

                            if number.id != blockedNumbers.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }

    private var filterActivityText: String {
        if let dashboardLastJunkSender {
            return String(format: NSLocalizedString("dashboard.last.junk.sender", comment: ""), dashboardLastJunkSender)
        }

        if let dashboardLastFilterDate {
            let formattedDate = dashboardLastFilterDate.formatted(date: .abbreviated, time: .shortened)
            return String(format: NSLocalizedString("dashboard.last.filter.activity", comment: ""), formattedDate)
        }

        if dashboardCategorizedCount > 0 {
            return String(format: NSLocalizedString("dashboard.categorized.messages", comment: ""), dashboardCategorizedCount)
        }

        return NSLocalizedString("dashboard.no.filter.activity", comment: "")
    }

    private var setupCompletedCount: Int {
        var count = 0
        if dashboardFilterEnabled { count += 1 }
        if dashboardLastSyncDate != nil { count += 1 }
        if dashboardLastFilterDate != nil || dashboardJunkCount > 0 || dashboardCategorizedCount > 0 { count += 1 }
        return count
    }

    private var setupCompletedCountText: String {
        String(format: NSLocalizedString("dashboard.setup.progress", comment: ""), setupCompletedCount)
    }

    private var lastSyncText: String {
        guard let dashboardLastSyncDate else {
            return NSLocalizedString("dashboard.setup.no.sync", comment: "")
        }
        let formattedDate = dashboardLastSyncDate.formatted(date: .abbreviated, time: .shortened)
        return String(format: NSLocalizedString("dashboard.setup.last.sync", comment: ""), formattedDate)
    }

    private func addNumberFromContact(phoneNumber: String) {
        // Numarayı temizle: boşluklar, tire, parantez vb. kaldır, sadece rakamlar ve + kalsın
        let cleanedNumber = phoneNumber.replacingOccurrences(
            of: "[^0-9+]", with: "", options: .regularExpression)

        guard !cleanedNumber.isEmpty else { return }

        // Temizlenmiş numara ile kontrol et
        if DataManager.shared.isNumberBlocked(cleanedNumber) {
            print("⚠️ Numara zaten engelli: \(cleanedNumber)")
            return
        }

        // Centralize persistence via DataManager (will insert into SwiftData when modelContext provided)
        DataManager.shared.addBlockedNumber(cleanedNumber, modelContext: modelContext)

        // Call Directory Extension'ı güncelle
        reloadCallDirectory()

        // Geri bildirim için
        lastBlockedNumber = cleanedNumber
        showingSuccessAlert = true

        // ViewModel'i sıfırla
        contactViewModel.selectedPhoneNumber = ""
    }

    private func deleteNumbers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let number = blockedNumbers[index]
                deleteBlockedNumber(number)
            }
        }
    }

    private func deleteBlockedNumber(_ number: BlockedNumber) {
        DataManager.shared.removeBlockedNumber(number.phoneNumber)
        modelContext.delete(number)
        reloadCallDirectory()
    }

    private func refreshDashboard() {
        dashboardFilterEnabled = DataManager.shared.isFilterEnabled()
        dashboardJunkCount = DataManager.shared.smsJunkCount()
        dashboardCategorizedCount = DataManager.shared.smsCategorizedCount()
        dashboardLastFilterDate = DataManager.shared.lastSMSFilterDate()
        dashboardLastJunkSender = DataManager.shared.lastJunkSender()
        dashboardLastSyncDate = DataManager.shared.lastAppGroupSyncDate()
    }

    private func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(
            withIdentifier: "tsavasci.SafeMessageShield.CallDirectoryExtension"
        ) { error in
            DispatchQueue.main.async {
                DataManager.shared.recordCallDirectoryReloadError(error)
            }
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Status Card
struct StatusCard: View {
    @State private var isFilterEnabled = false
    @State private var showInstructions = false
    @State private var callDirectoryError: String?

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(
                    systemName: isFilterEnabled
                        ? "checkmark.shield.fill" : "exclamationmark.shield.fill"
                )
                .font(.system(size: 40))
                .foregroundStyle(isFilterEnabled ? .green : .orange)

                VStack(alignment: .leading, spacing: 4) {
                    Text(
                        isFilterEnabled
                            ? NSLocalizedString("protection.active", comment: "")
                            : NSLocalizedString("protection.inactive", comment: "")
                    )
                    .font(.headline)
                    Text(
                        isFilterEnabled
                            ? NSLocalizedString("sms.filtering", comment: "")
                            : NSLocalizedString("enable.from.settings", comment: "")
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer()

                Button(action: { checkFilterStatus() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundStyle(.blue)
                }
            }

            if !isFilterEnabled {
                Button(action: { showInstructions.toggle() }) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text(
                            showInstructions
                                ? NSLocalizedString("hide.instructions", comment: "")
                                : NSLocalizedString("how.to.enable", comment: ""))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                if showInstructions {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(NSLocalizedString("sms.filter.title", comment: ""))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(NSLocalizedString("sms.filter.instruction", comment: ""))
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Divider()

                        Text(NSLocalizedString("call.block.title", comment: ""))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(NSLocalizedString("call.block.instruction", comment: ""))
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Button(action: openSettings) {
                            HStack {
                                Spacer()
                                Image(systemName: "gear")
                                Text(NSLocalizedString("open.settings", comment: ""))
                                Spacer()
                            }
                            .padding(8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }

                        Button(action: { markAsEnabled() }) {
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark.circle")
                                Text(NSLocalizedString("extensions.enabled", comment: ""))
                                Spacer()
                            }
                            .padding(8)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                }
            } else {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text(NSLocalizedString("extensions.active", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if let callDirectoryError {
                Text(callDirectoryError)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            checkFilterStatus()
        }
    }

    private func checkFilterStatus() {
        // Message Filter durumu API ile okunamıyor. Kullanıcı onayını, CallKit'in
        // gerçek etkinlik durumuyla birlikte değerlendir.
        let messageFilterConfirmed = DataManager.shared.isFilterEnabled()
        callDirectoryError = DataManager.shared.lastCallDirectoryError()
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(
            withIdentifier: "tsavasci.SafeMessageShield.CallDirectoryExtension"
        ) { status, _ in
            DispatchQueue.main.async {
                isFilterEnabled = messageFilterConfirmed && status == .enabled
            }
        }
    }

    private func markAsEnabled() {
        DataManager.shared.setFilterEnabled(true)
        showInstructions = false
        checkFilterStatus()
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Blocked Number Row
struct BlockedNumberRow: View {
    let blockedNumber: BlockedNumber

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(blockedNumber.phoneNumber)
                .font(.headline)

            HStack {
                Text(blockedNumber.addedAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let reason = blockedNumber.reason {
                    Text("•")
                        .foregroundStyle(.secondary)
                    Text(reason)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: BlockedNumber.self, inMemory: true)
}
