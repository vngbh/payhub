//
//  SplitCalculator.swift
//  payhub
//

import Foundation

struct SplitCalculator {
    func balances(for members: [Member], bills: [Bill]) -> [MemberBalance] {
        let memberIDs = Set(members.map(\.id))
        var paidAmounts = Dictionary(uniqueKeysWithValues: members.map { ($0.id, Decimal(0)) })
        var owedAmounts = Dictionary(uniqueKeysWithValues: members.map { ($0.id, Decimal(0)) })

        for bill in bills where memberIDs.contains(bill.payerID) {
            let participants = bill.participantIDs
                .filter { memberIDs.contains($0) }
                .sorted { $0.uuidString < $1.uuidString }

            guard !participants.isEmpty else {
                continue
            }

            paidAmounts[bill.payerID, default: 0] += bill.amount

            let share = bill.amount / Decimal(participants.count)
            var allocatedAmount = Decimal(0)

            for (index, participantID) in participants.enumerated() {
                let owedShare = index == participants.count - 1
                    ? bill.amount - allocatedAmount
                    : share

                owedAmounts[participantID, default: 0] += owedShare
                allocatedAmount += owedShare
            }
        }

        return members.map { member in
            let paid = paidAmounts[member.id, default: 0]
            let owed = owedAmounts[member.id, default: 0]

            return MemberBalance(
                member: member,
                paid: paid,
                owed: owed,
                net: paid - owed
            )
        }
    }

    func settlements(for members: [Member], bills: [Bill]) -> [SettlementTransaction] {
        let balancesByMember = balances(for: members, bills: bills)
        var debtors = balancesByMember
            .map { ($0.member, -$0.net) }
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
        var creditors = balancesByMember
            .map { ($0.member, $0.net) }
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
        var transactions: [SettlementTransaction] = []

        var debtorIndex = 0
        var creditorIndex = 0

        while debtorIndex < debtors.count && creditorIndex < creditors.count {
            let amount = min(debtors[debtorIndex].1, creditors[creditorIndex].1)

            if amount > 0 {
                transactions.append(
                    SettlementTransaction(
                        from: debtors[debtorIndex].0,
                        to: creditors[creditorIndex].0,
                        amount: amount
                    )
                )
            }

            debtors[debtorIndex].1 -= amount
            creditors[creditorIndex].1 -= amount

            if debtors[debtorIndex].1 == 0 {
                debtorIndex += 1
            }

            if creditors[creditorIndex].1 == 0 {
                creditorIndex += 1
            }
        }

        return transactions
    }
}
