//
//  AddNumberView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI
import SwiftData
import Contacts
import ContactsUI
import CallKit

struct AddNumberView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var languageManager = LanguageManager.shared
    
    // ViewModel'i StateObject olarak oluştur
    @StateObject private var viewModel = ContactPickerViewModel()
    
    @State private var reason = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingSuccessAlert = false
    @State private var blockedValue = ""
    // Ülke kodu olmadan yazılan numaraların ait olduğu ülke; en son seçilen ülkeyle başlar
    @State private var regionCode = RegionManager.shared.lastUsedRegionCode

    var body: some View {
        NavigationStack {
            ShieldSurface {
                Form {
                    Section {
                        HStack {
                            // Gönderici adı yazılırken ülke seçimi anlamsız, gizle
                            if viewModel.selectedPhoneNumber.rangeOfCharacter(from: .letters) == nil {
                                CountryCodeButton(regionCode: $regionCode)
                                    // Seçimi bir sonraki form için hatırla
                                    .onChange(of: regionCode) { _, newValue in
                                        RegionManager.shared.lastUsedRegionCode = newValue
                                    }
                            }

                            // TextField'ı ViewModel'e bağla
                            TextField(NSLocalizedString("phone.number.or.sender", comment: "Phone number or sender name"), text: $viewModel.selectedPhoneNumber, axis: .vertical)
                                .lineLimit(1...2)
                                .keyboardType(.default)
                                .textContentType(.telephoneNumber)
                            
                            // Buton ViewModel'deki durumu değiştirsin
                            Button(action: { checkContactsPermission() }) {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.title2)
                                    .foregroundStyle(ShieldTheme.Colors.primary)
                            }
                            .accessibilityLabel(NSLocalizedString("menu.contacts", comment: ""))
                        }
                        
                        TextField(NSLocalizedString("reason.optional", comment: ""), text: $reason)
                    } header: {
                        Text(NSLocalizedString("number.info", comment: ""))
                    } footer: {
                        Text(NSLocalizedString("number.info.footer.extended", comment: "Numaralar, ülke kodları ve gönderici adlarını (MERKEZPRIME, VODAFONE, vb.) girebilirsiniz."))
                    }
                    
                    Section {
                        Button(action: addNumber) {
                            HStack {
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                                Text(NSLocalizedString("block.number", comment: ""))
                                Spacer()
                            }
                            .font(.subheadline.weight(.semibold))
                        }
                        .listRowBackground(ShieldTheme.Colors.danger.opacity(0.10))
                        .foregroundStyle(ShieldTheme.Colors.danger)
                        // Butonun durumunu ViewModel'deki numaraya göre belirle
                        .disabled(viewModel.selectedPhoneNumber.isEmpty)
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
            .alert(NSLocalizedString("alert", comment: ""), isPresented: $showingAlert) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .alert(NSLocalizedString("success", comment: ""), isPresented: $showingSuccessAlert) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) { }
            } message: {
                Text(String(format: NSLocalizedString("number.blocked.success", comment: ""), blockedValue))
            }
            // Uyarının içinden çağrılan dismiss() yok sayılabiliyor; sayfayı uyarı kapandıktan sonra kapat
            .onChange(of: showingSuccessAlert) { _, isPresented in
                if !isPresented {
                    dismiss()
                }
            }
            // Picker'ın gösterilmesini ViewModel'deki duruma bağla
            .fullScreenCover(isPresented: $viewModel.isPickerPresented) {
                // ContactPickerView'a ViewModel'i environment object olarak ver
                ContactPickerView()
                    .environmentObject(viewModel)
            }
        }
    }
    
    private func addNumber() {
        // Numara, kısa numara veya gönderici adı olarak çöz; numarayı seçili ülkeye göre doğrula
        let entry: PhoneNumberEntry
        switch RegionManager.shared.entry(for: viewModel.selectedPhoneNumber, regionCode: regionCode) {
        case .success(let value):
            entry = value
        case .failure(let error):
            alertMessage = RegionManager.shared.message(for: error, regionCode: regionCode)
            showingAlert = true
            return
        }

        // Değer zaten engellenmiş mi kontrol et
        if DataManager.shared.isNumberBlocked(entry.storageValue) {
            alertMessage = NSLocalizedString("number.already.blocked", comment: "")
            showingAlert = true
            return
        }

        // Kullanıcıya listede saklandığı biçimle aynı değeri göster
        self.blockedValue = PhoneNumberService.shared.displayString(forStored: entry.storageValue)

        // Centralize: add to both SwiftData and UserDefaults via DataManager
        DataManager.shared.addBlockedNumber(entry.storageValue, reason: reason, modelContext: modelContext)
        
        // Call Directory Extension'ı güncelle
        reloadCallDirectory()
        
        // Başarı mesajı göster; sayfa, uyarıdaki Tamam butonuyla kapanır
        showingSuccessAlert = true
    }
    
    private func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "tsavasci.SafeMessageShield.CallDirectoryExtension") { error in
            DispatchQueue.main.async {
                DataManager.shared.recordCallDirectoryReloadError(error)
            }
        }
    }

    private func checkContactsPermission() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        viewModel.isPickerPresented = true
                    } else {
                        alertMessage = NSLocalizedString("contacts.permission.denied", comment: "")
                        showingAlert = true
                    }
                }
            }
        case .authorized:
            viewModel.isPickerPresented = true
        case .denied, .restricted:
            alertMessage = NSLocalizedString("contacts.permission.denied", comment: "")
            showingAlert = true
        case .limited:
            // Limited access - picker can still be opened but with restrictions
            viewModel.isPickerPresented = true
        @unknown default:
            alertMessage = NSLocalizedString("contacts.permission.error", comment: "")
            showingAlert = true
        }
    }
}

// MARK: - Contact Picker
struct ContactPickerView: UIViewControllerRepresentable {
    // ViewModel'i EnvironmentObject olarak al
    @EnvironmentObject var viewModel: ContactPickerViewModel
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var viewModel: ContactPickerViewModel
        
        init(viewModel: ContactPickerViewModel) {
            self.viewModel = viewModel
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
            if let phoneNumberValue = contactProperty.value as? CNPhoneNumber {
                let number = phoneNumberValue.stringValue
                DispatchQueue.main.async {
                    // ViewModel'i güncelle
                    self.viewModel.selectedPhoneNumber = number
                    // Picker'ı kapat
                    self.viewModel.isPickerPresented = false
                }
            }
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            guard let firstPhoneNumber = contact.phoneNumbers.first?.value.stringValue else {
                DispatchQueue.main.async {
                    self.viewModel.isPickerPresented = false
                }
                return
            }

            DispatchQueue.main.async {
                self.viewModel.selectedPhoneNumber = firstPhoneNumber
                self.viewModel.isPickerPresented = false
            }
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            DispatchQueue.main.async {
                // Picker'ı kapat
                self.viewModel.isPickerPresented = false
            }
        }
    }
}

#Preview {
    AddNumberView()
        .modelContainer(for: BlockedNumber.self, inMemory: true)
}
