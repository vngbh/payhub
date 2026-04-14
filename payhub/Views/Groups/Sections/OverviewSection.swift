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
                        .font(.caption.weight(.bold))
                        .foregroundStyle(PayhubColor.textOnAccent)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(PayhubColor.brandPrimary, in: Capsule())

                    Spacer()

                    Text("Live Split")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(PayhubColor.textTertiary)
                }

                HStack(alignment: .top, spacing: 14) {
                    Image("PayhubLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: PayhubColor.brandPrimary.opacity(0.18), radius: 10, x: 0, y: 6)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Shared Spending")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PayhubColor.brandPrimary)

                        Text("payhub")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(PayhubColor.textPrimary)
                    }
                }

                Text(currencyFormatter.string(from: totalSpent))
                    .font(.system(size: 48, weight: .bold, design: .default))
                    .foregroundStyle(PayhubColor.textPrimary)
                    .accessibilityIdentifier("overview.totalSpent")

                HStack(spacing: 10) {
                    SummaryPill(title: "Members", value: "Add")
                    SummaryPill(title: "Expenses", value: "Track")
                    SummaryPill(title: "Settle", value: "Pay")
                }

                Text("Add members, record shared expenses, then settle up with the fewest transfers.")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(PayhubColor.textSecondary)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 4)
            .listRowBackground(
                LinearGradient(
                    colors: [
                        PayhubColor.surfacePrimary,
                        PayhubColor.brandSoft.opacity(0.74),
                        PayhubColor.brandBright.opacity(0.24)
                    ],
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
                .font(.caption2.weight(.semibold))
                .foregroundStyle(PayhubColor.textSecondary)

            Text(value)
                .font(.caption.weight(.bold))
                .foregroundStyle(PayhubColor.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(PayhubColor.iconSurface.opacity(0.76), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(PayhubColor.borderSubtle.opacity(0.76), lineWidth: 1)
        )
    }
}
