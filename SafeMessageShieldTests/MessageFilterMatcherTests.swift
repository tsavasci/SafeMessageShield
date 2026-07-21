import XCTest

final class MessageFilterMatcherTests: XCTestCase {
    func testTurkishPhoneFormatsNormalizeToSameValue() {
        XCTAssertEqual(PhoneNumberNormalizer.normalize("+90 (555) 123 45 67"), "905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("0555 123 45 67"), "905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("5551234567"), "905551234567")
        XCTAssertEqual(PhoneNumberNormalizer.normalize("0090 555 123 45 67"), "905551234567")
    }

    func testAlphabeticSenderNeverMatchesNumericBlockEntry() {
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "+905551234567", sender: "VODAFONE"))
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "4444", sender: "BANKA"))
    }

    func testEquivalentPhoneFormatsMatch() {
        XCTAssertTrue(MessageFilterMatcher.numbersMatch(stored: "+905551234567", sender: "05551234567"))
        XCTAssertTrue(MessageFilterMatcher.numbersMatch(stored: "5551234567", sender: "+90 555 123 45 67"))
    }

    func testShortPartialNumbersDoNotMatch() {
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "4567", sender: "+90 555 123 45 67"))
        XCTAssertFalse(MessageFilterMatcher.numbersMatch(stored: "123", sender: "3123"))
    }

    func testSenderNamesRequireExactCaseInsensitiveMatch() {
        XCTAssertTrue(MessageFilterMatcher.senderNamesMatch(stored: " vodafone ", sender: "VODAFONE"))
        XCTAssertFalse(MessageFilterMatcher.senderNamesMatch(stored: "BANK", sender: "BANKA"))
    }

    func testNumberRulesHandleTurkishPrefixesWithoutArbitraryTrimming() {
        XCTAssertTrue(MessageFilterMatcher.numberRuleMatches(type: "prefix", value: "555", sender: "+90 555 123 45 67"))
        XCTAssertTrue(MessageFilterMatcher.numberRuleMatches(type: "suffix", value: "4567", sender: "05551234567"))
        XCTAssertTrue(MessageFilterMatcher.numberRuleMatches(type: "contains", value: "123", sender: "05551234567"))
        XCTAssertFalse(MessageFilterMatcher.numberRuleMatches(type: "prefix", value: "123", sender: "+90 555 123 45 67"))
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
