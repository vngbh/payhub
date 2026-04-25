//
//  GroupSplitViewModel.swift
//  payhub
//

import Foundation
import Combine

final class GroupSplitViewModel: ObservableObject {
    @Published private(set) var members: [Member]
    @Published private(set) var bills: [Bill]
    @Published var memberName = ""
    @Published var billTitle = ""
    @Published var billAmount = ""
    @Published var selectedPayerID: UUID?
    @Published var selectedParticipantIDs: Set<UUID> = []

    private let calculator: SplitCalculator

    init(
        members: [Member]? = nil,
        bills: [Bill] = [],
        calculator: SplitCalculator = SplitCalculator()
    ) {
        self.members = members ?? Self.sampleMembers
        self.bills = bills
        self.calculator = calculator
        selectedPayerID = self.members.first?.id
        selectedParticipantIDs = Set(self.members.map(\.id))
    }

    var canSubmitBill: Bool {
        !billTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && parsedBillAmount != nil
            && selectedPayerID != nil
            && !selectedParticipantIDs.isEmpty
    }

    var balances: [MemberBalance] {
        calculator.balances(for: members, bills: bills)
    }

    var settlements: [SettlementTransaction] {
        calculator.settlements(for: members, bills: bills)
    }

    var totalSpent: Decimal {
        bills.reduce(Decimal(0)) { $0 + $1.amount }
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
        bills.removeAll { $0.payerID == member.id || $0.participantIDs.contains(member.id) }
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

    func submitBill() {
        let trimmedTitle = billTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            let amount = parsedBillAmount,
            let payerID = selectedPayerID,
            !selectedParticipantIDs.isEmpty,
            !trimmedTitle.isEmpty
        else {
            return
        }

        bills.append(Bill(
            title: trimmedTitle,
            amount: amount,
            payerID: payerID,
            participantIDs: selectedParticipantIDs
        ))

        resetBillForm()
    }

    func updateBill(
        _ bill: Bill,
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
            let billIndex = bills.firstIndex(where: { $0.id == bill.id })
        else {
            return
        }

        bills[billIndex].title = trimmedTitle
        bills[billIndex].amount = amount
        bills[billIndex].payerID = payerID
        bills[billIndex].participantIDs = participantIDs
    }

    func removeBill(_ bill: Bill) {
        bills.removeAll { $0.id == bill.id }
    }

    func memberName(for id: UUID) -> String {
        members.first { $0.id == id }?.name ?? "Unknown"
    }

    private var parsedBillAmount: Decimal? {
        let normalizedAmount = billAmount.trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            !normalizedAmount.contains(","),
            let amount = Decimal(string: normalizedAmount, locale: Locale(identifier: "en_US_POSIX")),
            amount > 0
        else {
            return nil
        }

        return amount
    }

    private func resetBillForm() {
        billTitle = ""
        billAmount = ""
        selectedPayerID = members.first?.id
        selectedParticipantIDs = Set(members.map(\.id))
    }

    private static let sampleMembers = [
        Member(name: "Alex"),
        Member(name: "Bao"),
        Member(name: "Casey")
    ]
}
