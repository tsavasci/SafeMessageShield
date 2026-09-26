//
//  ShieldDesignSystem.swift
//  SafeMessageShield
//

import SwiftUI

enum ShieldTheme {
    enum Colors {
        static let primary = Color(red: 0.12, green: 0.32, blue: 0.92)
        static let secondary = Color(red: 0.00, green: 0.62, blue: 0.66)
        static let success = Color(red: 0.08, green: 0.62, blue: 0.36)
        static let warning = Color(red: 0.94, green: 0.58, blue: 0.10)
        static let danger = Color(red: 0.86, green: 0.20, blue: 0.22)
        static let muted = Color(.secondarySystemBackground)

        static let primaryGradient = LinearGradient(
            colors: [primary, secondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let surfaceGradient = LinearGradient(
            colors: [
                Color(.systemBackground),
                Color(.systemBackground).opacity(0.95),
                primary.opacity(0.035)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    enum Radius {
        static let medium: CGFloat = 14
        static let large: CGFloat = 18
        static let xLarge: CGFloat = 24
    }

    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let base: CGFloat = 16
        static let large: CGFloat = 20
    }
}

struct ShieldSurface<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            ShieldTheme.Colors.surfaceGradient
                .ignoresSafeArea()

            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .fill(ShieldTheme.Colors.primary.opacity(0.045))
                .blur(radius: 42)
                .frame(width: 280, height: 280)
                .offset(x: -130, y: -300)

            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .fill(ShieldTheme.Colors.secondary.opacity(0.05))
                .blur(radius: 54)
                .frame(width: 230, height: 230)
                .offset(x: 150, y: -90)

            content
        }
    }
}

struct ShieldCard<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    let padding: CGFloat
    let content: Content

    init(padding: CGFloat = ShieldTheme.Spacing.base, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: ShieldTheme.Radius.large, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: ShieldTheme.Radius.large, style: .continuous)
                            .stroke(Color.white.opacity(colorScheme == .dark ? 0.12 : 0.46), lineWidth: 1)
                    )
            )
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.20 : 0.06),
                radius: colorScheme == .dark ? 12 : 8,
                x: 0,
                y: colorScheme == .dark ? 6 : 3
            )
    }
}

struct ShieldStatusPill: View {
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 7) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
    }
}

struct ShieldMetricCard: View {
    let title: String
    let value: String
    let systemImage: String
    let color: Color

    var body: some View {
        ShieldCard(padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(color)
                    .frame(width: 28, height: 28, alignment: .leading)
                    .accessibilityHidden(true)

                Text(value)
                    .font(.title2.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            // VoiceOver değeri ve başlığı tek öğe olarak okusun (ör. "0, Engellenen")
            .accessibilityElement(children: .combine)
        }
    }
}

struct ShieldActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            // Icon sits above the title so long single words (e.g. "Customization")
            // get the full button width instead of being truncated.
            VStack(alignment: .leading, spacing: 6) {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(color)
                    .accessibilityHidden(true)
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .foregroundStyle(.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .frame(minHeight: 48)
            .background(color.opacity(0.10), in: RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous)
                    .stroke(color.opacity(0.20), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ShieldEmptyState: View {
    let title: String
    let message: String
    let systemImage: String
    let color: Color

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(color.opacity(0.7))
                .accessibilityHidden(true)

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}

struct ShieldSegmentedPicker<Selection: Hashable>: View {
    let items: [(selection: Selection, title: String, systemImage: String)]
    @Binding var selection: Selection

    var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.selection) { item in
                Button {
                    withAnimation(.easeOut(duration: 0.16)) {
                        selection = item.selection
                    }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: item.systemImage)
                            .font(.subheadline.weight(.semibold))
                            // Sabit yükseklik: farklı sembollerde başlıklar aynı hizada kalsın
                            .frame(height: 20)
                            .accessibilityHidden(true)
                        Text(item.title)
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .foregroundStyle(selection == item.selection ? Color.white : Color.primary)
                    .background(
                        selection == item.selection
                            ? AnyShapeStyle(ShieldTheme.Colors.primaryGradient)
                            : AnyShapeStyle(Color.clear)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: ShieldTheme.Radius.medium, style: .continuous))
                }
                .buttonStyle(.plain)
                // Expose only the title; some SF Symbols (e.g. checkmark.shield) otherwise
                // leak a "selected" trait into the button regardless of the actual selection.
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(item.title)
                .accessibilityAddTraits(selection == item.selection ? [.isButton, .isSelected] : .isButton)
                .accessibilityRemoveTraits(selection == item.selection ? [] : .isSelected)
            }
        }
        .padding(6)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: ShieldTheme.Radius.large, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: ShieldTheme.Radius.large, style: .continuous)
                .stroke(Color.white.opacity(0.28), lineWidth: 1)
        )
    }
}
