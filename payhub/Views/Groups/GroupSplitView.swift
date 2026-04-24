//
//  GroupSplitView.swift
//  payhub
//

import Inject
import SwiftUI

struct GroupSplitView: View {
    @ObserveInjection var inject

    @StateObject private var viewModel = GroupSplitViewModel()
    @State private var isPresentingExpenseDialog = false
    private let currencyFormatter = CurrencyFormatterService()

    var body: some View {
        NavigationStack {
            List {
                OverviewSection(
                    totalSpent: viewModel.totalSpent,
                    currencyFormatter: currencyFormatter
                )

                MembersSection(viewModel: viewModel)

                ExpensesSection(
                    members: viewModel.members,
                    expenses: viewModel.expenses,
                    currencyFormatter: currencyFormatter,
                    memberName: viewModel.memberName(for:),
                    updateExpense: viewModel.updateExpense(_:title:amountText:payerID:participantIDs:),
                    removeExpense: viewModel.removeExpense(_:)
                )

                CreateExpenseSection {
                    isPresentingExpenseDialog = true
                }

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
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(PayhubColor.appBackground)
            .navigationTitle("payhub")
            .tint(PayhubColor.brandPrimary)
        }
        .sheet(isPresented: $isPresentingExpenseDialog) {
            NavigationStack {
                ScrollView {
                    ExpenseFormSection(
                        viewModel: viewModel,
                        submitTitle: "Create Expense",
                        onSubmit: {
                            guard viewModel.canSubmitExpense else {
                                return
                            }

                            viewModel.submitExpense()
                            isPresentingExpenseDialog = false
                        }
                    )
                    .padding(16)
                }
                .background(PayhubColor.appBackground)
                .navigationTitle("Add Expense")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Close") {
                            isPresentingExpenseDialog = false
                        }
                    }
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .enableInjection()
    }
}

struct GroupSplitView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSplitView()
    }
}

private struct CreateExpenseSection: View {
    let createExpense: () -> Void

    var body: some View {
        Section {
            Button(action: createExpense) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(PayhubColor.brandPrimary)

                    Text("Create")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(PayhubColor.textPrimary)

                    Spacer()
                }
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
            }
            .buttonStyle(.plain)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
