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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(PayhubColor.surfacePrimary)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(PayhubColor.borderSubtle.opacity(0.9), lineWidth: 1)
            )
            .shadow(color: PayhubColor.textPrimary.opacity(0.04), radius: 12, x: 0, y: 6)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            ForEach(viewModel.members) { member in
                MemberRow(
                    member: member,
                    removeMember: viewModel.removeMember(_:)
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listRowBackground(Color.clear)
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

            Image(systemName: "trash")
                .foregroundStyle(PayhubColor.balanceNegative)
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
                .onTapGesture {
                    removeMember(member)
                }
                .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Remove \(member.name)")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(PayhubColor.surfacePrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(PayhubColor.borderSubtle.opacity(0.9), lineWidth: 1)
        )
        .shadow(color: PayhubColor.textPrimary.opacity(0.04), radius: 12, x: 0, y: 6)
    }
}
