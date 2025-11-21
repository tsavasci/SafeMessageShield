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
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        // TextField'ı ViewModel'e bağla
                        TextField(NSLocalizedString("phone.number.or.sender", comment: "Phone number or sender name"), text: $viewModel.selectedPhoneNumber)
                            .keyboardType(.default)
                            .textContentType(.telephoneNumber)
                        
                        // Buton ViewModel'deki durumu değiştirsin
                        Button(action: { checkContactsPermission() }) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
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
                    }
                    // Butonun durumunu ViewModel'deki numaraya göre belirle
                    .disabled(viewModel.selectedPhoneNumber.isEmpty)
                }
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
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) {
                    dismiss()
                }
            } message: {
                Text(String(format: NSLocalizedString("number.blocked.success", comment: ""), blockedValue))
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
        let originalInput = viewModel.selectedPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Girişin boş olup olmadığını kontrol et
        guard !originalInput.isEmpty else {
            alertMessage = NSLocalizedString("enter.phone.number", comment: "")
            showingAlert = true
            return
        }
        
        let valueToBlock: String
        // Giriş harf içeriyorsa, metin olarak kabul et (örn: VODAFONE)
        if originalInput.rangeOfCharacter(from: .letters) != nil {
            valueToBlock = originalInput.uppercased()
        } else {
            // Harf içermiyorsa, telefon numarası olarak kabul et ve temizle
            valueToBlock = originalInput.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)
        }
        
        // Temizlenmiş veya işlenmiş değerin hala boş olup olmadığını kontrol et
        // (örn: sadece sembollerden oluşan bir giriş)
        guard !valueToBlock.isEmpty else {
            alertMessage = NSLocalizedString("invalid.entry", comment: "Geçersiz giriş. Lütfen bir telefon numarası veya gönderici adı girin.")
            showingAlert = true
            return
        }

        // Değer zaten engellenmiş mi kontrol et
        if DataManager.shared.isNumberBlocked(valueToBlock) {
            alertMessage = NSLocalizedString("number.already.blocked", comment: "")
            showingAlert = true
            return
        }
        
        self.blockedValue = valueToBlock
        
        // Centralize: add to both SwiftData and UserDefaults via DataManager
        DataManager.shared.addBlockedNumber(valueToBlock, modelContext: modelContext)
        
        // Call Directory Extension'ı güncelle
        reloadCallDirectory()
        
        // Başarı mesajı göster
        showingSuccessAlert = true
        
        // Kısa bir delay ile kapat (kullanıcı mesajı görsün)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
    
    private func reloadCallDirectory() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: "tsavasci.SafeMessageShield.CallDirectoryExtension") { error in
            // Silently handle reload
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
                        alertMessage = "SafeMessageShield, engellemek istediğiniz numaraları rehberinizden seçebilmeniz için rehber erişimine ihtiyaç duyar."
                        showingAlert = true
                    }
                }
            }
        case .authorized:
            viewModel.isPickerPresented = true
        case .denied, .restricted:
            alertMessage = "SafeMessageShield, engellemek istediğiniz numaraları rehberinizden seçebilmeniz için rehber erişimine ihtiyaç duyar."
            showingAlert = true
        case .limited:
            // Limited access - picker can still be opened but with restrictions
            viewModel.isPickerPresented = true
        @unknown default:
            alertMessage = "Beklenmeyen bir hata oluştu. Lütfen rehber erişim ayarlarını kontrol edin."
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
