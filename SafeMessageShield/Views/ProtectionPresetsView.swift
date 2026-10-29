//
//  ProtectionPresetsView.swift
//  SafeMessageShield
//

import SwiftUI
import SwiftData

/// Akıllı Spam Koruma Paketleri Ekranı
struct ProtectionPresetsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var filterRules: [FilterRule]
    @ObservedObject private var languageManager = LanguageManager.shared

    @State private var showingSuccessToast = false
    @State private var toastMessage = ""

    var body: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        headerCard
                        applyAllButton
                        presetsList
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle(NSLocalizedString("presets.nav.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "")) {
                        dismiss()
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if showingSuccessToast {
                    toastView
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 24)
                }
            }
        }
    }

    private var headerCard: some View {
        ShieldCard {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(ShieldTheme.Colors.primaryGradient)
                        .frame(width: 52, height: 52)
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("presets.header.title", comment: ""))
                        .font(.headline.weight(.semibold))
                    Text(NSLocalizedString("presets.header.subtitle", comment: ""))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var applyAllButton: some View {
        Button(action: applyAll) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                Text(NSLocalizedString("presets.apply.all", comment: ""))
            }
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(ShieldTheme.Colors.primaryGradient)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var presetsList: some View {
        VStack(spacing: 12) {
            ForEach(ProtectionPresetManager.shared.presets) { preset in
                presetRow(preset)
            }
        }
    }

    private func presetRow(_ preset: ProtectionPreset) -> some View {
        let isFullyApplied = ProtectionPresetManager.shared.isPresetFullyApplied(
            preset: preset,
            languageCode: languageManager.currentLanguage,
            existingRules: filterRules
        )
        let activeCount = ProtectionPresetManager.shared.activeKeywordCount(
            for: preset,
            languageCode: languageManager.currentLanguage,
            existingRules: filterRules
        )
        let totalCount = preset.keywords(for: languageManager.currentLanguage).count

        return ShieldCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: preset.icon)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(isFullyApplied ? ShieldTheme.Colors.success : ShieldTheme.Colors.primary)
                        .frame(width: 38, height: 38)
                        .background((isFullyApplied ? ShieldTheme.Colors.success : ShieldTheme.Colors.primary).opacity(0.12), in: Circle())

                    VStack(alignment: .leading, spacing: 3) {
                        Text(NSLocalizedString(preset.titleKey, comment: ""))
                            .font(.subheadline.weight(.bold))
                        Text(NSLocalizedString(preset.descriptionKey, comment: ""))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer()

                    ShieldStatusPill(
                        title: "\(activeCount)/\(totalCount)",
                        color: isFullyApplied ? ShieldTheme.Colors.success : (activeCount > 0 ? ShieldTheme.Colors.warning : ShieldTheme.Colors.primary)
                    )
                }

                Divider()

                HStack {
                    Text(keywordsPreview(for: preset))
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)

                    Spacer()

                    if isFullyApplied {
                        Button(action: { removePreset(preset) }) {
                            Text(NSLocalizedString("presets.remove", comment: ""))
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(ShieldTheme.Colors.danger)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(ShieldTheme.Colors.danger.opacity(0.12), in: Capsule())
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button(action: { applyPreset(preset) }) {
                            Text(NSLocalizedString("presets.apply", comment: ""))
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(ShieldTheme.Colors.primary, in: Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func keywordsPreview(for preset: ProtectionPreset) -> String {
        let list = preset.keywords(for: languageManager.currentLanguage)
        return list.prefix(4).joined(separator: ", ") + (list.count > 4 ? "..." : "")
    }

    private func applyPreset(_ preset: ProtectionPreset) {
        let added = ProtectionPresetManager.shared.applyPreset(
            preset,
            languageCode: languageManager.currentLanguage,
            existingRules: filterRules,
            modelContext: modelContext
        )
        showToast(String(format: NSLocalizedString("presets.applied.toast", comment: ""), added))
    }

    private func removePreset(_ preset: ProtectionPreset) {
        let removed = ProtectionPresetManager.shared.removePreset(
            preset,
            languageCode: languageManager.currentLanguage,
            existingRules: filterRules,
            modelContext: modelContext
        )
        showToast(String(format: NSLocalizedString("presets.removed.toast", comment: ""), removed))
    }

    private func applyAll() {
        let total = ProtectionPresetManager.shared.applyAllPresets(
            languageCode: languageManager.currentLanguage,
            existingRules: filterRules,
            modelContext: modelContext
        )
        showToast(String(format: NSLocalizedString("presets.all.applied.toast", comment: ""), total))
    }

    private func showToast(_ msg: String) {
        toastMessage = msg
        withAnimation {
            showingSuccessToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                showingSuccessToast = false
            }
        }
    }

    private var toastView: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(ShieldTheme.Colors.success)
            Text(toastMessage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}
