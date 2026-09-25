//
//  CountryPickerView.swift
//  SafeMessageShield
//

import SwiftUI

/// Aranabilir ülke listesi; ülke adları uygulama dilinde gösterilir.
struct CountryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var languageManager = LanguageManager.shared
    @Binding var selection: String

    @State private var searchText = ""
    @State private var regions: [PhoneRegion] = []

    var body: some View {
        NavigationStack {
            List(filteredRegions) { region in
                Button {
                    selection = region.code
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        Text(region.flag)
                            .font(.title2)
                            .accessibilityHidden(true)
                        Text(region.localizedName(locale: languageManager.locale))
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(verbatim: region.dialCode)
                            .foregroundStyle(.secondary)
                            .monospacedDigit()
                        if region.code == selection {
                            Image(systemName: "checkmark")
                                .fontWeight(.semibold)
                                .foregroundStyle(ShieldTheme.Colors.primary)
                                .accessibilityHidden(true)
                        }
                    }
                }
                .accessibilityAddTraits(region.code == selection ? .isSelected : [])
            }
            .searchable(text: $searchText, prompt: NSLocalizedString("country.search", comment: ""))
            .navigationTitle(NSLocalizedString("country.select", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "")) {
                        dismiss()
                    }
                }
            }
            .onAppear(perform: loadRegions)
        }
        .appLanguageEnvironment()
    }

    private var filteredRegions: [PhoneRegion] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return regions }
        let digits = PhoneNumberNormalizer.digitsOnly(query)
        let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        return regions.filter { region in
            // Uygulama dilindeki ad, İngilizce ad ve bilinen eski adlar (örn. "Turkey") ile ara;
            // aksanlar yok sayılır ("turk" → "Türkiye")
            region.searchNames(locale: languageManager.locale).contains { $0.range(of: query, options: options) != nil }
                || region.code.range(of: query, options: options) != nil
                || (!digits.isEmpty && String(region.countryCode).hasPrefix(digits))
        }
    }

    private func loadRegions() {
        let locale = languageManager.locale
        regions = PhoneNumberService.shared.allRegions().sorted {
            $0.localizedName(locale: locale).localizedStandardCompare($1.localizedName(locale: locale)) == .orderedAscending
        }
    }
}

private extension PhoneRegion {
    /// Yaygın kullanılan eski/alternatif ülke adları
    static let aliases: [String: [String]] = [
        "TR": ["Turkey", "Turkiye"],
        "CZ": ["Czech Republic"],
        "MK": ["Macedonia"],
        "SZ": ["Swaziland"],
        "CI": ["Ivory Coast"],
        "MM": ["Burma"]
    ]

    func searchNames(locale: Locale) -> [String] {
        [localizedName(locale: locale), localizedName(locale: Locale(identifier: "en"))] + (Self.aliases[code] ?? [])
    }
}

/// Numara alanının yanında seçili ülkeyi ("🇹🇷 +90") gösterir ve dokununca ülke seçiciyi açar.
struct CountryCodeButton: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    @Binding var regionCode: String
    @State private var showingPicker = false

    var body: some View {
        Button {
            showingPicker = true
        } label: {
            HStack(spacing: 4) {
                Text(region?.flag ?? "🌐")
                Text(verbatim: region?.dialCode ?? "+")
                    .monospacedDigit()
                Image(systemName: "chevron.down")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(ShieldTheme.Colors.primary.opacity(0.10), in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityText)
        .sheet(isPresented: $showingPicker) {
            CountryPickerView(selection: $regionCode)
        }
    }

    private var region: PhoneRegion? {
        PhoneNumberService.shared.region(for: regionCode)
    }

    private var accessibilityText: String {
        guard let region else { return NSLocalizedString("country.select", comment: "") }
        return String(
            format: NSLocalizedString("country.accessibility", comment: ""),
            region.localizedName(locale: languageManager.locale),
            region.dialCode
        )
    }
}
