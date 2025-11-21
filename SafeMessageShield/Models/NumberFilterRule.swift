//
//  NumberFilterRule.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 21.11.2025.
//

import Foundation
import SwiftData

@Model
final class NumberFilterRule {
    @Attribute(.unique) var id: String
    var ruleType: String // "prefix", "suffix", "contains"
    var value: String
    var addedAt: Date
    
    init(ruleType: String, value: String) {
        self.id = UUID().uuidString
        self.ruleType = ruleType
        self.value = value
        self.addedAt = Date()
    }
}
