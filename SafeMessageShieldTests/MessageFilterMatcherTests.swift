import XCTest

final class MessageFilterMatcherTests: XCTestCase {
    private let turkey = DialingRegion(regionCode: "TR", countryCode: "90", nationalPrefix: "0")
    private let saudiArabia = DialingRegion(regionCode: "SA", countryCode: "966", nationalPrefix: "0")
    private let russia = DialingRegion(regionCode: "RU", countryCode: "7", nationalPrefix: "8")
    private let italy = DialingRegion(regionCode: "IT", countryCode: "39", nationalPrefix: nil)

    // MARK: - PhoneNumberNormalizer

    func testInternationalFormatsNormalizeWithoutRegion() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("+90 (555) 123 45 67"), "905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("0090 555 123 45 67"), "905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("+966 50 123 4567"), "966501234567")
    }

    func testNoCountryCodeIsAssumedWithoutRegion() {
        // Ülke bilinmiyorsa Türkiye (veya başka bir ülke) varsayılmaz
        XCTAssertEqual(PhoneNumberNormalizer.normalize("0555 123 45 67"), "05551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("5551234567"), "5551234567")
    }

    func testLocalNumbersUseSelectedRegion() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("0555 123 45 67", region: turkey), "905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("5551234567", region: turkey), "905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("905551234567", region: turkey), "905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("050 123 4567", region: saudiArabia), "966501234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("8 916 123-45-67", region: russia), "79161234567")
        // İtalya'da baştaki 0 numaranın parçasıdır, atılmamalı
        XCTAssertEqual(PhoneNumberNormalizer.normalize("06 1234 5678", region: italy), "390612345678")
    }

    func testInternationalInputIgnoresRegion() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("+966 50 123 4567", region: turkey), "966501234567")
    }

    func testShortCodesNeverGetCountryCode() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("4567", region: turkey), "4567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("123456", region: saudiArabia), "123456")
    }

    func testDialingRegionRoundTripsThroughUserDefaults() throws {
        let suiteName = "MessageFilterMatcherTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        XCTAssertNil(DialingRegion.load(from: defaults))
        russia.save(to: defaults)
        XCTAssertEqual(DialingRegion.load(from: defaults), russia)
        italy.save(to: defaults)
        XCTAssertEqual(DialingRegion.load(from: defaults), italy)
    }

    // MARK: - MessageFilterMatcher

    func testAlphabeticSenderNeverMatchesNumericBlockEntry() {
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "+905551234567", sender: "VODAFONE"))
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "4444", sender: "BANKA"))
    }

    func testEquivalentPhoneFormatsMatch() {
        XCTAssertTrue(MessageFilterMatcher.numbersMatch(stored: "905551234567", sender: "05551234567", region: turkey))
        XCTAssertTrue(MessageFilterMatcher.numbersMatch(stored: "905551234567", sender: "+90 555 123 45 67"))
        XCTAssertTrue(MessageFilterMatcher.numbersMatch(stored: "966501234567", sender: "0501234567", region: saudiArabia))
    }

    func testLocalSenderMatchesOnlyForItsOwnRegion() {
        // Suudi numarası, Türkiye bölgesinde yerel biçimde gelen gönderenle eşleşmemeli
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "966501234567", sender: "0501234567", region: turkey))
    }

    func testShortPartialNumbersDoNotMatch() {
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "4567", sender: "+90 555 123 45 67"))
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "123", sender: "3123"))
    }

    func testSenderNamesRequireExactCaseInsensitiveMatch() {
        XCTAssertTrue(MessageFilterMatcher.senderNamesMatch(stored: " vodafone ", sender: "VODAFONE"))
        XCTAssertFalse(MessageFilterMatcher.senderNamesMatch(stored: "BANK", sender: "BANKA"))
    }

    func testNumberRulesMatchNationalAndInternationalForms() {
        XCTAssertTrue(MessageFilterMatcher.numberRuleMatches(type: "prefix", value: "555", sender: "+90 555 123 45 67", region: turkey))
        XCTAssertTrue(MessageFilterMatcher.numberRuleMatches(type: "prefix", value: "0555", sender: "+90 555 123 45 67", region: turkey))
        XCTAssertTrue(MessageFilterMatcher.numberRuleMatches(type: "suffix", value: "4567", sender: "05551234567", region: turkey))
        XCTAssertTrue(MessageFilterMatcher.numberRuleMatches(type: "contains", value: "123", sender: "05551234567", region: turkey))
        XCTAssertTrue(MessageFilterMatcher.numberRuleMatches(type: "prefix", value: "050", sender: "+966501234567", region: saudiArabia))
        XCTAssertFalse(MessageFilterMatcher.numberRuleMatches(type: "prefix", value: "123", sender: "+90 555 123 45 67", region: turkey))
    }

    func testRulesShorterThanThreeDigitsAreRejected() {
        XCTAssertFalse(MessageFilterMatcher.numberRuleMatches(type: "contains", value: "1", sender: "05551234567"))
    }

    func testCallDirectoryValidationRejectsInvalidLengthsAndLeadingZero() {
        XCTAssertTrue(PhoneNumberNormalizer.isValidCallDirectoryNumber("905551234567"))
        XCTAssertFalse(PhoneNumberNormalizer.isValidCallDirectoryNumber("12"))
        XCTAssertFalse(PhoneNumberNormalizer.isValidCallDirectoryNumber("0123"))
        XCTAssertFalse(PhoneNumberNormalizer.isValidCallDirectoryNumber("1234567890123456"))
    }
}

/// PhoneNumberKit tabanlı girdi çözümleme (uygulamanın numara ekleme formları)
final class PhoneNumberServiceTests: XCTestCase {
    private let service = PhoneNumberService.shared

    func testLocalNumbersResolveToE164ForSelectedCountry() {
        XCTAssertEqual(service.entry(for: "0555 123 45 67", regionCode: "TR"), .success(.number("+905551234567")))
        XCTAssertEqual(service.entry(for: "050 123 4567", regionCode: "SA"), .success(.number("+966501234567")))
        XCTAssertEqual(service.entry(for: "312 345 6789", regionCode: "IT"), .success(.number("+393123456789")))
        XCTAssertEqual(service.entry(for: "(201) 555-0123", regionCode: "US"), .success(.number("+12015550123")))
    }

    func testInternationalInputIgnoresSelectedCountry() {
        XCTAssertEqual(service.entry(for: "+966 50 123 4567", regionCode: "TR"), .success(.number("+966501234567")))
    }

    func testInvalidNumberForCountryIsRejected() {
        XCTAssertEqual(service.entry(for: "123456789", regionCode: "TR"), .failure(.invalidNumber))
    }

    func testShortCodesAndSenderNamesAreKeptAsIs() {
        XCTAssertEqual(service.entry(for: "4567", regionCode: "TR"), .success(.shortCode("4567")))
        XCTAssertEqual(service.entry(for: " vodafone ", regionCode: "TR"), .success(.senderName("VODAFONE")))
        XCTAssertEqual(service.entry(for: "   ", regionCode: "TR"), .failure(.empty))
    }

    func testStoredAndDisplayedValuesMatch() {
        let entry = PhoneNumberEntry.number("+905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize(entry.storageValue), "905551234567")
        XCTAssertEqual(entry.displayValue, "905551234567")
    }

    func testDialingRegionComesFromMetadata() {
        XCTAssertEqual(service.dialingRegion(for: "TR"), DialingRegion(regionCode: "TR", countryCode: "90", nationalPrefix: "0"))
        XCTAssertEqual(service.dialingRegion(for: "RU")?.nationalPrefix, "8")
        XCTAssertEqual(service.dialingRegion(for: "IT")?.nationalPrefix, nil)
        XCTAssertEqual(service.dialingRegion(for: "SA")?.countryCode, "966")
        XCTAssertNil(service.dialingRegion(for: "XX"))
    }
}
