//
//  EmptyStateRow.swift
//  payhub
//

import SwiftUI

struct EmptyStateRow: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundStyle(.secondary)
    }
}

