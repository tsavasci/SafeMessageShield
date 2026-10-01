import SwiftUI

/// Mesajlar/Telefon'dan bildirme rehberi.
/// iOS, bildirme eklentisinin uygulamayla veri paylaşmasına izin vermez; bu yüzden bildirilen
/// göndericiler burada listelenemez. Eklenti engellemeyi iOS'a bırakır (Engellenen Kişiler).
struct ReportedJunkView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingAddNumberSheet = false

    var body: some View {
        NavigationStack {
            ShieldSurface {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ShieldCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text(NSLocalizedString("reported.guide.how.title", comment: ""))
                                    .font(.headline.weight(.semibold))
                                stepRow(number: 1, text: NSLocalizedString("reported.guide.step1", comment: ""))
                                stepRow(number: 2, text: NSLocalizedString("reported.guide.step2", comment: ""))
                                stepRow(number: 3, text: NSLocalizedString("reported.guide.step3", comment: ""))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        infoCard(
                            title: NSLocalizedString("reported.guide.blocked.title", comment: ""),
                            message: NSLocalizedString("reported.guide.blocked.message", comment: ""),
                            systemImage: "hand.raised.slash.fill",
                            color: ShieldTheme.Colors.danger
                        )

                        ShieldCard {
                            VStack(alignment: .leading, spacing: 12) {
                                infoContent(
                                    title: NSLocalizedString("reported.guide.app.title", comment: ""),
                                    message: NSLocalizedString("reported.guide.app.message", comment: ""),
                                    systemImage: "shield.lefthalf.filled",
                                    color: ShieldTheme.Colors.primary
                                )
                                ShieldActionButton(title: NSLocalizedString("menu.manual", comment: ""), systemImage: "square.and.pencil", color: ShieldTheme.Colors.danger) {
                                    showingAddNumberSheet = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 32)
                }
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
            .sheet(isPresented: $showingAddNumberSheet) {
                AddNumberView()
                    .appLanguageEnvironment()
            }
        }
    }

    private func stepRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(ShieldTheme.Colors.primary, in: Circle())
                .accessibilityHidden(true)
            Text(text)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func infoCard(title: String, message: String, systemImage: String, color: Color) -> some View {
        ShieldCard {
            infoContent(title: title, message: message, systemImage: systemImage, color: color)
        }
    }

    private func infoContent(title: String, message: String, systemImage: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 30)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.semibold))
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ReportedJunkView()
}
