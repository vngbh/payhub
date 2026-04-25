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
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text("Group Wallet")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.65))
                        .tracking(0.5)
                        .textCase(.uppercase)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(.white.opacity(0.14), in: Capsule())

                    Spacer()

                    Text("Live Split")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.65))
                }

                HStack(alignment: .top, spacing: 14) {
                    Image("PayhubLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: .black.opacity(0.22), radius: 8, x: 0, y: 4)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Shared Spending")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.65))

                        Text("payhub")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(.white)
                    }
                }

                Text(currencyFormatter.string(from: totalSpent))
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                    .monospacedDigit()
                    .accessibilityIdentifier("overview.totalSpent")

                HStack(spacing: 10) {
                    SummaryPill(title: "Members", value: "Add")
                    SummaryPill(title: "Expenses", value: "Track")
                    SummaryPill(title: "Settle", value: "Pay")
                }

                Text("Add members, record shared expenses, then settle up with the fewest transfers.")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.65))
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 4)
            .listRowBackground(
                LinearGradient(
                    colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .listRowSeparator(.hidden)
        }
        .enableInjection()
    }
}

private struct SummaryPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.white.opacity(0.65))

            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
    }
}
