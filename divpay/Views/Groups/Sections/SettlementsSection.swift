//
//  SettlementsSection.swift
//  divpay
//

import SwiftUI

struct SettlementsSection: View {
    let settlements: [SettlementTransaction]
    let hasExpenses: Bool
    let currencyFormatter: CurrencyFormatterService

    var body: some View {
        Section("Settle Up") {
            if settlements.isEmpty {
                EmptyStateRow(message: hasExpenses ? "Everyone is settled." : "Add expenses to see settlements.")
            } else {
                ForEach(settlements) { settlement in
                    Text("\(settlement.from.name) pays \(settlement.to.name) \(currencyFormatter.string(from: settlement.amount))")
                }
            }
        }
    }
}

