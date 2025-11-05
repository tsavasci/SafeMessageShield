//
//  SettingsView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var filterEnabled = DataManager.shared.isFilterEnabled()
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: "shield.checkered")
                        .font(.largeTitle)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading) {
                        Text("SafeMessageShield")
                            .font(.headline)
                        Text("Versiyon 1.0.0")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("SMS Filtreleme", systemImage: "message.fill")
                        .font(.headline)
                    
                    Text("SMS filtrelemeyi etkinleştirmek için:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1. Ayarlar > Mesajlar")
                        Text("2. Bilinmeyen & İstenmeyen")
                        Text("3. SafeMessageShield'i etkinleştir")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                    
                    Button(action: openMessagesSettings) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Mesajlar Ayarlarını Aç")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.vertical, 4)
            } header: {
                Text("Filtreleme Ayarları")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Telefon Engelleme", systemImage: "phone.fill")
                        .font(.headline)
                    
                    Text("Numara engellemeyi etkinleştirmek için:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("1. Ayarlar > Telefon")
                        Text("2. Engelleme ve Kimlik Tanımlama")
                        Text("3. SafeMessageShield'i etkinleştir")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                    
                    Button(action: openPhoneSettings) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Telefon Ayarlarını Aç")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.vertical, 4)
            } header: {
                Text("Çağrı Engelleme")
            }
            
            Section {
                Link(destination: URL(string: "https://developer.apple.com/documentation/identitylookup")!) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("IdentityLookup Hakkında")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                    }
                }
                
                Link(destination: URL(string: "https://developer.apple.com/documentation/callkit")!) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("CallKit Hakkında")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                    }
                }
            } header: {
                Text("Geliştirici Bilgileri")
            }
            
            Section {
                HStack {
                    Text("Gizlilik")
                    Spacer()
                    Text("Tüm veriler cihazda saklanır")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Veri Paylaşımı")
                    Spacer()
                    Text("Yok")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            } header: {
                Text("Gizlilik")
            } footer: {
                Text("Bu uygulama hiçbir mesaj içeriğini veya kişisel verilerinizi sunucuya göndermez. Tüm filtreleme ve engelleme işlemleri cihazınızda gerçekleşir.")
            }
        }
        .navigationTitle("Ayarlar")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openMessagesSettings() {
        // iOS'ta doğrudan Mesajlar ayarlarına yönlendirme
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openPhoneSettings() {
        // iOS'ta doğrudan Telefon ayarlarına yönlendirme
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
