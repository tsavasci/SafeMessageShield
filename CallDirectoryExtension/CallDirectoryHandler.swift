//
//  CallDirectoryHandler.swift
//  CallDirectoryExtension
//
//  Created by Tamer Savaşcı on 5.11.2025.
//

import Foundation
import CallKit

/// App Group ID - Ana uygulama ile veri paylaşımı için
let kAppGroupIdentifier = "group.tsavasci.SafeMessageShield"

class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        NSLog("🛡️ SafeMessageShield: CallDirectory güncelleniyor...")

        // Check whether this is an "incremental" data request. If so, only provide the set of phone number blocking
        // and identification entries which have been added or removed since the last time this extension's data was loaded.
        // But the extension must still be prepared to provide the full set of data at any time, so add all blocking
        // and identification phone numbers if the request is not incremental.
        if context.isIncremental {
            addOrRemoveIncrementalBlockingPhoneNumbers(to: context)

            addOrRemoveIncrementalIdentificationPhoneNumbers(to: context)
        } else {
            addAllBlockingPhoneNumbers(to: context)

            addAllIdentificationPhoneNumbers(to: context)
        }

        context.completeRequest()
        NSLog("🛡️ SafeMessageShield: CallDirectory güncelleme tamamlandı")
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // App Group'tan engellenen numaraları al
        guard let userDefaults = UserDefaults(suiteName: kAppGroupIdentifier),
              let blockedNumbers = userDefaults.stringArray(forKey: "blockedNumbers") else {
            NSLog("🛡️ SafeMessageShield: Engellenen numara bulunamadı")
            return
        }
        
        // Numaraları CXCallDirectoryPhoneNumber formatına çevir ve sırala
        var phoneNumbers: [CXCallDirectoryPhoneNumber] = []
        
        for numberString in blockedNumbers {
            // Numarayı temizle (sadece rakamlar)
            let cleanNumber = numberString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            // + işareti varsa kaldır ve direkt sayıya çevir
            if let phoneNumber = CXCallDirectoryPhoneNumber(cleanNumber) {
                phoneNumbers.append(phoneNumber)
            }
        }
        
        // Numaraları sırala (CallKit gereksinimi)
        phoneNumbers.sort()
        
        // Numaraları ekle
        for phoneNumber in phoneNumbers {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
        
        NSLog("🛡️ SafeMessageShield: \(phoneNumbers.count) numara engelleme listesine eklendi")
    }

    private func addOrRemoveIncrementalBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = [ 1_408_555_1234 ]
        for phoneNumber in phoneNumbersToAdd {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }

        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = [ 1_800_555_5555 ]
        for phoneNumber in phoneNumbersToRemove {
            context.removeBlockingEntry(withPhoneNumber: phoneNumber)
        }

        // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        let allPhoneNumbers: [CXCallDirectoryPhoneNumber] = [ 1_877_555_5555, 1_888_555_5555 ]
        let labels = [ "Telemarketer", "Local business" ]

        for (phoneNumber, label) in zip(allPhoneNumbers, labels) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }
    }

    private func addOrRemoveIncrementalIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve any changes to the set of phone numbers to identify (and their identification labels) from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = [ 1_408_555_5678 ]
        let labelsToAdd = [ "New local business" ]

        for (phoneNumber, label) in zip(phoneNumbersToAdd, labelsToAdd) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }

        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = [ 1_888_555_5555 ]

        for phoneNumber in phoneNumbersToRemove {
            context.removeIdentificationEntry(withPhoneNumber: phoneNumber)
        }

        // Record the most-recently loaded set of identification entries in data store for the next incremental load...
    }

}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occurred while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }

}
