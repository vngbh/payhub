//
//  OverviewSection.swift
//  payhub
//

import SwiftUI

struct OverviewSection: View {
    let totalSpent: Decimal
    let currencyFormatter: CurrencyFormatterService

    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Spent")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(currencyFormatter.string(from: totalSpent))
                    .font(.largeTitle.weight(.bold))
                    .accessibilityIdentifier("overview.totalSpent")

                Text("Add members, record shared expenses, then settle up with the fewest transfers.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
    }
}

