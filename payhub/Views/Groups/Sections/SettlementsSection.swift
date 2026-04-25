//
//  SettlementsView.swift
//  payhub
//

import Inject
import SwiftUI

struct SettlementsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var viewModel: GroupSplitViewModel
    @Environment(\.dismiss) var dismiss

    private let fmt = CurrencyFormatterService()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    ZStack {
                        Circle()
                            .fill(PayhubColor.surfacePrimary)
                            .overlay(Circle().stroke(PayhubColor.borderSubtle, lineWidth: 1.5))
                            .frame(width: 36, height: 36)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(PayhubColor.textPrimary)
                    }
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Calculate")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundStyle(PayhubColor.textPrimary)
                    Text("Minimum transfers needed")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(PayhubColor.textSecondary)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(PayhubColor.surfacePrimary)
            .overlay(alignment: .bottom) {
                Rectangle().fill(PayhubColor.borderSubtle).frame(height: 1)
            }

            ScrollView(showsIndicators: false) {
                if viewModel.settlements.isEmpty {
                    // "Everyone settled" empty state
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(PayhubColor.balancePositive.opacity(0.12))
                                .frame(width: 56, height: 56)
                            Image(systemName: "checkmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(PayhubColor.balancePositive)
                        }
                        Text("Everyone is settled!")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(PayhubColor.textPrimary)
                        Text("No transfers needed")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(PayhubColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .padding(.horizontal, 24)
                    .background(PayhubColor.surfacePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(PayhubColor.borderSubtle, style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.settlements) { s in
                            SettlementCard(settlement: s, fmt: fmt)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .background(PayhubColor.appBackground)
        }
        .enableInjection()
    }
}

private struct SettlementCard: View {
    let settlement: SettlementTransaction
    let fmt: CurrencyFormatterService

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 36, height: 36)
                Text(String(settlement.from.name.prefix(1)).uppercased())
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                (Text(settlement.from.name)
                    .foregroundStyle(PayhubColor.balanceNegative)
                 + Text(" pays ")
                    .foregroundStyle(PayhubColor.textTertiary)
                 + Text(settlement.to.name)
                    .foregroundStyle(PayhubColor.balancePositive))
                    .font(.system(size: 14, weight: .bold))

                Text("Settlement transfer")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(PayhubColor.textTertiary)
            }

            Spacer()

            Text(fmt.string(from: settlement.amount))
                .font(.system(size: 14, weight: .heavy))
                .foregroundStyle(.white)
                .monospacedDigit()
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                )
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(PayhubColor.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(PayhubColor.borderSubtle, lineWidth: 1.5)
        )
        .shadow(color: PayhubColor.bluePrimary.opacity(0.08), radius: 12, x: 0, y: 8)
    }
}
