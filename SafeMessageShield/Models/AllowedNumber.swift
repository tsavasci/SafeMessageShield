//
//  AllowedNumber.swift
//  SafeMessageShield
//
//  Created by Tamer Savaşcı on 7.11.2025.
//

import Foundation
import SwiftData

@Model
final class AllowedNumber {
    var phoneNumber: String
    var addedAt: Date
    var reason: String?
    
    init(phoneNumber: String, addedAt: Date = Date(), reason: String? = nil) {
        self.phoneNumber = phoneNumber
        self.addedAt = addedAt
        self.reason = reason
    }
}
