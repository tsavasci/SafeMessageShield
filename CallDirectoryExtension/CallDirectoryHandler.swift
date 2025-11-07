//
//  CallDirectoryHandler.swift
//  CallDirectoryExtension
//
//  Created by Tamer Savaşcı on 6.11.2025.
//

import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        addAllBlockingPhoneNumbers(to: context)
        context.completeRequest()
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        guard let sharedDefaults = UserDefaults(suiteName: "group.tsavasci.SafeMessageShield") else {
            return
        }
        
        let blockedNumbers = sharedDefaults.array(forKey: "blockedNumbers") as? [String] ?? []
        var phoneNumbers: [CXCallDirectoryPhoneNumber] = []
        
        for number in blockedNumbers {
            var cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            // Türk numarası formatı: 0 ile başlayan 11 haneyi 90xxx formatına çevir
            if cleanNumber.hasPrefix("0") && cleanNumber.count == 11 {
                cleanNumber = "90" + cleanNumber.dropFirst()
            }
            
            if let phoneNumber = CXCallDirectoryPhoneNumber(cleanNumber) {
                phoneNumbers.append(phoneNumber)
            }
        }
        
        phoneNumbers.sort()
        
        for phoneNumber in phoneNumbers {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }

    private func addOrRemoveIncrementalBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Incremental update not supported
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Caller identification not used
    }

    private func addOrRemoveIncrementalIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Incremental identification not supported
    }

}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // Error handling
    }
}
