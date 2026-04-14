//
//  MembersSection.swift
//  payhub
//

import Inject
import SwiftUI

struct MembersSection: View {
    @ObserveInjection var inject

    @ObservedObject var viewModel: GroupSplitViewModel

    var body: some View {
        Section("Members") {
            HStack(spacing: 12) {
                TextField("Member name", text: $viewModel.memberName)
                    .textInputAutocapitalization(.words)
                    .font(.body.weight(.medium))
                    .accessibilityIdentifier("members.nameField")

                Button {
                    viewModel.addMember()
                } label: {
                    Text("Add")
                        .foregroundStyle(PayhubColor.textOnAccent)
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("members.addButton")
            }
            .tint(PayhubColor.brandPrimary)

            ForEach(viewModel.members) { member in
                MemberRow(
                    member: member,
                    removeMember: viewModel.removeMember(_:)
                )
            }
        }
        .listRowBackground(PayhubColor.surfacePrimary)
        .listRowSeparator(.hidden)
        .enableInjection()
    }
}

private struct MemberRow: View {
    let member: Member
    let removeMember: (Member) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(String(member.name.prefix(1)).uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(PayhubColor.textOnAccent)
                .frame(width: 28, height: 28)
                .background(PayhubColor.brandPrimary, in: Circle())

            Text(member.name)
                .font(.body.weight(.semibold))
                .foregroundStyle(PayhubColor.textPrimary)

            Spacer()

            Button(role: .destructive) {
                removeMember(member)
            } label: {
                Image(systemName: "trash")
            }
            .accessibilityLabel("Remove \(member.name)")
        }
    }
}
