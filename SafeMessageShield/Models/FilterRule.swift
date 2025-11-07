//
//  FilterRule.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 7.11.2025.
//

import Foundation
import SwiftData

@Model
final class FilterRule {
    var id: UUID
    var keyword: String
    var category: String // iOS kategori identifier'ı
    var createdAt: Date
    
    init(keyword: String, category: String, createdAt: Date = Date()) {
        self.id = UUID()
        self.keyword = keyword.lowercased() // Case-insensitive olması için
        self.category = category
        self.createdAt = createdAt
    }
}

// iOS Kategori tanımları
enum MessageCategory: String, CaseIterable, Identifiable {
    // Transactional (İşlemler)
    case transactionalFinance = "transactionalFinance"
    case transactionalOrders = "transactionalOrders"
    case transactionalReminders = "transactionalReminders"
    case transactionalHealth = "transactionalHealth"
    case transactionalWeather = "transactionalWeather"
    case transactionalCarrier = "transactionalCarrier"
    case transactionalRewards = "transactionalRewards"
    case transactionalPublicServices = "transactionalPublicServices"
    case transactionalOthers = "transactionalOthers"
    
    // Promotional (Promosyonlar)
    case promotionalOffers = "promotionalOffers"
    case promotionalCoupons = "promotionalCoupons"
    case promotionalOthers = "promotionalOthers"
    
    var id: String { rawValue }
    
    var localizedName: String {
        switch self {
        case .transactionalFinance:
            return NSLocalizedString("category.finance", comment: "")
        case .transactionalOrders:
            return NSLocalizedString("category.orders", comment: "")
        case .transactionalReminders:
            return NSLocalizedString("category.reminders", comment: "")
        case .transactionalHealth:
            return NSLocalizedString("category.health", comment: "")
        case .transactionalWeather:
            return NSLocalizedString("category.weather", comment: "")
        case .transactionalCarrier:
            return NSLocalizedString("category.carrier", comment: "")
        case .transactionalRewards:
            return NSLocalizedString("category.rewards", comment: "")
        case .transactionalPublicServices:
            return NSLocalizedString("category.public_services", comment: "")
        case .transactionalOthers:
            return NSLocalizedString("category.transaction_others", comment: "")
        case .promotionalOffers:
            return NSLocalizedString("category.offers", comment: "")
        case .promotionalCoupons:
            return NSLocalizedString("category.coupons", comment: "")
        case .promotionalOthers:
            return NSLocalizedString("category.promotion_others", comment: "")
        }
    }
    
    var icon: String {
        switch self {
        case .transactionalFinance:
            return "banknote"
        case .transactionalOrders:
            return "shippingbox"
        case .transactionalReminders:
            return "bell"
        case .transactionalHealth:
            return "cross.case"
        case .transactionalWeather:
            return "cloud.sun"
        case .transactionalCarrier:
            return "antenna.radiowaves.left.and.right"
        case .transactionalRewards:
            return "gift"
        case .transactionalPublicServices:
            return "building.2"
        case .transactionalOthers:
            return "ellipsis.circle"
        case .promotionalOffers:
            return "tag"
        case .promotionalCoupons:
            return "ticket"
        case .promotionalOthers:
            return "sparkles"
        }
    }
}
