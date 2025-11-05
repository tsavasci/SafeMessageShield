//
//  StatisticsView.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query private var blockedNumbers: [BlockedNumber]
    @State private var smsFilterCount = 0
    @State private var callBlockCount = 0
    @State private var lastSMSFilterDate: Date?
    @State private var lastCallBlockDate: Date?
    @State private var activeDays = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Özet Kartı
                    SummaryCard(
                        totalBlocked: blockedNumbers.count,
                        smsFiltered: smsFilterCount,
                        callsBlocked: callBlockCount,
                        activeDays: activeDays
                    )
                    .padding(.horizontal)
                    
                    // Detaylı İstatistikler
                    VStack(spacing: 16) {
                        StatisticRow(
                            icon: "message.badge.filled.fill",
                            title: "SMS Filtreleme",
                            value: "\(smsFilterCount)",
                            subtitle: lastActivityText(for: lastSMSFilterDate, prefix: "Son: "),
                            color: .blue
                        )
                        
                        StatisticRow(
                            icon: "phone.down.fill",
                            title: "Arama Engelleme",
                            value: "\(callBlockCount)",
                            subtitle: "iOS tarafından otomatik engellenir",
                            color: .red
                        )
                        
                        StatisticRow(
                            icon: "list.bullet.rectangle",
                            title: "Engellenen Numara",
                            value: "\(blockedNumbers.count)",
                            subtitle: "Listedeki toplam numara",
                            color: .orange
                        )
                        
                        StatisticRow(
                            icon: "calendar.badge.clock",
                            title: "Aktif Koruma",
                            value: "\(activeDays) gün",
                            subtitle: "Uygulamayı yüklediğinizden beri",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Bilgilendirme
                    InfoCard()
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .padding(.vertical)
            }
            .navigationTitle("İstatistikler")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                loadStatistics()
            }
            .refreshable {
                loadStatistics()
            }
        }
    }
    
    private func loadStatistics() {
        smsFilterCount = DataManager.shared.getTotalSMSFilterCount()
        callBlockCount = DataManager.shared.getTotalCallBlockCount()
        lastSMSFilterDate = DataManager.shared.getLastSMSFilterDate()
        lastCallBlockDate = DataManager.shared.getLastCallBlockDate()
        activeDays = DataManager.shared.getActiveDays()
    }
    
    private func lastActivityText(for date: Date?, prefix: String) -> String {
        guard let date = date else {
            return "Henüz aktivite yok"
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return prefix + formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Summary Card
struct SummaryCard: View {
    let totalBlocked: Int
    let smsFiltered: Int
    let callsBlocked: Int
    let activeDays: Int
    
    var totalProtection: Int {
        return smsFiltered + callsBlocked
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Ana Sayaç
            VStack(spacing: 8) {
                Image(systemName: "shield.checkered")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("\(totalProtection)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Toplam Koruma")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            // Hızlı İstatistikler
            HStack(spacing: 20) {
                QuickStat(value: "\(smsFiltered)", label: "SMS")
                QuickStat(value: "\(callsBlocked)", label: "Arama")
                QuickStat(value: "\(totalBlocked)", label: "Engelli")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

// MARK: - Quick Stat
struct QuickStat: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Statistic Row
struct StatisticRow: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // İkon
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.15))
                .cornerRadius(10)
            
            // İçerik
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Info Card
struct InfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.blue)
                Text("Nasıl Çalışır?")
                    .font(.headline)
            }
            
            Text("SMS filtreleme sayısı, extension'ın engellediği mesajların gerçek zamanlı kaydıdır. Arama engelleme ise iOS tarafından otomatik olarak yapılır ve tam sayıya erişim yoktur.")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Divider()
            
            HStack {
                Image(systemName: "arrow.clockwise")
                    .foregroundStyle(.green)
                Text("Aşağı çekerek güncelleyin")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: BlockedNumber.self, inMemory: true)
}
