//
//  SettlementsSection.swift
//  payhub
//

import Inject
import SwiftUI

struct SettlementsSection: View {
    @ObserveInjection var inject

    let settlements: [SettlementTransaction]
    let hasExpenses: Bool
    let currencyFormatter: CurrencyFormatterService

    var body: some View {
        Section("Settle Up") {
            if settlements.isEmpty {
                EmptyStateRow(message: hasExpenses ? "Everyone is settled." : "Add expenses to see settlements.")
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
                ForEach(settlements) { settlement in
                    SettlementRow(
                        settlement: settlement,
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

private struct SettlementRow: View {
    let settlement: SettlementTransaction
    let currencyFormatter: CurrencyFormatterService

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "arrow.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(PayhubColor.textOnAccent)
                .frame(width: 28, height: 28)
                .background(PayhubColor.brandPrimary, in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text("\(settlement.from.name) pays \(settlement.to.name)")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(PayhubColor.textPrimary)

                Text("Settlement transfer")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(PayhubColor.textTertiary)
            }

            Spacer()

            Text(currencyFormatter.string(from: settlement.amount))
                .font(.headline.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(PayhubColor.textPrimary)
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
