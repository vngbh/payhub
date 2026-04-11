//
//  MembersSection.swift
//  payhub
//

import SwiftUI

struct MembersSection: View {
    @ObservedObject var viewModel: GroupSplitViewModel

    var body: some View {
        Section("Members") {
            HStack {
                TextField("Member name", text: $viewModel.memberName)
                    .textInputAutocapitalization(.words)
                    .accessibilityIdentifier("members.nameField")

                Button("Add") {
                    viewModel.addMember()
                }
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("members.addButton")
            }

            ForEach(viewModel.members) { member in
                MemberRow(
                    member: member,
                    removeMember: viewModel.removeMember(_:)
                )
            }
        }
    }
}

private struct MemberRow: View {
    let member: Member
    let removeMember: (Member) -> Void

    var body: some View {
        HStack {
            Text(member.name)

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

