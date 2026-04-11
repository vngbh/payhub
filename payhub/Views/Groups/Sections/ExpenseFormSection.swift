//
//  ExpenseFormSection.swift
//  payhub
//

import SwiftUI

struct ExpenseFormSection: View {
    @ObservedObject var viewModel: GroupSplitViewModel

    var body: some View {
        Section("Add Expense") {
            TextField("Expense title", text: $viewModel.expenseTitle)
                .accessibilityIdentifier("expense.titleField")

            TextField("Amount", text: $viewModel.expenseAmount)
                .keyboardType(.decimalPad)
                .accessibilityIdentifier("expense.amountField")

            if !viewModel.members.isEmpty {
                payerPicker
                participantsPicker
            }

            Button("Add Expense") {
                viewModel.addExpense()
            }
            .disabled(!viewModel.canAddExpense)
            .accessibilityIdentifier("expense.addButton")
        }
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
                .buttonStyle(.plain)
                .accessibilityIdentifier("expense.participant.\(member.name)")
            }
        }
    }
}

