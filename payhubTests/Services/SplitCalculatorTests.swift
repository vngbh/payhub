//
//  SplitCalculatorTests.swift
//  payhubTests
//

import XCTest
@testable import payhub

final class SplitCalculatorTests: XCTestCase {
    private let calculator = SplitCalculator()

    func testEvenSplitAcrossAllMembers() {
        let alex = Member(name: "Alex")
        let bao = Member(name: "Bao")
        let casey = Member(name: "Casey")
        let members = [alex, bao, casey]
        let bill = Bill(
            title: "Dinner",
            amount: 90,
            payerID: alex.id,
            participantIDs: Set(members.map(\.id))
        )

        let balances = calculator.balances(for: members, bills: [bill])

        XCTAssertEqual(balance(for: alex, in: balances)?.paid, 90)
        XCTAssertEqual(balance(for: alex, in: balances)?.owed, 30)
        XCTAssertEqual(balance(for: alex, in: balances)?.net, 60)
        XCTAssertEqual(balance(for: bao, in: balances)?.net, -30)
        XCTAssertEqual(balance(for: casey, in: balances)?.net, -30)
    }

    func testPartialSplitOnlyChargesParticipants() {
        let alex = Member(name: "Alex")
        let bao = Member(name: "Bao")
        let casey = Member(name: "Casey")
        let members = [alex, bao, casey]
        let bill = Bill(
            title: "Taxi",
            amount: 40,
            payerID: bao.id,
            participantIDs: [alex.id, bao.id]
        )

        let balances = calculator.balances(for: members, bills: [bill])

        XCTAssertEqual(balance(for: alex, in: balances)?.net, -20)
        XCTAssertEqual(balance(for: bao, in: balances)?.net, 20)
        XCTAssertEqual(balance(for: casey, in: balances)?.net, 0)
    }

    func testSettlementsMinimizeTransfers() {
        let alex = Member(name: "Alex")
        let bao = Member(name: "Bao")
        let casey = Member(name: "Casey")
        let members = [alex, bao, casey]
        let bills = [
            Bill(title: "Dinner", amount: 90, payerID: alex.id, participantIDs: Set(members.map(\.id))),
            Bill(title: "Dessert", amount: 30, payerID: bao.id, participantIDs: Set(members.map(\.id)))
        ]

        let settlements = calculator.settlements(for: members, bills: bills)

        XCTAssertEqual(settlements.count, 2)
        XCTAssertEqual(settlements.reduce(Decimal(0)) { $0 + $1.amount }, 50)
        XCTAssertTrue(settlements.allSatisfy { $0.to.id == alex.id })
    }

    func testDecimalSplitKeepsTotalOwedEqualToTotalPaid() {
        let alex = Member(name: "Alex")
        let bao = Member(name: "Bao")
        let casey = Member(name: "Casey")
        let members = [alex, bao, casey]
        let bill = Bill(
            title: "Snacks",
            amount: 10,
            payerID: alex.id,
            participantIDs: Set(members.map(\.id))
        )

        let balances = calculator.balances(for: members, bills: [bill])
        let totalPaid = balances.reduce(Decimal(0)) { $0 + $1.paid }
        let totalOwed = balances.reduce(Decimal(0)) { $0 + $1.owed }

        XCTAssertEqual(totalPaid, 10)
        XCTAssertEqual(totalOwed, 10)
    }

    func testDecimalSplitKeepsFractionalAmountsInData() {
        let alex = Member(name: "Alex")
        let bao = Member(name: "Bao")
        let casey = Member(name: "Casey")
        let members = [alex, bao, casey]
        let bill = Bill(
            title: "Snacks",
            amount: 10,
            payerID: alex.id,
            participantIDs: Set(members.map(\.id))
        )

        let balances = calculator.balances(for: members, bills: [bill])

        XCTAssertTrue(balances.contains { balance in
            let integerAmount = NSDecimalNumber(decimal: balance.owed).intValue
            return balance.owed != Decimal(integerAmount)
        })
        XCTAssertEqual(balances.reduce(Decimal(0)) { $0 + $1.owed }, 10)
    }

    private func balance(for member: Member, in balances: [MemberBalance]) -> MemberBalance? {
        balances.first { $0.member.id == member.id }
    }
}
