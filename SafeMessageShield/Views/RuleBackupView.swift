//
//  RuleBackupView.swift
//  SafeMessageShield
//

import SwiftUI
import SwiftData

/// Kuralları Dışa Aktarma / İçe Aktarma Ekranı
struct RuleBackupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var blockedNumbers: [BlockedNumber]
    @Query private var allowedNumbers: [AllowedNumber]
    @Query private var filterRules: [FilterRule]
    @Query private var numberFilterRules: [NumberFilterRule]

    @State private var jsonExportText: String = ""
    @State private var jsonImportText: String = ""
    @State private var showingExportSheet = false
    @State private var importErrorMessage: String?
    @State private var importSuccessMessage: String?

    var body: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        headerCard
                        exportCard
                        importCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle(NSLocalizedString("backup.nav.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "")) {
                        dismiss()
                    }
                }
            }
            .alert(NSLocalizedString("error", comment: ""), isPresented: Binding(
                get: { importErrorMessage != nil },
                set: { if !$0 { importErrorMessage = nil } }
            )) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) {}
            } message: {
                Text(importErrorMessage ?? "")
            }
            .alert(NSLocalizedString("success", comment: ""), isPresented: Binding(
                get: { importSuccessMessage != nil },
                set: { if !$0 { importSuccessMessage = nil } }
            )) {
                Button(NSLocalizedString("ok", comment: ""), role: .cancel) {}
            } message: {
                Text(importSuccessMessage ?? "")
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
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("backup.header.title", comment: ""))
                        .font(.headline.weight(.semibold))
                    Text(NSLocalizedString("backup.header.subtitle", comment: ""))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var exportCard: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                Label(NSLocalizedString("backup.export.title", comment: ""), systemImage: "square.and.arrow.up.fill")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(ShieldTheme.Colors.primary)

                Text(NSLocalizedString("backup.export.desc", comment: ""))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack {
                    Text(String(format: NSLocalizedString("backup.export.counts", comment: ""), blockedNumbers.count, allowedNumbers.count, filterRules.count, numberFilterRules.count))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                let currentExport = prepareExportJSON()

                ShareLink(item: currentExport, preview: SharePreview(NSLocalizedString("backup.file.name", comment: ""))) {
                    Label(NSLocalizedString("backup.export.button", comment: ""), systemImage: "square.and.arrow.up")
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(ShieldTheme.Colors.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var importCard: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                Label(NSLocalizedString("backup.import.title", comment: ""), systemImage: "square.and.arrow.down.fill")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(ShieldTheme.Colors.success)

                Text(NSLocalizedString("backup.import.desc", comment: ""))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                TextEditor(text: $jsonImportText)
                    .frame(height: 110)
                    .padding(8)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )

                HStack(spacing: 10) {
                    Button(action: pasteFromClipboard) {
                        Label(NSLocalizedString("backup.paste.clipboard", comment: ""), systemImage: "doc.on.clipboard")
                            .font(.caption.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)

                    Button(action: performImport) {
                        Label(NSLocalizedString("backup.import.button", comment: ""), systemImage: "tray.and.arrow.down.fill")
                            .font(.caption.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(jsonImportText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.3) : ShieldTheme.Colors.success)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(jsonImportText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func prepareExportJSON() -> String {
        do {
            return try RuleBackupManager.shared.exportToJSON(
                blocked: blockedNumbers,
                allowed: allowedNumbers,
                filterRules: filterRules,
                numberFilterRules: numberFilterRules
            )
        } catch {
            return "{}"
        }
    }

    private func pasteFromClipboard() {
        if let text = UIPasteboard.general.string {
            jsonImportText = text
        }
    }

    private func performImport() {
        do {
            let summary = try RuleBackupManager.shared.importFromJSON(
                jsonImportText,
                existingBlocked: blockedNumbers,
                existingAllowed: allowedNumbers,
                existingFilterRules: filterRules,
                existingNumberRules: numberFilterRules,
                modelContext: modelContext
            )

            importSuccessMessage = String(
                format: NSLocalizedString("backup.import.success", comment: ""),
                summary.blockedCount,
                summary.allowedCount,
                summary.filterRuleCount,
                summary.numberFilterRuleCount
            )
            jsonImportText = ""
        } catch {
            importErrorMessage = error.localizedDescription
        }
    }
}
