//
//  ContentView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI
import SwiftData
import ContactsUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var blockedNumbers: [BlockedNumber]
    @ObservedObject private var languageManager = LanguageManager.shared
    
    @State private var showingAddNumberSheet = false
    @State private var showingContactPicker = false
    @State private var showingSuccessAlert = false
    @State private var lastBlockedNumber = ""
    @State private var selectedTab = 0
    
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
            
            // İstatistikler Sekmesi
            StatisticsView()
                .tabItem {
                    Label(NSLocalizedString("tab.statistics", comment: ""), systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            // Ayarlar Sekmesi
            SettingsView()
                .tabItem {
                    Label(NSLocalizedString("tab.settings", comment: ""), systemImage: "gear")
                }
                .tag(2)
        }
    }
    
    private var mainListView: some View {
        NavigationStack {
            VStack {
                // Durum Kartı
                StatusCard()
                    .padding()
                
                // Engellenen Numaralar Listesi
                if blockedNumbers.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "phone.down.circle")
                            .font(.system(size: 60))
                            .foregroundStyle(.gray)
                        
                        Text(NSLocalizedString("no.blocked.title", comment: ""))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(NSLocalizedString("no.blocked.message", comment: ""))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(format: NSLocalizedString("blocked.count", comment: ""), blockedNumbers.count))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        List {
                            ForEach(blockedNumbers) { number in
                                BlockedNumberRow(blockedNumber: number)
                            }
                            .onDelete(perform: deleteNumbers)
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("app.title", comment: ""))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingAddNumberSheet = true }) {
                            Label(NSLocalizedString("menu.manual", comment: ""), systemImage: "square.and.pencil")
                        }
                        Button(action: { showingContactPicker = true }) {
                            Label(NSLocalizedString("menu.contacts", comment: ""), systemImage: "person.crop.circle.badge.plus")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddNumberSheet) {
                AddNumberView()
            }
            .sheet(isPresented: $showingContactPicker) {
                // ContactPicker'ı doğrudan buradan sunuyoruz
                ContactPickerView()
                    .environmentObject(contactViewModel)
                    .ignoresSafeArea()
            }
            .onChange(of: contactViewModel.selectedPhoneNumber) { oldValue, newValue in
                // ViewModel'de numara değiştiğinde engelleme işlemini tetikle
                if !newValue.isEmpty && newValue != oldValue {
                    addNumberFromContact(phoneNumber: newValue)
                }
            }
            .alert(NSLocalizedString("success", comment: ""), isPresented: $showingSuccessAlert) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) { }
            } message: {
                Text(String(format: NSLocalizedString("number.blocked.success", comment: ""), lastBlockedNumber))
            }
        }
    }
    
    private func addNumberFromContact(phoneNumber: String) {
        let cleanedNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cleanedNumber.isEmpty else { return }
        
        if DataManager.shared.isNumberBlocked(cleanedNumber) {
            // İsteğe bağlı: kullanıcıya zaten engelli olduğuna dair bir uyarı gösterilebilir.
            print("⚠️ Numara zaten engelli: \(cleanedNumber)")
            return
        }
        
        let blockedNumber = BlockedNumber(
            phoneNumber: cleanedNumber,
            addedAt: Date(),
            reason: NSLocalizedString("added.from.contacts", comment: "")
        )
        modelContext.insert(blockedNumber)
        DataManager.shared.addBlockedNumber(cleanedNumber)
        
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
                DataManager.shared.removeBlockedNumber(number.phoneNumber)
                modelContext.delete(number)
            }
        }
    }
}

// MARK: - Status Card
struct StatusCard: View {
    @State private var isFilterEnabled = false
    @State private var showInstructions = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: isFilterEnabled ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(isFilterEnabled ? .green : .orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(isFilterEnabled ? NSLocalizedString("protection.active", comment: "") : NSLocalizedString("protection.inactive", comment: ""))
                        .font(.headline)
                    Text(isFilterEnabled ? NSLocalizedString("sms.filtering", comment: "") : NSLocalizedString("enable.from.settings", comment: ""))
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
                        Text(showInstructions ? NSLocalizedString("hide.instructions", comment: "") : NSLocalizedString("how.to.enable", comment: ""))
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
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            checkFilterStatus()
        }
    }
    
    private func checkFilterStatus() {
        // Extension'ların etkinleştirilip etkinleştirilmediğini kontrol etmek
        // iOS gerçekte extension durumunu API ile vermediği için kullanıcıya bilgi veriyoruz
        isFilterEnabled = DataManager.shared.isFilterEnabled()
    }
    
    private func markAsEnabled() {
        DataManager.shared.setFilterEnabled(true)
        withAnimation {
            isFilterEnabled = true
            showInstructions = false
        }
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
