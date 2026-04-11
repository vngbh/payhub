//
//  GroupSplitViewModel.swift
//  payhub
//

import Foundation
import Combine

final class GroupSplitViewModel: ObservableObject {
    @Published private(set) var members: [Member]
    @Published private(set) var expenses: [Expense]
    @Published var memberName = ""
    @Published var expenseTitle = ""
    @Published var expenseAmount = ""
    @Published var selectedPayerID: UUID?
    @Published var selectedParticipantIDs: Set<UUID> = []

    private let calculator: SplitCalculator

    init(
        members: [Member]? = nil,
        expenses: [Expense] = [],
        calculator: SplitCalculator = SplitCalculator()
    ) {
        self.members = members ?? Self.sampleMembers
        self.expenses = expenses
        self.calculator = calculator
        selectedPayerID = self.members.first?.id
        selectedParticipantIDs = Set(self.members.map(\.id))
    }

    var canAddExpense: Bool {
        !expenseTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && parsedExpenseAmount != nil
            && selectedPayerID != nil
            && !selectedParticipantIDs.isEmpty
    }

    var balances: [MemberBalance] {
        calculator.balances(for: members, expenses: expenses)
    }

    var settlements: [SettlementTransaction] {
        calculator.settlements(for: members, expenses: expenses)
    }

    var totalSpent: Decimal {
        expenses.reduce(Decimal(0)) { $0 + $1.amount }
    }

    func addMember() {
        let trimmedName = memberName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            return
        }

        let member = Member(name: trimmedName)
        members.append(member)
        memberName = ""
        selectedParticipantIDs.insert(member.id)

        if selectedPayerID == nil {
            selectedPayerID = member.id
        }
    }

    func removeMember(_ member: Member) {
        members.removeAll { $0.id == member.id }
        expenses.removeAll { $0.payerID == member.id || $0.participantIDs.contains(member.id) }
        selectedParticipantIDs.remove(member.id)

        if selectedPayerID == member.id {
            selectedPayerID = members.first?.id
        }
    }

    func toggleParticipant(_ member: Member) {
        if selectedParticipantIDs.contains(member.id) {
            selectedParticipantIDs.remove(member.id)
        } else {
            selectedParticipantIDs.insert(member.id)
        }
    }

    func addExpense() {
        let trimmedTitle = expenseTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            let amount = parsedExpenseAmount,
            let payerID = selectedPayerID,
            !selectedParticipantIDs.isEmpty,
            !trimmedTitle.isEmpty
        else {
            return
        }

        expenses.append(Expense(
            title: trimmedTitle,
            amount: amount,
            payerID: payerID,
            participantIDs: selectedParticipantIDs
        ))

        expenseTitle = ""
        expenseAmount = ""
        selectedParticipantIDs = Set(members.map(\.id))
    }

    func removeExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
    }

    func memberName(for id: UUID) -> String {
        members.first { $0.id == id }?.name ?? "Unknown"
    }

    private var parsedExpenseAmount: Decimal? {
        let normalizedAmount = expenseAmount
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        guard let amount = Decimal(string: normalizedAmount), amount > 0 else {
            return nil
        }

        return amount
    }

    private static let sampleMembers = [
        Member(name: "Alex"),
        Member(name: "Bao"),
        Member(name: "Casey")
    ]
}
