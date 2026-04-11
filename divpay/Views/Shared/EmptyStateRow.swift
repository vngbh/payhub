//
//  EmptyStateRow.swift
//  divpay
//

import SwiftUI

struct EmptyStateRow: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundStyle(.secondary)
    }
}

