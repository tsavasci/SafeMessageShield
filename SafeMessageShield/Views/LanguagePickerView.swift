//
//  LanguagePickerView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI

struct LanguagePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(languageManager.supportedLanguages, id: \.code) { language in
                    Button(action: {
                        languageManager.currentLanguage = language.code
                        // UI'ı güncellemek için kısa bir gecikme
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss()
                        }
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(language.nativeName)
                                    .font(.headline)
                                Text(language.name)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            if languageManager.currentLanguage == language.code {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                                    .font(.title3)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle(NSLocalizedString("select.language", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "")) {
                        dismiss()
                    }
                }
            }
        }
        // Sheet açıkken dil değişirse yazı yönü de hemen güncellensin
        .appLanguageEnvironment()
    }
}

#Preview {
    LanguagePickerView()
}
