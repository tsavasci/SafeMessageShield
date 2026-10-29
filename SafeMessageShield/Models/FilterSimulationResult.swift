//
//  FilterSimulationResult.swift
//  SafeMessageShield
//

import Foundation
import SwiftUI

/// Simülatör karar sonucu
nonisolated enum FilterSimulationOutcome: Equatable, Sendable {
    case allowedByWhitelist(String)
    case blockedByBlocklist(String)
    case blockedByNumberRule(ruleType: String, pattern: String)
    case filteredByKeyword(keyword: String, categoryName: String)
    case allowedDefault

    var isBlockedOrFiltered: Bool {
        switch self {
        case .allowedByWhitelist, .allowedDefault:
            return false
        case .blockedByBlocklist, .blockedByNumberRule, .filteredByKeyword:
            return true
        }
    }

    var badgeTitleKey: String {
        switch self {
        case .allowedByWhitelist:
            return "sim.outcome.allowed.safe"
        case .blockedByBlocklist:
            return "sim.outcome.blocked.number"
        case .blockedByNumberRule:
            return "sim.outcome.blocked.pattern"
        case .filteredByKeyword:
            return "sim.outcome.filtered.keyword"
        case .allowedDefault:
            return "sim.outcome.allowed.inbox"
        }
    }

    var iconName: String {
        switch self {
        case .allowedByWhitelist:
            return "checkmark.shield.fill"
        case .blockedByBlocklist, .blockedByNumberRule:
            return "xmark.shield.fill"
        case .filteredByKeyword:
            return "tray.and.arrow.down.fill"
        case .allowedDefault:
            return "envelope.badge.shield.half.filled"
        }
    }

    var badgeColor: Color {
        switch self {
        case .allowedByWhitelist:
            return ShieldTheme.Colors.success
        case .blockedByBlocklist, .blockedByNumberRule:
            return ShieldTheme.Colors.danger
        case .filteredByKeyword:
            return ShieldTheme.Colors.warning
        case .allowedDefault:
            return ShieldTheme.Colors.primary
        }
    }
}

/// Simülasyon detaylı sonucu
nonisolated struct FilterSimulationResult: Equatable, Sendable {
    let outcome: FilterSimulationOutcome
    let explanation: String
    let senderEvaluated: String
    let messageBodyEvaluated: String

    var color: Color {
        outcome.badgeColor
    }

    var sfSymbol: String {
        outcome.iconName
    }

    var badgeTitle: String {
        NSLocalizedString(outcome.badgeTitleKey, comment: "")
    }

    var actionSummary: String {
        if outcome.isBlockedOrFiltered {
            return NSLocalizedString("sim.action.blocked", comment: "")
        } else {
            return NSLocalizedString("sim.action.passed", comment: "")
        }
    }
}
