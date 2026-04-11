//
//  Expense.swift
//  payhub
//

import Foundation

struct Expense: Identifiable, Hashable {
    let id: UUID
    var title: String
    var amount: Decimal
    var payerID: UUID
    var participantIDs: Set<UUID>

    init(
        id: UUID = UUID(),
        title: String,
        amount: Decimal,
        payerID: UUID,
        participantIDs: Set<UUID>
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.payerID = payerID
        self.participantIDs = participantIDs
    }
}

