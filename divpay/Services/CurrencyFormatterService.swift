//
//  CurrencyFormatterService.swift
//  divpay
//

import Foundation

struct CurrencyFormatterService {
    private let formatter: NumberFormatter

    init(locale: Locale = .current) {
        formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
    }

    func string(from amount: Decimal) -> String {
        formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "\(amount)"
    }
}

