//
//  ExpenseFormSection.swift
//  payhub
//

import Inject
import SwiftUI

struct ExpenseFormSection: View {
    @ObserveInjection var inject

    @ObservedObject var viewModel: GroupSplitViewModel

    var body: some View {
        Section("Add Expense") {
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
                    viewModel.addExpense()
                } label: {
                    Text("Add Expense")
                        .foregroundStyle(PayhubColor.textOnAccent)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canAddExpense)
                .accessibilityIdentifier("expense.addButton")

                Spacer()
            }
            .padding(.top, 6)
        }
        .tint(PayhubColor.brandPrimary)
        .listRowBackground(PayhubColor.surfacePrimary)
        .listRowSeparator(.hidden)
        .foregroundStyle(PayhubColor.textPrimary)
        .enableInjection()
    }

    private var payerPicker: some View {
        Picker("Paid by", selection: Binding(
            get: { viewModel.selectedPayerID ?? viewModel.members.first?.id },
            set: { viewModel.selectedPayerID = $0 }
        )) {
            ForEach(viewModel.members) { member in
                Text(member.name).tag(Optional(member.id))
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
                    Label(
                        member.name,
                        systemImage: viewModel.selectedParticipantIDs.contains(member.id) ? "checkmark.circle.fill" : "circle"
                    )
                }
                .foregroundStyle(
                    viewModel.selectedParticipantIDs.contains(member.id) ? PayhubColor.brandPrimary : PayhubColor.textPrimary
                )
                .buttonStyle(.plain)
                .accessibilityIdentifier("expense.participant.\(member.name)")
            }
        }
    }
}
