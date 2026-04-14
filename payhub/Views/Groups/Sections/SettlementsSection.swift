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
            } else {
                ForEach(settlements) { settlement in
                    SettlementRow(
                        settlement: settlement,
                        currencyFormatter: currencyFormatter
                    )
                }
            }
        }
        .listRowBackground(PayhubColor.surfacePrimary)
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
        .padding(.vertical, 4)
    }
}
