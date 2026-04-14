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
        .listRowBackground(PayhubColor.surfacePrimary)
        .enableInjection()
    }
}

private struct ExpenseRow: View {
    let expense: Expense
    let currencyFormatter: CurrencyFormatterService
    let payerName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(expense.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(PayhubColor.textPrimary)

                Spacer()

                Text(currencyFormatter.string(from: expense.amount))
                    .font(.headline.weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(PayhubColor.textPrimary)
            }

            Text("Paid by \(payerName)")
                .font(.caption.weight(.medium))
                .foregroundStyle(PayhubColor.textTertiary)
        }
        .padding(.vertical, 4)
    }
}
