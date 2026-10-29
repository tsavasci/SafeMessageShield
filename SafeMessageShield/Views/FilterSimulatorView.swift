//
//  FilterSimulatorView.swift
//  SafeMessageShield
//

import SwiftUI
import SwiftData

/// Canlı SMS ve Gönderen Filtre Simülatörü
struct FilterSimulatorView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var blockedNumbers: [BlockedNumber]
    @Query private var allowedNumbers: [AllowedNumber]
    @Query private var filterRules: [FilterRule]
    @Query private var numberFilterRules: [NumberFilterRule]
    @ObservedObject private var regionManager = RegionManager.shared

    @State private var senderInput: String = ""
    @State private var messageInput: String = ""
    @State private var result: FilterSimulationResult?
    @FocusState private var focusedField: Field?

    private enum Field {
        case sender, message
    }

    var body: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        headerCard
                        inputCard
                        presetSamplesCard
                        if let result {
                            resultCard(result)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle(NSLocalizedString("sim.title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "")) {
                        dismiss()
                    }
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
                    Image(systemName: "flask.fill")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("sim.header.title", comment: ""))
                        .font(.headline.weight(.semibold))
                    Text(NSLocalizedString("sim.header.subtitle", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private var inputCard: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                Text(NSLocalizedString("sim.input.title", comment: ""))
                    .font(.subheadline.weight(.bold))

                VStack(alignment: .leading, spacing: 6) {
                    Text(NSLocalizedString("sim.sender.label", comment: ""))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    TextField(NSLocalizedString("sim.sender.placeholder", comment: ""), text: $senderInput)
                        .focused($focusedField, equals: .sender)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(10)
                        .background(Color(.tertiarySystemFill), in: RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(NSLocalizedString("sim.message.label", comment: ""))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    TextEditor(text: $messageInput)
                        .focused($focusedField, equals: .message)
                        .frame(minHeight: 80)
                        .padding(6)
                        .background(Color(.tertiarySystemFill), in: RoundedRectangle(cornerRadius: 8))
                }

                Button(action: runSimulation) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                        Text(NSLocalizedString("sim.run.button", comment: ""))
                    }
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(ShieldTheme.Colors.primaryGradient)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(senderInput.trimmingCharacters(in: .whitespaces).isEmpty && messageInput.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private var presetSamplesCard: some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(NSLocalizedString("sim.samples.title", comment: ""))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        sampleChip(
                            title: NSLocalizedString("sim.sample.casino", comment: ""),
                            sender: "BET999",
                            message: NSLocalizedString("sim.sample.casino.body", comment: "")
                        )
                        sampleChip(
                            title: NSLocalizedString("sim.sample.delivery", comment: ""),
                            sender: "+905550001122",
                            message: NSLocalizedString("sim.sample.delivery.body", comment: "")
                        )
                        sampleChip(
                            title: NSLocalizedString("sim.sample.bank", comment: ""),
                            sender: "BANKASI",
                            message: NSLocalizedString("sim.sample.bank.body", comment: "")
                        )
                    }
                }
            }
        }
    }

    private func sampleChip(title: String, sender: String, message: String) -> some View {
        Button(action: {
            senderInput = sender
            messageInput = message
            runSimulation()
        }) {
            HStack(spacing: 6) {
                Image(systemName: "text.bubble.fill")
                    .font(.caption2)
                Text(title)
                    .font(.caption.weight(.medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(ShieldTheme.Colors.primary.opacity(0.12), in: Capsule())
            .foregroundStyle(ShieldTheme.Colors.primary)
        }
        .buttonStyle(.plain)
    }

    private func resultCard(_ res: FilterSimulationResult) -> some View {
        ShieldCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(res.color.opacity(0.15))
                            .frame(width: 48, height: 48)
                        Image(systemName: res.sfSymbol)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(res.color)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(res.badgeTitle)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(res.color)
                        Text(res.actionSummary)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                Divider()

                VStack(alignment: .leading, spacing: 6) {
                    Text(NSLocalizedString("sim.result.reason", comment: ""))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                    Text(res.explanation)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }

                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(NSLocalizedString("sim.result.note", comment: ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 4)
            }
        }
    }

    private func runSimulation() {
        focusedField = nil

        let blocked = blockedNumbers.map { $0.phoneNumber }
        let allowed = allowedNumbers.map { $0.phoneNumber }
        let filterKws = filterRules.map { (keyword: $0.keyword, category: $0.category) }
        let numRules = numberFilterRules.map { (type: $0.ruleType, value: $0.value) }
        let region = PhoneNumberService.shared.dialingRegion(for: regionManager.regionCode)

        let simResult = FilterSimulatorEngine.shared.simulate(
            sender: senderInput,
            messageBody: messageInput,
            allowedNumbers: allowed,
            blockedNumbers: blocked,
            filterRules: filterKws,
            numberFilterRules: numRules,
            region: region
        )

        withAnimation {
            self.result = simResult
        }

        // Başarılı simülasyon bir pozitif aksiyondur
        StoreReviewManager.shared.recordPositiveAction()
    }
}
