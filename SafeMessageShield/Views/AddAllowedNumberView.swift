//
//  AddAllowedNumberView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 7.11.2025.
//

import SwiftUI
import SwiftData

struct AddAllowedNumberView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var phoneNumber = ""
    @State private var reason = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var entryType: EntryType = .phoneNumber
    // Ülke kodu olmadan yazılan numaraların ait olduğu ülke; en son seçilen ülkeyle başlar
    @State private var regionCode = RegionManager.shared.lastUsedRegionCode
    
    enum EntryType: String, CaseIterable {
        case phoneNumber = "phone"
        case senderName = "name"
        
        var localizedName: String {
            switch self {
            case .phoneNumber:
                return NSLocalizedString("phone.number", comment: "")
            case .senderName:
                return NSLocalizedString("sender.name", comment: "")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ShieldSurface {
                Form {
                    Section {
                        Picker(NSLocalizedString("entry.type", comment: ""), selection: $entryType) {
                            ForEach(EntryType.allCases, id: \.self) { type in
                                Text(type.localizedName).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text(NSLocalizedString("what.to.add", comment: ""))
                    }
                    
                    Section {
                        if entryType == .phoneNumber {
                            HStack {
                                CountryCodeButton(regionCode: $regionCode)
                                    // Seçimi bir sonraki form için hatırla
                                    .onChange(of: regionCode) { _, newValue in
                                        RegionManager.shared.lastUsedRegionCode = newValue
                                    }
                                TextField(NSLocalizedString("phone.number", comment: ""), text: $phoneNumber)
                                    .keyboardType(.phonePad)
                                    .textContentType(.telephoneNumber)
                            }
                        } else {
                            TextField(NSLocalizedString("sender.name.example", comment: ""), text: $phoneNumber)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        
                        TextField(NSLocalizedString("reason.optional", comment: ""), text: $reason)
                    } header: {
                        Text(NSLocalizedString("number.info", comment: ""))
                    } footer: {
                        Text(entryType == .phoneNumber ? 
                             NSLocalizedString("phone.number.footer", comment: "") :
                             NSLocalizedString("sender.name.footer", comment: ""))
                    }
                    
                    Section {
                        Text(NSLocalizedString("allowed.explanation", comment: ""))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(NSLocalizedString("add.allowed.number", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("cancel", comment: "")) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(NSLocalizedString("add", comment: "")) {
                        addNumber()
                    }
                    .disabled(phoneNumber.isEmpty)
                }
            }
            .alert(NSLocalizedString("error", comment: ""), isPresented: $showError) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func addNumber() {
        let cleanedValue: String
        
        if entryType == .phoneNumber {
            // Numarayı seçili ülkeye göre uluslararası biçime çevir ve doğrula
            switch RegionManager.shared.entry(for: phoneNumber, regionCode: regionCode) {
            case .success(let entry):
                cleanedValue = entry.storageValue
            case .failure(let error):
                errorMessage = RegionManager.shared.message(for: error, regionCode: regionCode)
                showError = true
                return
            }
        } else {
            // İsim ise sadece whitespace temizle, büyük/küçük harf farkı olmasın
            cleanedValue = phoneNumber.trimmingCharacters(in: .whitespaces).uppercased()
            
            guard !cleanedValue.isEmpty else {
                errorMessage = NSLocalizedString("invalid.sender.name", comment: "")
                showError = true
                return
            }
        }
        
        if DataManager.shared.isNumberAllowed(cleanedValue) {
            errorMessage = NSLocalizedString("number.already.allowed", comment: "")
            showError = true
            return
        }
        
        // Centralize persistence through DataManager (will insert into SwiftData when modelContext provided)
        DataManager.shared.addAllowedNumber(cleanedValue, reason: reason, modelContext: modelContext)
        
        // Puanlama yöneticisinde pozitif aksiyon kaydet
        StoreReviewManager.shared.recordPositiveAction()
        
        dismiss()
    }
}

#Preview {
    AddAllowedNumberView()
        .modelContainer(for: AllowedNumber.self, inMemory: true)
}
