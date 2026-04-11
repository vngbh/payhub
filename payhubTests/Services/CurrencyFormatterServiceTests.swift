//
//  CurrencyFormatterServiceTests.swift
//  payhubTests
//

import XCTest
@testable import payhub

final class CurrencyFormatterServiceTests: XCTestCase {
    func testCurrencyStringUsesOneFractionalDigitWithoutGroupingSeparators() {
        let formatter = CurrencyFormatterService(locale: Locale(identifier: "en_US"))

        let value = formatter.string(from: 1234.56)

        XCTAssertEqual(value, "$1234.6")
        XCTAssertFalse(value.contains(","))
    }
}
