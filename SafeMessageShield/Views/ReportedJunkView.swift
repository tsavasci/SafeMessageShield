import SwiftUI
import SwiftData

struct ReportedJunkView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var lastSender: String? = nil
    @State private var message: String? = nil
    @State private var showingAlert = false

    private let suite = "group.tsavasci.SafeMessageShield"

    var body: some View {
        NavigationStack {
            ShieldSurface {
                VStack(spacing: 16) {
                    if let sender = lastSender {
                        ShieldCard {
                            VStack(spacing: 14) {
                                Text(NSLocalizedString("last.filtered.sender", comment: "Last filtered sender"))
                                    .font(.headline.weight(.semibold))
                                Text(sender)
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)

                                Button(action: markNotJunk) {
                                    Label(NSLocalizedString("mark.notjunk", comment: "Mark as Not Junk"), systemImage: "checkmark.shield.fill")
                                        .font(.subheadline.weight(.semibold))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(ShieldTheme.Colors.primaryGradient)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    } else {
                        ShieldCard {
                            ShieldEmptyState(
                                title: NSLocalizedString("no.recent.junk", comment: "No recent junk sender"),
                                message: NSLocalizedString("dashboard.setup.waiting.activity", comment: ""),
                                systemImage: "tray",
                                color: ShieldTheme.Colors.warning
                            )
                        }
                    }

                    if let msg = message {
                        Text(msg)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
            }
            .navigationTitle(NSLocalizedString("reported.junk", comment: "Reported Junk"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "Close")) {
                        dismiss()
                    }
                }
            }
            .onAppear(perform: loadLastSender)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(NSLocalizedString("done", comment: "Done")),
                    message: Text(message ?? ""),
                    dismissButton: .default(Text(NSLocalizedString("ok", comment: "OK")))
                )
            }
        }
    }

    private func loadLastSender() {
        guard let ud = UserDefaults(suiteName: suite) else { return }
        lastSender = ud.string(forKey: "lastJunkSender")
    }

    private func markNotJunk() {
        guard let sender = lastSender else { return }
        // Gönderen yerel biçimde gelmiş olabilir; varsayılan ülkeye göre çöz, çözülemezse olduğu gibi kullan
        let value: String
        if case .success(let entry) = RegionManager.shared.entry(for: sender) {
            value = entry.storageValue
        } else {
            value = sender
        }
        // Add to allowed numbers
        DataManager.shared.addAllowedNumber(value, modelContext: modelContext)
        // Optionally remove from blocked list
        DataManager.shared.removeBlockedNumber(value, modelContext: modelContext)
        // Clear last sender
        if let ud = UserDefaults(suiteName: suite) {
            ud.removeObject(forKey: "lastJunkSender")
        }
        message = String(format: NSLocalizedString("marked.notjunk.message", comment: "Marked as not junk"), sender)
        showingAlert = true
        lastSender = nil
    }
}

#Preview {
    ReportedJunkView()
}
