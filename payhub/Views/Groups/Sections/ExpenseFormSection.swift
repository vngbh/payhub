//
//  AddExpenseView.swift
//  payhub
//

import Inject
import SwiftUI

struct AddExpenseView: View {
    @ObserveInjection var inject
    @EnvironmentObject var viewModel: GroupSplitViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 16) {
                Button { dismiss() } label: {
                    ZStack {
                        Circle()
                            .fill(PayhubColor.surfacePrimary)
                            .overlay(Circle().stroke(PayhubColor.borderSubtle, lineWidth: 1.5))
                            .frame(width: 36, height: 36)
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(PayhubColor.textPrimary)
                    }
                }
                .buttonStyle(.plain)

                Text("Add Expense")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(PayhubColor.textPrimary)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(PayhubColor.surfacePrimary)
            .overlay(alignment: .bottom) {
                Rectangle().fill(PayhubColor.borderSubtle).frame(height: 1)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    amountCard
                    titleCard
                    if !viewModel.members.isEmpty {
                        payerCard
                        participantsCard
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .background(PayhubColor.appBackground)

            // CTA
            Button {
                guard viewModel.canSubmitExpense else { return }
                viewModel.submitExpense()
                dismiss()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                    Text("Create Expense")
                        .font(.system(size: 16, weight: .heavy))
                }
                .foregroundStyle(viewModel.canSubmitExpense ? Color.white : PayhubColor.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(viewModel.canSubmitExpense ? PayhubColor.dark : PayhubColor.borderSubtle)
                )
            }
            .buttonStyle(.plain)
            .disabled(!viewModel.canSubmitExpense)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(PayhubColor.surfacePrimary)
            .overlay(alignment: .top) {
                Rectangle().fill(PayhubColor.borderSubtle).frame(height: 1)
            }
            .accessibilityIdentifier("expense.addButton")
        }
        .enableInjection()
    }

    // MARK: Amount card (blue gradient)

    private var amountCard: some View {
        VStack(spacing: 8) {
            Text("Amount (VND)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.65))
                .tracking(0.5)
                .textCase(.uppercase)

            TextField("0", text: $viewModel.expenseAmount)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .font(.system(size: 40, weight: .heavy))
                .foregroundStyle(.white)
                .tint(.white)
                .accessibilityIdentifier("expense.amountField")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 22)
        .background(
            LinearGradient(
                colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: Title card

    private var titleCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Expense Title")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(PayhubColor.textSecondary)
                .tracking(0.4)
                .textCase(.uppercase)

            TextField("e.g. Dinner at Nobu", text: $viewModel.expenseTitle)
                .textInputAutocapitalization(.words)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(PayhubColor.textPrimary)
                .tint(PayhubColor.bluePrimary)
                .accessibilityIdentifier("expense.titleField")
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(PayhubColor.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(PayhubColor.borderSubtle, lineWidth: 1.5)
        )
    }

    // MARK: Payer card

    private var payerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Paid by")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(PayhubColor.textSecondary)
                .tracking(0.4)
                .textCase(.uppercase)

            FlexRow(spacing: 8) {
                ForEach(viewModel.members) { member in
                    let selected = viewModel.selectedPayerID == member.id
                    Button { viewModel.selectedPayerID = member.id } label: {
                        Text(member.name)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(selected ? Color.white : PayhubColor.textPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(selected ? PayhubColor.dark : PayhubColor.surfacePrimary)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(selected ? Color.clear : PayhubColor.borderSubtle, lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("expense.payer.\(member.name)")
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(PayhubColor.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(PayhubColor.borderSubtle, lineWidth: 1.5)
        )
    }

    // MARK: Participants card

    private var participantsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Split between")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(PayhubColor.textSecondary)
                .tracking(0.4)
                .textCase(.uppercase)

            VStack(spacing: 10) {
                ForEach(viewModel.members) { member in
                    let checked = viewModel.selectedParticipantIDs.contains(member.id)
                    Button { viewModel.toggleParticipant(member) } label: {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(checked ? PayhubColor.bluePrimary : PayhubColor.surfacePrimary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(checked ? PayhubColor.bluePrimary : PayhubColor.borderSubtle, lineWidth: 2)
                                )
                                .frame(width: 22, height: 22)
                                .overlay(
                                    Group {
                                        if checked {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 11, weight: .bold))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                )

                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 30, height: 30)
                                Text(String(member.name.prefix(1)).uppercased())
                                    .font(.system(size: 12, weight: .heavy))
                                    .foregroundStyle(.white)
                            }

                            Text(member.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(PayhubColor.textPrimary)

                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("expense.participant.\(member.name)")
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(PayhubColor.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(PayhubColor.borderSubtle, lineWidth: 1.5)
        )
    }
}

// MARK: - FlexRow (wrapping HStack)

private struct FlexRow<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: Content

    var body: some View {
        // Simple horizontal scroll for now; wrapping layout not needed for small member counts
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: spacing) {
                content
            }
        }
    }
}
