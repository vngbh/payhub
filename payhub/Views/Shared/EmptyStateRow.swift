//
//  EmptyStateRow.swift
//  payhub
//

import Inject
import SwiftUI

struct EmptyStateRow: View {
    @ObserveInjection var inject

    let message: String

    var body: some View {
        Text(message)
            .foregroundStyle(.secondary)
            .enableInjection()
    }
}
