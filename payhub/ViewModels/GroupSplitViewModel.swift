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

    var canSubmitExpense: Bool {
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

    func submitExpense() {
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

        resetExpenseForm()
    }

    func updateExpense(
        _ expense: Expense,
        title: String,
        amountText: String,
        payerID: UUID?,
        participantIDs: Set<UUID>
    ) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedAmount = amountText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            let payerID,
            !participantIDs.isEmpty,
            !trimmedTitle.isEmpty,
            !normalizedAmount.contains(","),
            let amount = Decimal(string: normalizedAmount, locale: Locale(identifier: "en_US_POSIX")),
            amount > 0,
            let expenseIndex = expenses.firstIndex(where: { $0.id == expense.id })
        else {
            return
        }

        expenses[expenseIndex].title = trimmedTitle
        expenses[expenseIndex].amount = amount
        expenses[expenseIndex].payerID = payerID
        expenses[expenseIndex].participantIDs = participantIDs
    }

    func removeExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
    }

    func memberName(for id: UUID) -> String {
        members.first { $0.id == id }?.name ?? "Unknown"
    }

    private var parsedExpenseAmount: Decimal? {
        let normalizedAmount = expenseAmount.trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            !normalizedAmount.contains(","),
            let amount = Decimal(string: normalizedAmount, locale: Locale(identifier: "en_US_POSIX")),
            amount > 0
        else {
            return nil
        }

        return amount
    }

    private func resetExpenseForm() {
        expenseTitle = ""
        expenseAmount = ""
        selectedPayerID = members.first?.id
        selectedParticipantIDs = Set(members.map(\.id))
    }

    private static let sampleMembers = [
        Member(name: "Alex"),
        Member(name: "Bao"),
        Member(name: "Casey")
    ]
}
