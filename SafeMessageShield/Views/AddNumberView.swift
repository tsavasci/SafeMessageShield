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

struct AddNumberView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // ViewModel'i StateObject olarak oluştur
    @StateObject private var viewModel = ContactPickerViewModel()
    
    @State private var reason = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingSuccessAlert = false
    
    var body: some View {
        // ViewModel'deki değişiklikleri izlemek için
        let _ = print("📱 DEBUG: AddNumberView render - phoneNumber: '\(viewModel.selectedPhoneNumber)'")
        NavigationStack {
            Form {
                Section {
                    HStack {
                        // TextField'ı ViewModel'e bağla
                        TextField("Telefon Numarası", text: $viewModel.selectedPhoneNumber)
                            .keyboardType(.phonePad)
                            .textContentType(.telephoneNumber)
                        
                        // Buton ViewModel'deki durumu değiştirsin
                        Button(action: { viewModel.isPickerPresented = true }) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
                    }
                    
                    TextField("Sebep (opsiyonel)", text: $reason)
                } header: {
                    Text("Numara Bilgileri")
                } footer: {
                    Text("Manuel girin veya rehberden seçin. Örnek: +905551234567")
                }
                
                Section {
                    Button(action: addNumber) {
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                            Text("Numarayı Engelle")
                            Spacer()
                        }
                    }
                    // Butonun durumunu ViewModel'deki numaraya göre belirle
                    .disabled(viewModel.selectedPhoneNumber.isEmpty)
                }
            }
            .navigationTitle("Numara Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
            }
            .alert("Uyarı", isPresented: $showingAlert) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .alert("Başarılı!", isPresented: $showingSuccessAlert) {
                Button("Tamam", role: .cancel) {
                    dismiss()
                }
            } message: {
                // Başarı mesajında ViewModel'deki numarayı göster
                Text("Numara başarıyla engellendi: \(viewModel.selectedPhoneNumber)")
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
        print("🔵 DEBUG: addNumber çağrıldı")
        // Numarayı ViewModel'den al
        let cleanedNumber = viewModel.selectedPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Basit validasyon
        guard !cleanedNumber.isEmpty else {
            alertMessage = "Lütfen bir telefon numarası girin."
            showingAlert = true
            return
        }
        
        // Numara zaten engellenmiş mi kontrol et
        if DataManager.shared.isNumberBlocked(cleanedNumber) {
            alertMessage = "Bu numara zaten engellenmiş."
            showingAlert = true
            return
        }
        
        // SwiftData modelini ekle
        let blockedNumber = BlockedNumber(
            phoneNumber: cleanedNumber,
            addedAt: Date(),
            reason: reason.isEmpty ? nil : reason
        )
        modelContext.insert(blockedNumber)
        
        // App Group'a da ekle (Extension'lar için)
        DataManager.shared.addBlockedNumber(cleanedNumber)
        
        // Başarı mesajı göster
        showingSuccessAlert = true
        
        // Kısa bir delay ile kapat (kullanıcı mesajı görsün)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
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
            print("📞 DEBUG: Numara seçildi")
            if let phoneNumberValue = contactProperty.value as? CNPhoneNumber {
                let number = phoneNumberValue.stringValue
                print("📞 DEBUG: Seçilen numara: \(number)")
                DispatchQueue.main.async {
                    // ViewModel'i güncelle
                    self.viewModel.selectedPhoneNumber = number
                    print("📞 DEBUG: ViewModel güncellendi: \(self.viewModel.selectedPhoneNumber)")
                    // Picker'ı kapat
                    self.viewModel.isPickerPresented = false
                    print("📞 DEBUG: Picker kapatıldı")
                }
            }
        }
        
        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            print("📞 DEBUG: Kullanıcı iptal etti")
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
