import Foundation

enum PhoneNumberNormalizer {
    static func normalize(_ input: String) -> String {
        var digits = input.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        while digits.hasPrefix("00") {
            digits.removeFirst(2)
        }

        if digits.count == 11, digits.hasPrefix("0") {
            digits = "90" + digits.dropFirst()
        } else if digits.count == 10, digits.hasPrefix("5") {
            digits = "90" + digits
        }

        return digits
    }

    static func isValidCallDirectoryNumber(_ value: String) -> Bool {
        (3...15).contains(value.count) && value.first != "0"
    }
}
