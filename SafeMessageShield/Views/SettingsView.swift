//
//  SettingsView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    @ObservedObject private var regionManager = RegionManager.shared
    @State private var showingLanguagePicker = false
    @State private var showingCountryPicker = false
    @State private var showingFilterCustomization = false
    @State private var showingReportedJunk = false
    
    var body: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        appHeader
                        preferencesCard
                        setupCard(
                            title: NSLocalizedString("sms.filter.title", comment: ""),
                            message: NSLocalizedString("sms.filter.instruction", comment: ""),
                            systemImage: "message.fill",
                            color: ShieldTheme.Colors.primary,
                            action: SystemSettingsNavigator.openAppSettings
                        )
                        setupCard(
                            title: NSLocalizedString("call.block.title", comment: ""),
                            message: NSLocalizedString("call.block.instruction", comment: ""),
                            systemImage: "phone.fill",
                            color: ShieldTheme.Colors.success,
                            action: SystemSettingsNavigator.openCallBlockingSettings
                        )
                        privacyCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle(NSLocalizedString("settings.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingLanguagePicker) {
            LanguagePickerView()
        }
        .sheet(isPresented: $showingCountryPicker) {
            CountryPickerView(selection: $regionManager.regionCode)
        }
        .sheet(isPresented: $showingFilterCustomization) {
            FilterCustomizationView()
                .appLanguageEnvironment()
        }
        .sheet(isPresented: $showingReportedJunk) {
            ReportedJunkView()
                .appLanguageEnvironment()
        }
    }

    private var appHeader: some View {
        ShieldCard {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(ShieldTheme.Colors.primaryGradient)
                        .frame(width: 54, height: 54)
                    Image(systemName: "shield.checkered")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("app.title", comment: ""))
                        .font(.headline.weight(.semibold))
                    Text(appVersionText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
        }
    }

    private var preferencesCard: some View {
        ShieldCard {
            VStack(spacing: 0) {
                settingsRow(
                    title: NSLocalizedString("language", comment: ""),
                    subtitle: currentLanguageName,
                    systemImage: "globe",
                    color: ShieldTheme.Colors.primary,
                    action: { showingLanguagePicker = true }
                )

                Divider().padding(.leading, 42)

                settingsRow(
                    title: NSLocalizedString("default.country", comment: ""),
                    subtitle: currentCountryText,
                    systemImage: "phone.badge.waveform",
                    color: ShieldTheme.Colors.success,
                    action: { showingCountryPicker = true }
                )

                Divider().padding(.leading, 42)

                settingsRow(
                    title: NSLocalizedString("filter.customization", comment: ""),
                    subtitle: NSLocalizedString("management.keywords.title", comment: ""),
                    systemImage: "slider.horizontal.3",
                    color: ShieldTheme.Colors.secondary,
                    action: { showingFilterCustomization = true }
                )

                Divider().padding(.leading, 42)

                settingsRow(
                    title: NSLocalizedString("reported.junk", comment: ""),
                    subtitle: NSLocalizedString("reported.junk.subtitle", comment: ""),
                    systemImage: "arrow.uturn.backward.circle",
                    color: ShieldTheme.Colors.warning,
                    action: { showingReportedJunk = true }
                )
            }
        }
    }

    private var appVersionText: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        let resolvedVersion = version ?? build ?? "-"

        if let build, build != resolvedVersion {
            return "\(NSLocalizedString("app.version", comment: "")) \(resolvedVersion) (\(build))"
        }

        return "\(NSLocalizedString("app.version", comment: "")) \(resolvedVersion)"
    }

    private func setupCard(title: String, message: String, systemImage: String, color: Color, action: @escaping () -> Void) -> some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 12) {
                Label(title, systemImage: systemImage)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(color)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: action) {
                    Label(NSLocalizedString("open.settings", comment: ""), systemImage: "arrow.up.forward.app.fill")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous)
                                .stroke(color.opacity(0.20), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .foregroundStyle(color)
            }
        }
    }

    private var privacyCard: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                Text(NSLocalizedString("about", comment: ""))
                    .font(.headline.weight(.semibold))

                VStack(spacing: 12) {
                    infoRow(title: NSLocalizedString("privacy.focused", comment: ""), subtitle: NSLocalizedString("privacy.description", comment: ""), systemImage: "lock.shield.fill")
                    infoRow(title: NSLocalizedString("offline.works", comment: ""), subtitle: NSLocalizedString("offline.description", comment: ""), systemImage: "wifi.slash")
                    infoRow(title: NSLocalizedString("always.protected", comment: ""), subtitle: NSLocalizedString("always.description", comment: ""), systemImage: "bolt.shield.fill")
                }

                Text(NSLocalizedString("privacy.footer", comment: ""))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func settingsRow(title: String, subtitle: String, systemImage: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(color)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func infoRow(title: String, subtitle: String, systemImage: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(ShieldTheme.Colors.success)
                .frame(width: 26)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
    }

    /// Örn. "🇹🇷 Türkiye (+90)"
    private var currentCountryText: String {
        guard let region = regionManager.region else { return regionManager.regionCode }
        return "\(region.flag) \(region.localizedName(locale: languageManager.locale)) (\(region.dialCode))"
    }

    private var currentLanguageName: String {
        languageManager.supportedLanguages.first(where: { $0.code == languageManager.currentLanguage })?.nativeName ?? languageManager.currentLanguage
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
