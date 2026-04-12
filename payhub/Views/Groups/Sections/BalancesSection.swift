//
//  BalancesSection.swift
//  payhub
//

import Inject
import SwiftUI

struct BalancesSection: View {
    @ObserveInjection var inject

    let balances: [MemberBalance]
    let currencyFormatter: CurrencyFormatterService

    var body: some View {
        Section("Balances") {
            ForEach(balances) { balance in
                BalanceRow(
                    balance: balance,
                    currencyFormatter: currencyFormatter
                )
            }
        }
        .enableInjection()
    }
}

private struct BalanceRow: View {
    let balance: MemberBalance
    let currencyFormatter: CurrencyFormatterService

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(balance.member.name)
                    .font(.headline)

                Text("Paid \(currencyFormatter.string(from: balance.paid)) • Owes \(currencyFormatter.string(from: balance.owed))")
                    .font(.caption)
                    .foregroundStyle(PayhubColor.textSecondary)
            }

            Spacer()

            Text(currencyFormatter.string(from: balance.net))
                .foregroundStyle(balance.net >= 0 ? PayhubColor.balancePositive : PayhubColor.balanceNegative)
                .font(.headline)
        }
    }
}
