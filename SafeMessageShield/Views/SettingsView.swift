//
//  SettingsView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    @State private var showingLanguagePicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: "shield.checkered")
                            .font(.largeTitle)
                            .foregroundStyle(.blue)
                        
                        VStack(alignment: .leading) {
                            Text("SafeMessageShield")
                                .font(.headline)
                            Text(NSLocalizedString("app.version", comment: "") + " 1.0.0")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Dil Seçimi Bölümü
                Section {
                    Button(action: { showingLanguagePicker = true }) {
                        HStack {
                            Label(NSLocalizedString("language", comment: ""), systemImage: "globe")
                            Spacer()
                            if let currentLang = languageManager.supportedLanguages.first(where: { $0.code == languageManager.currentLanguage }) {
                                Text(currentLang.nativeName)
                                    .foregroundStyle(.secondary)
                            }
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                    .foregroundStyle(.primary)
                } header: {
                    Text(NSLocalizedString("language", comment: ""))
                }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label(NSLocalizedString("sms.filter.title", comment: ""), systemImage: "message.fill")
                        .font(.headline)
                    
                    Text(NSLocalizedString("sms.filter.instruction", comment: ""))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                                        
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text(NSLocalizedString("open.settings", comment: ""))
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
                Text(NSLocalizedString("sms.filtering.title", comment: ""))
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Label(NSLocalizedString("call.block.title", comment: ""), systemImage: "phone.fill")
                        .font(.headline)
                    
                    Text(NSLocalizedString("call.block.instruction", comment: ""))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text(NSLocalizedString("open.settings", comment: ""))
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
                Text(NSLocalizedString("call.blocking.title", comment: ""))
            }
            
            Section {
                HStack {
                    Text(NSLocalizedString("privacy.focused", comment: ""))
                    Spacer()
                    Text(NSLocalizedString("privacy.description", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text(NSLocalizedString("offline.works", comment: ""))
                    Spacer()
                    Text(NSLocalizedString("offline.description", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text(NSLocalizedString("always.protected", comment: ""))
                    Spacer()
                    Text(NSLocalizedString("always.description", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(NSLocalizedString("about", comment: ""))
            } footer: {
                Text(NSLocalizedString("privacy.footer", comment: ""))
            }
            }
            .navigationTitle(NSLocalizedString("settings.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingLanguagePicker) {
            LanguagePickerView()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}