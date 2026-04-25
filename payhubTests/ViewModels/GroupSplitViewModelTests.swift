//
//  GroupSplitViewModelTests.swift
//  payhubTests
//

import XCTest
@testable import payhub

final class GroupSplitViewModelTests: XCTestCase {
    func testCanAddBillRejectsGroupingSeparators() {
        let viewModel = GroupSplitViewModel()
        viewModel.billTitle = "Dinner"
        viewModel.billAmount = "1,234"

        XCTAssertFalse(viewModel.canSubmitBill)
    }

    func testCanAddBillAcceptsDecimalAmounts() {
        let viewModel = GroupSplitViewModel()
        viewModel.billTitle = "Dinner"
        viewModel.billAmount = "120.50"

        XCTAssertTrue(viewModel.canSubmitBill)
    }

    func testSubmitBillAppendsNewBill() {
        let viewModel = GroupSplitViewModel()

        viewModel.billTitle = "Dinner"
        viewModel.billAmount = "120.50"

        viewModel.submitBill()

        XCTAssertEqual(viewModel.bills.count, 1)
        XCTAssertEqual(viewModel.bills.first?.title, "Dinner")
        XCTAssertEqual(viewModel.bills.first?.amount, Decimal(string: "120.50"))
    }

    func testUpdateBillChangesExistingBill() {
        let payer = Member(name: "Alex")
        let participant = Member(name: "Bao")
        let bill = Bill(
            title: "Dinner",
            amount: Decimal(string: "120.50") ?? 0,
            payerID: payer.id,
            participantIDs: [payer.id, participant.id]
        )
        let viewModel = GroupSplitViewModel(
            members: [payer, participant],
            bills: [bill]
        )

        viewModel.updateBill(
            bill,
            title: "Team Dinner",
            amountText: "150",
            payerID: payer.id,
            participantIDs: [payer.id]
        )

        XCTAssertEqual(viewModel.bills.count, 1)
        XCTAssertEqual(viewModel.bills.first?.id, bill.id)
        XCTAssertEqual(viewModel.bills.first?.title, "Team Dinner")
        XCTAssertEqual(viewModel.bills.first?.amount, Decimal(string: "150"))
        XCTAssertEqual(viewModel.bills.first?.participantIDs, [payer.id])
    }

    func testUpdateBillIgnoresInvalidChanges() {
        let payer = Member(name: "Alex")
        let bill = Bill(
            title: "Coffee",
            amount: Decimal(string: "20") ?? 0,
            payerID: payer.id,
            participantIDs: [payer.id]
        )
        let viewModel = GroupSplitViewModel(
            members: [payer],
            bills: [bill]
        )

        viewModel.updateBill(
            bill,
            title: "   ",
            amountText: "invalid",
            payerID: nil,
            participantIDs: []
        )

        XCTAssertEqual(viewModel.bills.first?.title, "Coffee")
        XCTAssertEqual(viewModel.bills.first?.amount, Decimal(string: "20"))
    }

    func testRemoveBillDeletesExistingBill() {
        let bill = Bill(
            title: "Coffee",
            amount: Decimal(string: "20") ?? 0,
            payerID: UUID(),
            participantIDs: [UUID()]
        )
        let viewModel = GroupSplitViewModel(bills: [bill])

        viewModel.removeBill(bill)

        XCTAssertTrue(viewModel.bills.isEmpty)
    }
}
