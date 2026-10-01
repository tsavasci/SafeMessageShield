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
    @Environment(\.scenePhase) private var scenePhase
    @Query private var blockedNumbers: [BlockedNumber]
    @Query private var allowedNumbersList: [AllowedNumber]
    @Query private var filterRulesList: [FilterRule]
    @Query private var numberFilterRulesList: [NumberFilterRule]
    @ObservedObject private var languageManager = LanguageManager.shared

    @State private var showingAddNumberSheet = false
    @State private var showingContactPicker = false
    @State private var showingReportedJunk = false
    @State private var showingFilterCustomization = false
    @State private var pendingDeletion: BlockedNumber?
    @State private var contactErrorMessage: String?
    @State private var showingSuccessAlert = false
    @State private var lastBlockedNumber = ""
    @State private var selectedTab = 0
    @State private var dashboardFilterEnabled = false
    /// Sistemden okunan arama engelleme uzantısı durumu; belirlenemezse nil
    @State private var callBlockingEnabled: Bool?
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
            // Varsayılan ülkeyi App Group'a yaz; uzantılar yerel numaraları buna göre çözer
            _ = RegionManager.shared

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
                    .appLanguageEnvironment()
            }
            .sheet(isPresented: $showingContactPicker) {
                ContactPickerView()
                    .appLanguageEnvironment()
                    .environmentObject(contactViewModel)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showingReportedJunk) {
                ReportedJunkView()
                    .appLanguageEnvironment()
            }
            .sheet(isPresented: $showingFilterCustomization) {
                FilterCustomizationView()
                    .appLanguageEnvironment()
            }
            .onAppear {
                refreshDashboard()
            }
            .onChange(of: selectedTab) { _, _ in
                refreshDashboard()
            }
            .onChange(of: scenePhase) { _, newPhase in
                // Kullanıcı iOS Ayarlar'dan döndüğünde durumu tazele
                if newPhase == .active {
                    refreshDashboard()
                }
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
            .alert(
                NSLocalizedString("error", comment: ""),
                isPresented: Binding(
                    get: { contactErrorMessage != nil },
                    set: { if !$0 { contactErrorMessage = nil } }
                )
            ) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) {}
            } message: {
                Text(contactErrorMessage ?? "")
            }
            .alert(
                NSLocalizedString("delete.confirm.title", comment: ""),
                isPresented: Binding(
                    get: { pendingDeletion != nil },
                    set: { if !$0 { pendingDeletion = nil } }
                ),
                presenting: pendingDeletion
            ) { number in
                Button(NSLocalizedString("delete", comment: ""), role: .destructive) {
                    deleteBlockedNumber(number)
                    pendingDeletion = nil
                }
                Button(NSLocalizedString("cancel", comment: ""), role: .cancel) {
                    pendingDeletion = nil
                }
            } message: { number in
                Text(String(format: NSLocalizedString("delete.confirm.message", comment: ""), PhoneNumberService.shared.displayString(forStored: number.phoneNumber)))
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
                // Kısa durum etiketi; kartın başlığıyla aynı metni tekrar etmesin
                title: protectionActive
                    ? NSLocalizedString("protection.status.on", comment: "")
                    : NSLocalizedString("protection.status.off", comment: ""),
                color: protectionActive ? ShieldTheme.Colors.success : ShieldTheme.Colors.warning
            )

            Button(action: { selectedTab = 2 }) {
                Image(systemName: "gearshape.fill")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .padding(12)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(NSLocalizedString("settings.title", comment: ""))
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
                        Image(systemName: protectionActive ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(protectionActive ? NSLocalizedString("protection.active", comment: "") : NSLocalizedString("protection.inactive", comment: ""))
                            .font(.title3.weight(.bold))
                        Text(protectionActive ? NSLocalizedString("dashboard.setup.user.confirmed", comment: "") : NSLocalizedString("enable.from.settings", comment: ""))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()
                }

                HStack(spacing: 10) {
                    Button(action: openRelevantSettings) {
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
                    .accessibilityLabel(NSLocalizedString("extensions.enabled", comment: ""))
                    // Onay ikonu (checkmark) sistem tarafından "seçili" olarak okunmasın
                    .accessibilityRemoveTraits(.isSelected)
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
                        color: setupCompletedCount == 2 ? ShieldTheme.Colors.success : ShieldTheme.Colors.warning
                    )
                }

                VStack(spacing: 12) {
                    setupRow(
                        title: NSLocalizedString("dashboard.setup.ios.settings", comment: ""),
                        // Adım tamamlanınca "işaretleyin" talimatı yerine durumu göster
                        subtitle: protectionActive
                            ? NSLocalizedString("dashboard.setup.user.confirmed", comment: "")
                            : NSLocalizedString("dashboard.setup.ios.settings.subtitle", comment: ""),
                        systemImage: "switch.2",
                        isComplete: protectionActive
                    )

                    setupRow(
                        title: NSLocalizedString("dashboard.setup.data.synced", comment: ""),
                        subtitle: lastSyncText,
                        systemImage: "arrow.triangle.2.circlepath",
                        isComplete: dashboardLastSyncDate != nil
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
                .accessibilityHidden(true)

            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 24)
                .accessibilityHidden(true)

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
        // Adım tek öğe olarak okunsun; durum ikon yerine metinle bildirilsin
        .accessibilityElement(children: .combine)
        .accessibilityValue(
            isComplete
                ? NSLocalizedString("dashboard.setup.step.done", comment: "")
                : NSLocalizedString("dashboard.setup.step.pending", comment: "")
        )
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
            // SMS filtresi App Group'a yazamadığı için (iOS kısıtı) filtrelenen mesaj sayısı gösterilemez;
            // yalnızca uygulamanın kendi tuttuğu veriler gösterilir.
            ShieldMetricCard(
                title: NSLocalizedString("management.keywords.title", comment: ""),
                value: "\(filterRulesList.count)",
                systemImage: "text.badge.checkmark",
                color: ShieldTheme.Colors.warning
            )
            ShieldMetricCard(
                title: NSLocalizedString("management.number.rules.title", comment: ""),
                value: "\(numberFilterRulesList.count)",
                systemImage: "number",
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
                    // Keep both buttons in a row the same height when a label wraps
                    .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 10) {
                        ShieldActionButton(title: NSLocalizedString("filter.customization", comment: ""), systemImage: "slider.horizontal.3", color: ShieldTheme.Colors.secondary) {
                            showingFilterCustomization = true
                        }
                        ShieldActionButton(title: NSLocalizedString("reported.junk", comment: ""), systemImage: "tray.full.fill", color: ShieldTheme.Colors.warning) {
                            showingReportedJunk = true
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var recentBlockedSection: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(NSLocalizedString("management.blocked.title", comment: ""))
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Text("\(blockedNumbers.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
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
                                    .accessibilityHidden(true)
                                BlockedNumberRow(blockedNumber: number)
                                Spacer()
                                Button(role: .destructive) {
                                    pendingDeletion = number
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

    private var setupCompletedCount: Int {
        var count = 0
        if protectionActive { count += 1 }
        if dashboardLastSyncDate != nil { count += 1 }
        return count
    }

    /// Kullanıcı onayı tek başına yetmez; sistem arama engellemeyi kapalı bildiriyorsa koruma aktif sayılmaz.
    /// (SMS filtresinin durumunu okuyan herkese açık bir API yok, o kısım kullanıcı onayına dayanır.)
    private var protectionActive: Bool {
        dashboardFilterEnabled && callBlockingEnabled != false
    }

    private var setupCompletedCountText: String {
        String(format: NSLocalizedString("dashboard.setup.progress", comment: ""), setupCompletedCount)
    }

    private var lastSyncText: String {
        guard let dashboardLastSyncDate else {
            return NSLocalizedString("dashboard.setup.no.sync", comment: "")
        }
        // Göreli zaman ("şimdi", "5 dakika önce"); dakikaya yuvarlanır ki son bir dakika "şimdi" olsun
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = languageManager.locale
        formatter.dateTimeStyle = .named
        let elapsedMinutes = (dashboardLastSyncDate.timeIntervalSinceNow / 60).rounded(.towardZero)
        let relativeText = formatter.localizedString(fromTimeInterval: elapsedMinutes * 60)
        return String(format: NSLocalizedString("dashboard.setup.last.sync", comment: ""), relativeText)
    }

    private func addNumberFromContact(phoneNumber: String) {
        // Rehberdeki numara yerel biçimde olabilir; varsayılan ülkeye göre uluslararası biçime çevir
        let entry: PhoneNumberEntry
        switch RegionManager.shared.entry(for: phoneNumber) {
        case .success(let value):
            entry = value
        case .failure(let error):
            contactErrorMessage = RegionManager.shared.message(for: error)
            contactViewModel.selectedPhoneNumber = ""
            return
        }
        let cleanedNumber = entry.storageValue

        // Temizlenmiş numara ile kontrol et
        if DataManager.shared.isNumberBlocked(cleanedNumber) {
            print("⚠️ Numara zaten engelli: \(cleanedNumber)")
            return
        }

        // Centralize persistence via DataManager (will insert into SwiftData when modelContext provided)
        DataManager.shared.addBlockedNumber(cleanedNumber, modelContext: modelContext)

        // Call Directory Extension'ı güncelle
        reloadCallDirectory()

        // Geri bildirim için (listede saklandığı biçimle aynı göster)
        lastBlockedNumber = PhoneNumberService.shared.displayString(forStored: entry.storageValue)
        showingSuccessAlert = true

        // ViewModel'i sıfırla
        contactViewModel.selectedPhoneNumber = ""
    }

    private func deleteBlockedNumber(_ number: BlockedNumber) {
        DataManager.shared.removeBlockedNumber(number.phoneNumber)
        modelContext.delete(number)
        reloadCallDirectory()
    }

    private func refreshDashboard() {
        dashboardFilterEnabled = DataManager.shared.isFilterEnabled()
        dashboardLastSyncDate = DataManager.shared.lastAppGroupSyncDate()

        Task {
            callBlockingEnabled = await SystemSettingsNavigator.callBlockingEnabledStatus()
        }
    }

    private func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(
            withIdentifier: SystemSettingsNavigator.callDirectoryExtensionIdentifier
        ) { error in
            DispatchQueue.main.async {
                DataManager.shared.recordCallDirectoryReloadError(error)
            }
        }
    }

    /// Arama engelleme kapalıysa doğrudan CallKit'in ayar ekranını açar; açıksa
    /// kullanıcıyı SMS filtresi talimatlarının bulunduğu Ayarlar sekmesine götürür.
    private func openRelevantSettings() {
        if callBlockingEnabled != true {
            SystemSettingsNavigator.openCallBlockingSettings()
        } else {
            selectedTab = 2
        }
    }
}

// MARK: - Blocked Number Row
struct BlockedNumberRow: View {
    let blockedNumber: BlockedNumber

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(PhoneNumberService.shared.displayString(forStored: blockedNumber.phoneNumber))
                .font(.headline)

            HStack {
                Text(blockedNumber.addedAt, format: .dateTime.day().month(.abbreviated).year())
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
