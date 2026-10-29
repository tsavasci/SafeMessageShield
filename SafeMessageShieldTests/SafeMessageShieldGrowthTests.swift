//
//  SafeMessageShieldGrowthTests.swift
//  SafeMessageShieldTests
//

import XCTest
@testable import SafeMessageShield

@MainActor
final class SafeMessageShieldGrowthTests: XCTestCase {

    // MARK: - StoreReviewManager Tests

    @MainActor
    func testStoreReviewMilestoneAndCooldown() async {
        let testDefaults = UserDefaults(suiteName: "TestStoreReviewDefaults_\(UUID().uuidString)")!
        var reviewRequestedCount = 0

        let manager = StoreReviewManager(
            userDefaults: testDefaults,
            dateProvider: { Date() },
            versionProvider: { "2.0.0" },
            reviewRequester: {
                reviewRequestedCount += 1
            }
        )

        // Actions 1 to 2: No review requested (milestone is 3)
        manager.recordPositiveAction()
        XCTAssertEqual(reviewRequestedCount, 0)
        XCTAssertEqual(manager.actionCount, 1)

        manager.recordPositiveAction()
        XCTAssertEqual(reviewRequestedCount, 0)
        XCTAssertEqual(manager.actionCount, 2)

        // Action 3: Hits milestone! Review requested
        manager.recordPositiveAction()
        XCTAssertEqual(reviewRequestedCount, 1)
        XCTAssertEqual(manager.actionCount, 3)

        // Action 4: Cooldown active, same version -> should NOT trigger again
        manager.recordPositiveAction()
        XCTAssertEqual(reviewRequestedCount, 1)
        XCTAssertEqual(manager.actionCount, 4)
    }

    @MainActor
    func testStoreReviewTriggersOnNewVersionAfterCooldown() async {
        let testDefaults = UserDefaults(suiteName: "TestStoreReviewDefaults_Version_\(UUID().uuidString)")!
        var reviewRequestedCount = 0

        var currentVersion = "2.0.0"
        let manager = StoreReviewManager(
            userDefaults: testDefaults,
            dateProvider: { Date() },
            versionProvider: { currentVersion },
            reviewRequester: {
                reviewRequestedCount += 1
            }
        )

        // Fill up to milestone 3
        manager.recordPositiveAction()
        manager.recordPositiveAction()
        manager.recordPositiveAction()
        XCTAssertEqual(reviewRequestedCount, 1)

        // Same version -> should not prompt even if cooldown passed
        let pastDate = Date().addingTimeInterval(-40 * 24 * 3600) // 40 days ago (> 30 days cooldown)
        testDefaults.set(pastDate, forKey: StoreReviewManager.lastPromptDateKey)

        manager.recordPositiveAction()
        XCTAssertEqual(reviewRequestedCount, 1)

        // Increment version to "2.1.0" with cooldown passed -> should trigger prompt!
        currentVersion = "2.1.0"
        testDefaults.set(pastDate, forKey: StoreReviewManager.lastPromptDateKey)

        manager.recordPositiveAction()
        XCTAssertEqual(reviewRequestedCount, 2)
    }

    // MARK: - ProtectionPresets Tests

    @MainActor
    func testProtectionPresetsDefinitions() async {
        let manager = ProtectionPresetManager.shared
        let presets = manager.presets

        XCTAssertEqual(presets.count, 5)
        XCTAssertTrue(presets.contains { $0.id == "betting_casino" })
        XCTAssertTrue(presets.contains { $0.id == "loan_phishing" })
        XCTAssertTrue(presets.contains { $0.id == "delivery_phishing" })
        XCTAssertTrue(presets.contains { $0.id == "lottery_scam" })
        XCTAssertTrue(presets.contains { $0.id == "crypto_job_scam" })

        // Check each preset has keywords for all 11 languages
        let requiredLangs = ["en", "tr", "de", "fr", "es", "ru", "ar", "ja", "ko", "zh-Hans", "hi"]
        for preset in presets {
            for lang in requiredLangs {
                let keywords = preset.keywords(for: lang)
                XCTAssertFalse(keywords.isEmpty, "Preset \(preset.id) missing keywords for \(lang)")
            }
        }
    }

    // MARK: - FilterSimulatorEngine Tests

    @MainActor
    func testSimulatorAllowedSenderOverridesEverything() async {
        let turkey = SafeMessageShield.DialingRegion(regionCode: "TR", countryCode: "90", nationalPrefix: "0")
        let result = FilterSimulatorEngine.shared.simulate(
            sender: "+90 555 123 4567",
            messageBody: "Kazandınız! 500 TL bonus ve bedava kupon için tıklayın: bit.ly/spam",
            allowedNumbers: ["905551234567"],
            blockedNumbers: ["905551234567"],
            filterRules: [(keyword: "bonus", category: "Junk"), (keyword: "kazandınız", category: "Promotion")],
            numberFilterRules: [(type: "prefix", value: "90555")],
            region: turkey
        )

        XCTAssertEqual(result.outcome, SafeMessageShield.FilterSimulationOutcome.allowedByWhitelist("905551234567"))
        XCTAssertFalse(result.outcome.isBlockedOrFiltered)
    }

    @MainActor
    func testSimulatorBlockedNumberDirectMatch() async {
        let turkey = SafeMessageShield.DialingRegion(regionCode: "TR", countryCode: "90", nationalPrefix: "0")
        let result = FilterSimulatorEngine.shared.simulate(
            sender: "0850 123 4567",
            messageBody: "Normal bir mesaj içeriği",
            allowedNumbers: [],
            blockedNumbers: ["908501234567"],
            filterRules: [],
            numberFilterRules: [],
            region: turkey
        )

        XCTAssertEqual(result.outcome, SafeMessageShield.FilterSimulationOutcome.blockedByBlocklist("908501234567"))
        XCTAssertTrue(result.outcome.isBlockedOrFiltered)
    }

    @MainActor
    func testSimulatorPatternPrefixRuleMatch() async {
        let turkey = SafeMessageShield.DialingRegion(regionCode: "TR", countryCode: "90", nationalPrefix: "0")
        let result = FilterSimulatorEngine.shared.simulate(
            sender: "+90 850 999 8877",
            messageBody: "Normal bir mesaj",
            allowedNumbers: [],
            blockedNumbers: [],
            filterRules: [],
            numberFilterRules: [(type: "prefix", value: "90850")],
            region: turkey
        )

        XCTAssertEqual(result.outcome, SafeMessageShield.FilterSimulationOutcome.blockedByNumberRule(ruleType: "prefix", pattern: "90850"))
        XCTAssertTrue(result.outcome.isBlockedOrFiltered)
    }

    @MainActor
    func testSimulatorKeywordFilterMatch() async {
        let turkey = SafeMessageShield.DialingRegion(regionCode: "TR", countryCode: "90", nationalPrefix: "0")
        let result = FilterSimulatorEngine.shared.simulate(
            sender: "0532 000 0000",
            messageBody: "Kargonuz adres yetersizliği nedeniyle teslim edilemedi. Takip: bit.ly/fake",
            allowedNumbers: [],
            blockedNumbers: [],
            filterRules: [(keyword: "kargonuz", category: "Junk"), (keyword: "teslim edilemedi", category: "Junk")],
            numberFilterRules: [],
            region: turkey
        )

        XCTAssertEqual(result.outcome, SafeMessageShield.FilterSimulationOutcome.filteredByKeyword(keyword: "kargonuz", categoryName: "Junk"))
        XCTAssertTrue(result.outcome.isBlockedOrFiltered)
    }

    @MainActor
    func testSimulatorCleanMessageDeliversToInbox() async {
        let turkey = SafeMessageShield.DialingRegion(regionCode: "TR", countryCode: "90", nationalPrefix: "0")
        let result = FilterSimulatorEngine.shared.simulate(
            sender: "+90 532 111 2233",
            messageBody: "Yarın saat 14:00'te toplantımız var, bilginize.",
            allowedNumbers: [],
            blockedNumbers: [],
            filterRules: [(keyword: "bonus", category: "Junk"), (keyword: "kredi", category: "Transaction")],
            numberFilterRules: [(type: "prefix", value: "90850")],
            region: turkey
        )

        XCTAssertEqual(result.outcome, SafeMessageShield.FilterSimulationOutcome.allowedDefault)
        XCTAssertFalse(result.outcome.isBlockedOrFiltered)
    }

    // MARK: - RuleBackupManager Tests

    @MainActor
    func testBackupPayloadExportAndImportValidation() async {
        let now = Date()
        let payload = RuleBackupManager.BackupPayload(
            version: 1,
            exportedAt: now,
            blockedNumbers: [
                RuleBackupManager.BackupPayload.BlockedEntry(phoneNumber: "905551112233", reason: "Spam Call", addedAt: now)
            ],
            allowedNumbers: [
                RuleBackupManager.BackupPayload.AllowedEntry(phoneNumber: "905559998877", reason: "Family", addedAt: now)
            ],
            filterRules: [
                RuleBackupManager.BackupPayload.FilterEntry(keyword: "bedava bonus", category: "Junk", createdAt: now)
            ],
            numberFilterRules: [
                RuleBackupManager.BackupPayload.NumberRuleEntry(ruleType: "prefix", value: "90850", addedAt: now)
            ]
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(payload),
              let jsonString = String(data: data, encoding: .utf8) else {
            XCTFail("Failed to encode payload")
            return
        }

        XCTAssertTrue(jsonString.contains("905551112233"))
        XCTAssertTrue(jsonString.contains("bedava bonus"))
        XCTAssertTrue(jsonString.contains("90850"))

        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(RuleBackupManager.BackupPayload.self, from: data) else {
            XCTFail("Failed to decode payload")
            return
        }

        XCTAssertEqual(decoded, payload)
        XCTAssertEqual(decoded.blockedNumbers.count, 1)
        XCTAssertEqual(decoded.allowedNumbers.count, 1)
        XCTAssertEqual(decoded.filterRules.count, 1)
        XCTAssertEqual(decoded.numberFilterRules.count, 1)
        XCTAssertEqual(decoded.blockedNumbers.first?.phoneNumber, "905551112233")
    }
}
