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
            if balances.isEmpty {
                EmptyStateRow(message: "Add members to see balances.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(PayhubColor.surfacePrimary)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(PayhubColor.borderSubtle.opacity(0.9), lineWidth: 1)
                    )
                    .shadow(color: PayhubColor.textPrimary.opacity(0.04), radius: 12, x: 0, y: 6)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(balances) { balance in
                    BalanceRow(
                        balance: balance,
                        currencyFormatter: currencyFormatter
                    )
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
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
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(PayhubColor.textPrimary)

                Text("Paid \(currencyFormatter.string(from: balance.paid)) • Owes \(currencyFormatter.string(from: balance.owed))")
                    .font(.caption)
                    .foregroundStyle(PayhubColor.textTertiary)
            }

            Spacer()

            Text(currencyFormatter.string(from: balance.net))
                .foregroundStyle(balance.net >= 0 ? PayhubColor.balancePositive : PayhubColor.balanceNegative)
                .font(.headline.weight(.bold))
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(PayhubColor.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(PayhubColor.borderSubtle.opacity(0.9), lineWidth: 1)
        )
        .shadow(color: PayhubColor.textPrimary.opacity(0.04), radius: 12, x: 0, y: 6)
    }
}
