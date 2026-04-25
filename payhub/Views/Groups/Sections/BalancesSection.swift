//
//  BalancesView.swift
//  payhub
//

import Inject
import SwiftUI

struct BalancesView: View {
    @ObserveInjection var inject
    @EnvironmentObject var viewModel: GroupSplitViewModel

    private let fmt = CurrencyFormatterService()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 2) {
                Text("Balances")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(PayhubColor.textPrimary)
                Text("Who paid what")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(PayhubColor.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(PayhubColor.surfacePrimary)
            .overlay(alignment: .bottom) {
                Rectangle().fill(PayhubColor.borderSubtle).frame(height: 1)
            }

            ScrollView(showsIndicators: false) {
                if viewModel.balances.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "chart.pie")
                            .font(.system(size: 36, weight: .light))
                            .foregroundStyle(PayhubColor.textSecondary)
                        Text("Add members to see balances.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(PayhubColor.textSecondary)
                    }
                    .padding(.top, 60)
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.balances) { balance in
                            BalanceCard(balance: balance, fmt: fmt)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .padding(.bottom, 80)
                }
            }
            .background(PayhubColor.appBackground)
        }
        .enableInjection()
    }
}

private struct BalanceCard: View {
    let balance: MemberBalance
    let fmt: CurrencyFormatterService

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 46, height: 46)
                Text(String(balance.member.name.prefix(1)).uppercased())
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(balance.member.name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(PayhubColor.textPrimary)
                Text("Paid \(fmt.string(from: balance.paid)) · Owes \(fmt.string(from: balance.owed))")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(PayhubColor.textSecondary)
            }

            Spacer()

            Text((balance.net >= 0 ? "+" : "") + fmt.string(from: balance.net))
                .font(.system(size: 16, weight: .heavy))
                .foregroundStyle(balance.net >= 0 ? PayhubColor.balancePositive : PayhubColor.balanceNegative)
                .monospacedDigit()
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

#Preview {
    BalancesView()
        .environmentObject(GroupSplitViewModel())
}
