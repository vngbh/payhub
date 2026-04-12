//
//  OverviewSection.swift
//  payhub
//

import Inject
import SwiftUI

struct OverviewSection: View {
    @ObserveInjection var inject

    let totalSpent: Decimal
    let currencyFormatter: CurrencyFormatterService

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Spent")
                    .font(.subheadline)
                    .foregroundStyle(PayhubColor.textSecondary)

                Text(currencyFormatter.string(from: totalSpent))
                    .font(.largeTitle.weight(.bold))
                    .accessibilityIdentifier("overview.totalSpent")

                Text("Add members, record shared expenses, then settle up with the fewest transfers.")
                    .font(.subheadline)
                    .foregroundStyle(PayhubColor.textSecondary)
            }
            .padding(.vertical, 8)
        }
        .enableInjection()
    }
}
