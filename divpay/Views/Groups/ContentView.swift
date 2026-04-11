//
//  ContentView.swift
//  divpay
//
//  Created by GIA BAO HOANG on 2026/04/11.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GroupSplitViewModel()
    private let currencyFormatter = CurrencyFormatterService()

    var body: some View {
        NavigationStack {
            List {
                overviewSection
                membersSection
                expenseFormSection
                expensesSection
                balancesSection
                settlementsSection
            }
            .navigationTitle("Divpay")
        }
    }

    private var overviewSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Spent")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(currencyFormatter.string(from: viewModel.totalSpent))
                    .font(.largeTitle.weight(.bold))
                    .accessibilityIdentifier("overview.totalSpent")
                Text("Add members, record shared expenses, then settle up with the fewest transfers.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 8)
        }
    }

    private var membersSection: some View {
        Section("Members") {
            HStack {
                TextField("Member name", text: $viewModel.memberName)
                    .textInputAutocapitalization(.words)
                    .accessibilityIdentifier("members.nameField")

                Button("Add") {
                    viewModel.addMember()
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("members.addButton")
            }

            ForEach(viewModel.members) { member in
                HStack {
                    Text(member.name)
                    Spacer()
                    Button(role: .destructive) {
                        viewModel.removeMember(member)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .accessibilityLabel("Remove \(member.name)")
                }
            }
        }
    }

    private var expenseFormSection: some View {
        Section("Add Expense") {
            TextField("Expense title", text: $viewModel.expenseTitle)
                .accessibilityIdentifier("expense.titleField")

            TextField("Amount", text: $viewModel.expenseAmount)
                .keyboardType(.decimalPad)
                .accessibilityIdentifier("expense.amountField")

            if !viewModel.members.isEmpty {
                Picker("Paid by", selection: Binding(
                    get: { viewModel.selectedPayerID ?? viewModel.members.first?.id },
                    set: { viewModel.selectedPayerID = $0 }
                )) {
                    ForEach(viewModel.members) { member in
                        Text(member.name).tag(Optional(member.id))
                    }
                }
                .accessibilityIdentifier("expense.payerPicker")

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

            Button("Add Expense") {
                viewModel.addExpense()
            }
            .disabled(!viewModel.canAddExpense)
            .accessibilityIdentifier("expense.addButton")
        }
    }

    private var expensesSection: some View {
        Section("Expenses") {
            if viewModel.expenses.isEmpty {
                Text("No expenses yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.expenses) { expense in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(expense.title)
                                .font(.headline)
                            Spacer()
                            Text(currencyFormatter.string(from: expense.amount))
                                .font(.headline)
                        }
                        Text("Paid by \(viewModel.memberName(for: expense.payerID))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            viewModel.removeExpense(expense)
                        }
                    }
                }
            }
        }
    }

    private var balancesSection: some View {
        Section("Balances") {
            ForEach(viewModel.balances) { balance in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(balance.member.name)
                            .font(.headline)
                        Text("Paid \(currencyFormatter.string(from: balance.paid)) • Owes \(currencyFormatter.string(from: balance.owed))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(currencyFormatter.string(from: balance.net))
                        .foregroundStyle(balance.net >= 0 ? .green : .red)
                        .font(.headline)
                }
            }
        }
    }

    private var settlementsSection: some View {
        Section("Settle Up") {
            if viewModel.settlements.isEmpty {
                Text(viewModel.expenses.isEmpty ? "Add expenses to see settlements." : "Everyone is settled.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.settlements) { settlement in
                    Text("\(settlement.from.name) pays \(settlement.to.name) \(currencyFormatter.string(from: settlement.amount))")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
