//
//  GroupSplitView.swift
//  payhub
//

import Inject
import SwiftUI

struct GroupSplitView: View {
    @ObserveInjection var inject

    @StateObject private var viewModel = GroupSplitViewModel()
    private let currencyFormatter = CurrencyFormatterService()

    var body: some View {
        NavigationStack {
            List {
                OverviewSection(
                    totalSpent: viewModel.totalSpent,
                    currencyFormatter: currencyFormatter
                )

                MembersSection(viewModel: viewModel)

                ExpenseFormSection(viewModel: viewModel)

                ExpensesSection(
                    expenses: viewModel.expenses,
                    currencyFormatter: currencyFormatter,
                    memberName: viewModel.memberName(for:),
                    removeExpense: viewModel.removeExpense(_:)
                )

                BalancesSection(
                    balances: viewModel.balances,
                    currencyFormatter: currencyFormatter
                )

                SettlementsSection(
                    settlements: viewModel.settlements,
                    hasExpenses: !viewModel.expenses.isEmpty,
                    currencyFormatter: currencyFormatter
                )
            }
            .navigationTitle("payhub")
        }
        .enableInjection()
    }
}

struct GroupSplitView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSplitView()
    }
}
