//
//  GroupSplitView.swift  (HomeView)
//  payhub
//

import Inject
import SwiftUI

struct GroupSplitView: View {
    @ObserveInjection var inject
    @EnvironmentObject var viewModel: GroupSplitViewModel

    let onAddBill:     () -> Void
    let onCalculate:   () -> Void
    let onViewMembers: () -> Void

    private let fmt = CurrencyFormatterService()

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    quickActions
                    membersRow
                    recentBills
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 110)
            }
            .background(PayhubColor.appBackground)
        }
        .ignoresSafeArea(edges: .top)
        .enableInjection()
    }

    // MARK: Header

    private var header: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Hey, group 👋")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(PayhubColor.textPrimary)
                    Text("Manage shared bills")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(PayhubColor.textSecondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 40, height: 40)
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)

            heroCard
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .padding(.top, 62)
        .background(PayhubColor.surfacePrimary)
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Total Group Spend")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
                .tracking(0.5)
                .textCase(.uppercase)
                .padding(.bottom, 6)

            Text(fmt.string(from: viewModel.totalSpent))
                .font(.system(size: 32, weight: .heavy))
                .foregroundStyle(.white)
                .monospacedDigit()
                .padding(.bottom, 16)

            HStack(spacing: 10) {
                HeroPill(value: "\(viewModel.members.count)",      label: "Members")
                HeroPill(value: "\(viewModel.bills.count)",        label: "Bills")
                HeroPill(value: "\(viewModel.settlements.count)",  label: "Pending")
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 22)
        .background(
            LinearGradient(
                colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: PayhubColor.bluePrimary.opacity(0.28), radius: 16, x: 0, y: 12)
    }

    // MARK: Quick Actions

    private var quickActions: some View {
        HStack(spacing: 10) {
            Button(action: onAddBill) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                    Text("Add Bill")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(PayhubColor.dark, in: RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)

            Button(action: onCalculate) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 14, weight: .bold))
                    Text("Calculate")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundStyle(PayhubColor.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(PayhubColor.surfacePrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(PayhubColor.borderSubtle, lineWidth: 1.5)
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: Members Row

    private var membersRow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Members")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(PayhubColor.textPrimary)
                Spacer()
                Button(action: onViewMembers) {
                    Text("View all")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(PayhubColor.bluePrimary)
                }
                .buttonStyle(.plain)
            }

            if viewModel.members.isEmpty {
                Text("No members yet. Tap View all to add.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(PayhubColor.textSecondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.members) { member in
                            MemberChip(name: member.name)
                        }
                    }
                }
            }
        }
    }

    // MARK: Recent Bills

    private var recentBills: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Bills")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(PayhubColor.textPrimary)

            if viewModel.bills.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 28, weight: .light))
                            .foregroundStyle(PayhubColor.textSecondary)
                        Text("No bills yet")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(PayhubColor.textSecondary)
                    }
                    Spacer()
                }
                .padding(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(PayhubColor.borderSubtle, style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                )
            } else {
                ForEach(viewModel.bills.suffix(3).reversed()) { bill in
                    RecentBillCard(
                        bill: bill,
                        payerName: viewModel.memberName(for: bill.payerID),
                        fmt: fmt
                    )
                }
            }
        }
    }
}

// MARK: - Sub-views

private struct HeroPill: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.system(size: 18, weight: .heavy))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.white.opacity(0.65))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 14))
    }
}

private struct MemberChip: View {
    let name: String

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 26, height: 26)
                Text(String(name.prefix(1)).uppercased())
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(.white)
            }
            Text(name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(PayhubColor.textPrimary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 14)
        .background(PayhubColor.surfacePrimary)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(PayhubColor.borderSubtle, lineWidth: 1.5))
        .shadow(color: PayhubColor.bluePrimary.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

private struct RecentBillCard: View {
    let bill: Bill
    let payerName: String
    let fmt: CurrencyFormatterService

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14)
                .fill(PayhubColor.bluePrimary.opacity(0.1))
                .frame(width: 42, height: 42)
                .overlay(
                    Image(systemName: "wallet.bifold")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(PayhubColor.bluePrimary)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(bill.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(PayhubColor.textPrimary)
                Text("Paid by \(payerName)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(PayhubColor.textSecondary)
            }

            Spacer()

            Text(fmt.string(from: bill.amount))
                .font(.system(size: 15, weight: .heavy))
                .foregroundStyle(PayhubColor.textPrimary)
                .monospacedDigit()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(PayhubColor.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(PayhubColor.borderSubtle, lineWidth: 1.5)
        )
        .shadow(color: PayhubColor.bluePrimary.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    GroupSplitView(onAddBill: {}, onCalculate: {}, onViewMembers: {})
        .environmentObject(GroupSplitViewModel())
}
