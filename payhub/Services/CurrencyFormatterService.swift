//
//  CurrencyFormatterService.swift
//  payhub
//

import Foundation

struct CurrencyFormatterService {
    private let formatter: NumberFormatter

    init(locale: Locale = .current) {
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.usesGroupingSeparator = false
    }

    func string(from amount: Decimal) -> String {
        formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "\(amount)"
    }
}
