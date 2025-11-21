import SwiftUI

struct ReportedJunkView: View {
    @State private var lastSender: String? = nil
    @State private var message: String? = nil
    @State private var showingAlert = false

    private let suite = "group.tsavasci.SafeMessageShield"

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let sender = lastSender {
                    Text(NSLocalizedString("last.filtered.sender", comment: "Last filtered sender"))
                        .font(.headline)
                    Text(sender)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button(action: markNotJunk) {
                        HStack {
                            Image(systemName: "checkmark.shield")
                            Text(NSLocalizedString("mark.notjunk", comment: "Mark as Not Junk"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                } else {
                    Text(NSLocalizedString("no.recent.junk", comment: "No recent junk sender"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let msg = message {
                    Text(msg)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding()
            .navigationTitle(NSLocalizedString("reported.junk", comment: "Reported Junk"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { }
                }
            }
            .onAppear(perform: loadLastSender)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(NSLocalizedString("done", comment: "Done")), message: Text(message ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func loadLastSender() {
        guard let ud = UserDefaults(suiteName: suite) else { return }
        lastSender = ud.string(forKey: "lastJunkSender")
    }

    private func markNotJunk() {
        guard let sender = lastSender else { return }
        // clean number to canonical form
        let cleaned = sender.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        // Add to allowed numbers
        DataManager.shared.addAllowedNumber(cleaned)
        // Optionally remove from blocked list
        DataManager.shared.removeBlockedNumber(cleaned)
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
