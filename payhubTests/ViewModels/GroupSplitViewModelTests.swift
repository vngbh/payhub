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

        XCTAssertFalse(viewModel.canAddExpense)
    }

    func testCanAddExpenseAcceptsDecimalAmounts() {
        let viewModel = GroupSplitViewModel()
        viewModel.expenseTitle = "Dinner"
        viewModel.expenseAmount = "120.50"

        XCTAssertTrue(viewModel.canAddExpense)
    }
}
