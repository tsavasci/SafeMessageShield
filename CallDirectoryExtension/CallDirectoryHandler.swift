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
        var phoneNumbers: Set<CXCallDirectoryPhoneNumber> = []
        
        for number in blockedNumbers {
            let cleanNumber = PhoneNumberNormalizer.normalize(number)
            
            // E.164 en fazla 15 hanedir. Çok kısa ve hatalı değerleri CallKit'e verme.
            if PhoneNumberNormalizer.isValidCallDirectoryNumber(cleanNumber),
               let phoneNumber = CXCallDirectoryPhoneNumber(cleanNumber),
               phoneNumber > 0 {
                phoneNumbers.insert(phoneNumber)
            }
        }

        for phoneNumber in phoneNumbers.sorted() {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }

        sharedDefaults.set(Date(), forKey: "lastCallDirectoryLoadDate")
        sharedDefaults.removeObject(forKey: "lastCallDirectoryError")
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
        UserDefaults(suiteName: "group.tsavasci.SafeMessageShield")?
            .set(error.localizedDescription, forKey: "lastCallDirectoryError")
    }
}
