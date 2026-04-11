//
//  Settlement.swift
//  divpay
//

import Foundation

struct MemberBalance: Identifiable, Hashable {
    let member: Member
    let paid: Decimal
    let owed: Decimal
    let net: Decimal

    var id: UUID {
        member.id
    }
}

struct SettlementTransaction: Identifiable, Hashable {
    let id = UUID()
    let from: Member
    let to: Member
    let amount: Decimal
}

