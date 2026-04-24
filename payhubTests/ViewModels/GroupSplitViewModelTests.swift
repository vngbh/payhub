//
//  GroupSplitViewModelTests.swift
//  payhubTests
//

import XCTest
@testable import payhub

final class GroupSplitViewModelTests: XCTestCase {
    func testCanAddExpenseRejectsGroupingSeparators() {
        let viewModel = GroupSplitViewModel()
        viewModel.expenseTitle = "Dinner"
        viewModel.expenseAmount = "1,234"

        XCTAssertFalse(viewModel.canSubmitExpense)
    }

    func testCanAddExpenseAcceptsDecimalAmounts() {
        let viewModel = GroupSplitViewModel()
        viewModel.expenseTitle = "Dinner"
        viewModel.expenseAmount = "120.50"

        XCTAssertTrue(viewModel.canSubmitExpense)
    }

    func testSubmitExpenseAppendsNewExpense() {
        let viewModel = GroupSplitViewModel()

        viewModel.expenseTitle = "Dinner"
        viewModel.expenseAmount = "120.50"

        viewModel.submitExpense()

        XCTAssertEqual(viewModel.expenses.count, 1)
        XCTAssertEqual(viewModel.expenses.first?.title, "Dinner")
        XCTAssertEqual(viewModel.expenses.first?.amount, Decimal(string: "120.50"))
    }

    func testUpdateExpenseChangesExistingExpense() {
        let payer = Member(name: "Alex")
        let participant = Member(name: "Bao")
        let expense = Expense(
            title: "Dinner",
            amount: Decimal(string: "120.50") ?? 0,
            payerID: payer.id,
            participantIDs: [payer.id, participant.id]
        )
        let viewModel = GroupSplitViewModel(
            members: [payer, participant],
            expenses: [expense]
        )

        viewModel.updateExpense(
            expense,
            title: "Team Dinner",
            amountText: "150",
            payerID: payer.id,
            participantIDs: [payer.id]
        )

        XCTAssertEqual(viewModel.expenses.count, 1)
        XCTAssertEqual(viewModel.expenses.first?.id, expense.id)
        XCTAssertEqual(viewModel.expenses.first?.title, "Team Dinner")
        XCTAssertEqual(viewModel.expenses.first?.amount, Decimal(string: "150"))
        XCTAssertEqual(viewModel.expenses.first?.participantIDs, [payer.id])
    }

    func testUpdateExpenseIgnoresInvalidChanges() {
        let payer = Member(name: "Alex")
        let expense = Expense(
            title: "Coffee",
            amount: Decimal(string: "20") ?? 0,
            payerID: payer.id,
            participantIDs: [payer.id]
        )
        let viewModel = GroupSplitViewModel(
            members: [payer],
            expenses: [expense]
        )

        viewModel.updateExpense(
            expense,
            title: "   ",
            amountText: "invalid",
            payerID: nil,
            participantIDs: []
        )

        XCTAssertEqual(viewModel.expenses.first?.title, "Coffee")
        XCTAssertEqual(viewModel.expenses.first?.amount, Decimal(string: "20"))
    }

    func testRemoveExpenseDeletesExistingExpense() {
        let expense = Expense(
            title: "Coffee",
            amount: Decimal(string: "20") ?? 0,
            payerID: UUID(),
            participantIDs: [UUID()]
        )
        let viewModel = GroupSplitViewModel(expenses: [expense])

        viewModel.removeExpense(expense)

        XCTAssertTrue(viewModel.expenses.isEmpty)
    }
}
