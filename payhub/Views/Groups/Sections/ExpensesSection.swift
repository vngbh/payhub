//
//  ExpensesSection.swift
//  payhub
//

import Inject
import SwiftUI

struct ExpensesSection: View {
    @ObserveInjection var inject

    let expenses: [Expense]
    let currencyFormatter: CurrencyFormatterService
    let memberName: (UUID) -> String
    let removeExpense: (Expense) -> Void

    var body: some View {
        Section("Expenses") {
            if expenses.isEmpty {
                EmptyStateRow(message: "No expenses yet.")
            } else {
                ForEach(expenses) { expense in
                    ExpenseRow(
                        expense: expense,
                        currencyFormatter: currencyFormatter,
                        payerName: memberName(expense.payerID)
                    )
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            removeExpense(expense)
                        }
                    }
                }
            }
        }
        .enableInjection()
    }
}

private struct ExpenseRow: View {
    let expense: Expense
    let currencyFormatter: CurrencyFormatterService
    let payerName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(expense.title)
                    .font(.headline)

                Spacer()

                Text(currencyFormatter.string(from: expense.amount))
                    .font(.headline)
            }

            Text("Paid by \(payerName)")
                .font(.subheadline)
                .foregroundStyle(PayhubColor.textSecondary)
        }
    }
}
