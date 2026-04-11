//
//  SplitCalculator.swift
//  divpay
//

import Foundation

struct SplitCalculator {
    func balances(for members: [Member], expenses: [Expense]) -> [MemberBalance] {
        let memberIDs = Set(members.map(\.id))
        var paidCents = Dictionary(uniqueKeysWithValues: members.map { ($0.id, 0) })
        var owedCents = Dictionary(uniqueKeysWithValues: members.map { ($0.id, 0) })

        for expense in expenses where memberIDs.contains(expense.payerID) {
            let participants = expense.participantIDs
                .filter { memberIDs.contains($0) }
                .sorted { $0.uuidString < $1.uuidString }

            guard !participants.isEmpty else {
                continue
            }

            let totalCents = Self.cents(from: expense.amount)
            paidCents[expense.payerID, default: 0] += totalCents

            let baseShare = totalCents / participants.count
            let remainder = totalCents % participants.count

            for (index, participantID) in participants.enumerated() {
                owedCents[participantID, default: 0] += baseShare + (index < remainder ? 1 : 0)
            }
        }

        return members.map { member in
            let paid = paidCents[member.id, default: 0]
            let owed = owedCents[member.id, default: 0]

            return MemberBalance(
                member: member,
                paid: Self.decimal(fromCents: paid),
                owed: Self.decimal(fromCents: owed),
                net: Self.decimal(fromCents: paid - owed)
            )
        }
    }

    func settlements(for members: [Member], expenses: [Expense]) -> [SettlementTransaction] {
        let balancesByMember = balances(for: members, expenses: expenses)
        var debtors = balancesByMember
            .map { ($0.member, Self.cents(from: -$0.net)) }
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
        var creditors = balancesByMember
            .map { ($0.member, Self.cents(from: $0.net)) }
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
                        amount: Self.decimal(fromCents: amount)
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

    static func cents(from amount: Decimal) -> Int {
        let number = NSDecimalNumber(decimal: amount)
        let cents = number.multiplying(byPowerOf10: 2)
        let rounded = cents.rounding(accordingToBehavior: NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: 0,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        ))

        return rounded.intValue
    }

    static func decimal(fromCents cents: Int) -> Decimal {
        Decimal(cents) / Decimal(100)
    }
}

