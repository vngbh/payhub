//
//  BillsView.swift
//  payhub
//

import Inject
import SwiftUI

struct BillsView: View {
    @ObserveInjection var inject
    @EnvironmentObject var viewModel: GroupSplitViewModel

    let onAddBill: () -> Void

    private let fmt = CurrencyFormatterService()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 2) {
                Text("Bills")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundStyle(PayhubColor.textPrimary)
                Text("All recorded bills")
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

            // List
            ScrollView(showsIndicators: false) {
                if viewModel.bills.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 36, weight: .light))
                            .foregroundStyle(PayhubColor.textSecondary)
                        Text("No bills yet.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(PayhubColor.textSecondary)
                    }
                    .padding(.top, 60)
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.bills.reversed()) { bill in
                            BillCard(
                                bill: bill,
                                payerName: viewModel.memberName(for: bill.payerID),
                                fmt: fmt,
                                onDelete: { viewModel.removeBill(bill) }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .padding(.bottom, 40)
                }
            }
            .background(PayhubColor.appBackground)

            // CTA
            Button(action: onAddBill) {
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                    Text("Add Bill")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(PayhubColor.dark, in: RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(PayhubColor.surfacePrimary)
            .overlay(alignment: .top) {
                Rectangle().fill(PayhubColor.borderSubtle).frame(height: 1)
            }
        }
        .enableInjection()
    }
}

private struct BillCard: View {
    let bill: Bill
    let payerName: String
    let fmt: CurrencyFormatterService
    let onDelete: () -> Void

    var perPerson: Decimal {
        guard !bill.participantIDs.isEmpty else { return bill.amount }
        return bill.amount / Decimal(bill.participantIDs.count)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(PayhubColor.bluePrimary.opacity(0.1))
                    .frame(width: 46, height: 46)
                    .overlay(
                        Image(systemName: "creditcard")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(PayhubColor.bluePrimary)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(bill.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(PayhubColor.textPrimary)
                    Text("Paid by \(payerName) · \(bill.participantIDs.count) people")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(PayhubColor.textSecondary)
                    Text("\(fmt.string(from: perPerson))/person")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(PayhubColor.bluePrimary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Text(fmt.string(from: bill.amount))
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundStyle(PayhubColor.textPrimary)
                        .monospacedDigit()

                    Button(action: onDelete) {
                        HStack(spacing: 4) {
                            Image(systemName: "trash")
                                .font(.system(size: 11, weight: .bold))
                            Text("Delete")
                                .font(.system(size: 11, weight: .bold))
                        }
                        .foregroundStyle(PayhubColor.balanceNegative)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 1, green: 240 / 255, blue: 243 / 255))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
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
    BillsView(onAddBill: {})
        .environmentObject(GroupSplitViewModel())
}
