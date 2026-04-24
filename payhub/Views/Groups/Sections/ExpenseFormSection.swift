//
//  ExpenseFormSection.swift
//  payhub
//

import Inject
import SwiftUI

struct ExpenseFormSection: View {
    @ObserveInjection var inject

    @ObservedObject var viewModel: GroupSplitViewModel
    let submitTitle: String
    let onSubmit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            TextField("Expense title", text: $viewModel.expenseTitle)
                .font(.body.weight(.medium))
                .accessibilityIdentifier("expense.titleField")

            TextField("Amount", text: $viewModel.expenseAmount)
                .font(.body.weight(.medium))
                .keyboardType(.decimalPad)
                .accessibilityIdentifier("expense.amountField")

            if !viewModel.members.isEmpty {
                payerPicker
                participantsPicker
            }

            HStack {
                Spacer()

                Button {
                    onSubmit()
                } label: {
                    Text(submitTitle)
                        .foregroundStyle(PayhubColor.textOnAccent)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canSubmitExpense)
                .accessibilityIdentifier("expense.addButton")

                Spacer()
            }
            .padding(.top, 6)
        }
        .tint(PayhubColor.brandPrimary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(PayhubColor.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(PayhubColor.borderSubtle.opacity(0.9), lineWidth: 1)
        )
        .shadow(color: PayhubColor.textPrimary.opacity(0.04), radius: 12, x: 0, y: 6)
        .foregroundStyle(PayhubColor.textPrimary)
        .enableInjection()
    }

    private var payerPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Paid by")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(PayhubColor.textPrimary)

            ForEach(viewModel.members) { member in
                Button {
                    viewModel.selectedPayerID = member.id
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: viewModel.selectedPayerID == member.id ? "largecircle.fill.circle" : "circle")
                            .foregroundStyle(
                                viewModel.selectedPayerID == member.id
                                    ? PayhubColor.brandPrimary
                                    : PayhubColor.textTertiary
                            )

                        Text(member.name)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(PayhubColor.textPrimary)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("expense.payer.\(member.name)")
            }
        }
        .accessibilityIdentifier("expense.payerPicker")
    }

    private var participantsPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Participants")
                .font(.subheadline.weight(.semibold))

            ForEach(viewModel.members) { member in
                Button {
                    viewModel.toggleParticipant(member)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: viewModel.selectedParticipantIDs.contains(member.id) ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(
                                viewModel.selectedParticipantIDs.contains(member.id)
                                    ? PayhubColor.brandPrimary
                                    : PayhubColor.textTertiary
                            )

                        Text(member.name)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(PayhubColor.textPrimary)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("expense.participant.\(member.name)")
            }
        }
        .padding(.top, 4)
    }
}
