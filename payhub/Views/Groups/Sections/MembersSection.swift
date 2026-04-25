//
//  MembersView.swift
//  payhub
//

import Inject
import SwiftUI

struct MembersView: View {
    @ObserveInjection var inject
    @EnvironmentObject var viewModel: GroupSplitViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 14) {
                Button { dismiss() } label: {
                    ZStack {
                        Circle()
                            .fill(PayhubColor.surfacePrimary)
                            .overlay(Circle().stroke(PayhubColor.borderSubtle, lineWidth: 1.5))
                            .frame(width: 36, height: 36)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(PayhubColor.textPrimary)
                    }
                }
                .buttonStyle(.plain)

                Text("Members")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundStyle(PayhubColor.textPrimary)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(PayhubColor.surfacePrimary)
            .overlay(alignment: .bottom) {
                Rectangle().fill(PayhubColor.borderSubtle).frame(height: 1)
            }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    // Add field
                    HStack(spacing: 10) {
                        TextField("Enter member name", text: $viewModel.memberName)
                            .textInputAutocapitalization(.words)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(PayhubColor.textPrimary)
                            .tint(PayhubColor.bluePrimary)
                            .accessibilityIdentifier("members.nameField")

                        Button {
                            viewModel.addMember()
                        } label: {
                            Text("Add")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(PayhubColor.dark, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("members.addButton")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(PayhubColor.surfacePrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(PayhubColor.borderSubtle, lineWidth: 1.5)
                    )
                    .shadow(color: PayhubColor.bluePrimary.opacity(0.08), radius: 12, x: 0, y: 8)

                    // Member list
                    ForEach(viewModel.members) { member in
                        MemberRow(member: member, onRemove: { viewModel.removeMember(member) })
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .padding(.bottom, 40)
            }
            .background(PayhubColor.appBackground)
        }
        .enableInjection()
    }
}

private struct MemberRow: View {
    let member: Member
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [PayhubColor.bluePrimary, PayhubColor.blueDeep],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                    .frame(width: 40, height: 40)
                Text(String(member.name.prefix(1)).uppercased())
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(.white)
            }

            Text(member.name)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(PayhubColor.textPrimary)

            Spacer()

            Button(action: onRemove) {
                ZStack {
                    Circle()
                        .fill(Color(red: 1, green: 240 / 255, blue: 243 / 255))
                        .frame(width: 32, height: 32)
                    Image(systemName: "trash")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(PayhubColor.balanceNegative)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(member.name)")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(PayhubColor.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(PayhubColor.borderSubtle, lineWidth: 1.5)
        )
        .shadow(color: PayhubColor.bluePrimary.opacity(0.08), radius: 12, x: 0, y: 8)
    }
}
