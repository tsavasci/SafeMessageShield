//
//  SetupGuideView.swift
//  SafeMessageShield
//

import CallKit
import SwiftUI

/// İnteraktif Kurulum, Doğrulama ve Teşhis Rehberi
struct SetupGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var callBlockingStatus: CXCallDirectoryManager.EnabledStatus = .unknown
    @State private var isFilterConfirmed: Bool = false
    @State private var showingPresets = false
    @State private var showingSimulator = false

    var body: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        heroStatusCard
                        step1Card
                        step2Card
                        step3Card
                        step4Card
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle(NSLocalizedString("guide.nav.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "")) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                checkStatuses()
            }
            .sheet(isPresented: $showingPresets) {
                ProtectionPresetsView()
                    .appLanguageEnvironment()
            }
            .sheet(isPresented: $showingSimulator) {
                FilterSimulatorView()
                    .appLanguageEnvironment()
            }
        }
    }

    private var heroStatusCard: some View {
        let isAllDone = isFilterConfirmed && callBlockingStatus == .enabled

        return ShieldCard {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isAllDone ? AnyShapeStyle(ShieldTheme.Colors.success) : AnyShapeStyle(ShieldTheme.Colors.primaryGradient))
                        .frame(width: 54, height: 54)
                    Image(systemName: isAllDone ? "checkmark.seal.fill" : "wand.and.stars")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(isAllDone ? NSLocalizedString("guide.all.ready.title", comment: "") : NSLocalizedString("guide.header.title", comment: ""))
                        .font(.headline.weight(.semibold))
                    Text(isAllDone ? NSLocalizedString("guide.all.ready.subtitle", comment: "") : NSLocalizedString("guide.header.subtitle", comment: ""))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var step1Card: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(NSLocalizedString("guide.step1.title", comment: ""), systemImage: "message.fill")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(ShieldTheme.Colors.primary)
                    Spacer()
                    ShieldStatusPill(
                        title: isFilterConfirmed ? NSLocalizedString("guide.status.active", comment: "") : NSLocalizedString("guide.status.pending", comment: ""),
                        color: isFilterConfirmed ? ShieldTheme.Colors.success : ShieldTheme.Colors.warning
                    )
                }

                Text(NSLocalizedString("guide.step1.desc", comment: ""))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    Button(action: SystemSettingsNavigator.openAppSettings) {
                        Label(NSLocalizedString("open.settings", comment: ""), systemImage: "arrow.up.forward.app.fill")
                            .font(.caption.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                            .background(ShieldTheme.Colors.primary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(ShieldTheme.Colors.primary)
                    }
                    .buttonStyle(.plain)

                    Button(action: {
                        DataManager.shared.setFilterEnabled(true)
                        isFilterConfirmed = true
                    }) {
                        Text(isFilterConfirmed ? NSLocalizedString("guide.confirmed", comment: "") : NSLocalizedString("guide.confirm", comment: ""))
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 14)
                            .frame(height: 38)
                            .background(isFilterConfirmed ? ShieldTheme.Colors.success.opacity(0.12) : ShieldTheme.Colors.primary)
                            .foregroundStyle(isFilterConfirmed ? ShieldTheme.Colors.success : .white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var step2Card: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(NSLocalizedString("guide.step2.title", comment: ""), systemImage: "phone.fill")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(ShieldTheme.Colors.success)
                    Spacer()
                    ShieldStatusPill(
                        title: callBlockingStatus == .enabled ? NSLocalizedString("guide.status.active", comment: "") : NSLocalizedString("guide.status.pending", comment: ""),
                        color: callBlockingStatus == .enabled ? ShieldTheme.Colors.success : ShieldTheme.Colors.warning
                    )
                }

                Text(NSLocalizedString("guide.step2.desc", comment: ""))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: SystemSettingsNavigator.openCallBlockingSettings) {
                    Label(NSLocalizedString("open.settings", comment: ""), systemImage: "arrow.up.forward.app.fill")
                        .font(.caption.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background(ShieldTheme.Colors.success.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(ShieldTheme.Colors.success)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var step3Card: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(NSLocalizedString("guide.step3.title", comment: ""), systemImage: "sparkles")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(ShieldTheme.Colors.secondary)
                    Spacer()
                }

                Text(NSLocalizedString("guide.step3.desc", comment: ""))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: { showingPresets = true }) {
                    Label(NSLocalizedString("presets.nav.title", comment: ""), systemImage: "sparkles.rectangle.stack.fill")
                        .font(.caption.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background(ShieldTheme.Colors.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(ShieldTheme.Colors.secondary)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var step4Card: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(NSLocalizedString("guide.step4.title", comment: ""), systemImage: "flask.fill")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(ShieldTheme.Colors.warning)
                    Spacer()
                }

                Text(NSLocalizedString("guide.step4.desc", comment: ""))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: { showingSimulator = true }) {
                    Label(NSLocalizedString("sim.title", comment: ""), systemImage: "play.circle.fill")
                        .font(.caption.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background(ShieldTheme.Colors.warning.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(ShieldTheme.Colors.warning)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func checkStatuses() {
        isFilterConfirmed = DataManager.shared.isFilterEnabled()
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: "tsavasci.SafeMessageShield.CallDirectoryExtension") { status, _ in
            DispatchQueue.main.async {
                self.callBlockingStatus = status
            }
        }
    }
}
