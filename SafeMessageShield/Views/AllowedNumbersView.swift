//
//  AllowedNumbersView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 7.11.2025.
//

import SwiftUI
import SwiftData
import ContactsUI

struct AllowedNumbersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allowedNumbers: [AllowedNumber]
    
    @State private var showingAddNumberSheet = false
    @State private var showingContactPicker = false
    @State private var showingSuccessAlert = false
    @State private var lastAllowedNumber = ""
    
    @StateObject private var contactViewModel = ContactPickerViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Info Card
                AllowedInfoCard()
                    .padding()
                
                // Allowed Numbers List
                if allowedNumbers.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.shield")
                            .font(.system(size: 60))
                            .foregroundStyle(.green)
                        
                        Text(NSLocalizedString("no.allowed.title", comment: ""))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(NSLocalizedString("no.allowed.message", comment: ""))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(String(format: NSLocalizedString("allowed.count", comment: ""), allowedNumbers.count))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        List {
                            ForEach(allowedNumbers) { number in
                                AllowedNumberRow(allowedNumber: number)
                            }
                            .onDelete(perform: deleteNumbers)
                        }
                        .listStyle(.insetGrouped)
                    }
                }
            }
            .navigationTitle(NSLocalizedString("allowed.numbers", comment: ""))
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
                AddAllowedNumberView()
            }
            .sheet(isPresented: $showingContactPicker) {
                ContactPickerView()
                    .environmentObject(contactViewModel)
                    .ignoresSafeArea()
            }
            .onChange(of: contactViewModel.selectedPhoneNumber) { oldValue, newValue in
                if !newValue.isEmpty && newValue != oldValue {
                    addNumberFromContact(phoneNumber: newValue)
                }
            }
            .alert(NSLocalizedString("success", comment: ""), isPresented: $showingSuccessAlert) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) { }
            } message: {
                Text(String(format: NSLocalizedString("number.allowed.success", comment: ""), lastAllowedNumber))
            }
        }
    }
    
    private func addNumberFromContact(phoneNumber: String) {
        let cleanedNumber = phoneNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        
        guard !cleanedNumber.isEmpty else { return }
        
        if DataManager.shared.isNumberAllowed(cleanedNumber) {
            print("⚠️ Numara zaten güvenli listede: \(cleanedNumber)")
            return
        }
        
        let allowedNumber = AllowedNumber(
            phoneNumber: cleanedNumber,
            addedAt: Date(),
            reason: NSLocalizedString("added.from.contacts", comment: "")
        )
        modelContext.insert(allowedNumber)
        DataManager.shared.addAllowedNumber(cleanedNumber)
        
        lastAllowedNumber = cleanedNumber
        showingSuccessAlert = true
        contactViewModel.selectedPhoneNumber = ""
    }
    
    private func deleteNumbers(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let number = allowedNumbers[index]
                DataManager.shared.removeAllowedNumber(number.phoneNumber)
                modelContext.delete(number)
            }
        }
    }
}

// MARK: - Allowed Info Card
struct AllowedInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.title2)
                Text(NSLocalizedString("allowed.info.title", comment: ""))
                    .font(.headline)
            }
            
            Text(NSLocalizedString("allowed.info.message", comment: ""))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Allowed Number Row
struct AllowedNumberRow: View {
    let allowedNumber: AllowedNumber
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(allowedNumber.phoneNumber)
                .font(.headline)
            
            HStack {
                Text(allowedNumber.addedAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let reason = allowedNumber.reason {
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

// MARK: - Add Allowed Number View
struct AddAllowedNumberView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var phoneNumber = ""
    @State private var reason = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var entryType: EntryType = .phoneNumber
    
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
                        TextField(NSLocalizedString("phone.number", comment: ""), text: $phoneNumber)
                            .keyboardType(.phonePad)
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
            // Numara ise temizle
            cleanedValue = phoneNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
            
            guard !cleanedValue.isEmpty else {
                errorMessage = NSLocalizedString("invalid.phone.number", comment: "")
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
        
        let allowedNumber = AllowedNumber(
            phoneNumber: cleanedValue,
            addedAt: Date(),
            reason: reason.isEmpty ? nil : reason
        )
        
        modelContext.insert(allowedNumber)
        DataManager.shared.addAllowedNumber(cleanedValue)
        
        dismiss()
    }
}

#Preview {
    AllowedNumbersView()
        .modelContainer(for: AllowedNumber.self, inMemory: true)
}
