//
//  ExpensesSection.swift
//  payhub
//

import Inject
import SwiftUI

struct ExpensesSection: View {
    @ObserveInjection var inject

    @State private var expandedExpenseID: UUID?

    let members: [Member]
    let expenses: [Expense]
    let currencyFormatter: CurrencyFormatterService
    let memberName: (UUID) -> String
    let updateExpense: (Expense, String, String, UUID?, Set<UUID>) -> Void
    let removeExpense: (Expense) -> Void

    var body: some View {
        Section("Expenses") {
            if expenses.isEmpty {
                EmptyStateRow(message: "No expenses yet.")
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
            } else {
                ForEach(expenses) { expense in
                    ExpandableExpenseRow(
                        isExpanded: expandedExpenseID == expense.id,
                        expense: expense,
                        members: members,
                        currencyFormatter: currencyFormatter,
                        payerName: memberName(expense.payerID),
                        toggleExpanded: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                expandedExpenseID = expandedExpenseID == expense.id ? nil : expense.id
                            }
                        },
                        updateExpense: updateExpense,
                        removeExpense: { selectedExpense in
                            removeExpense(selectedExpense)

                            if expandedExpenseID == selectedExpense.id {
                                expandedExpenseID = nil
                            }
                        }
                    )
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .enableInjection()
    }
}

private struct ExpandableExpenseRow: View {
    @State private var draftTitle: String
    @State private var draftAmount: String
    @State private var draftPayerID: UUID?
    @State private var draftParticipantIDs: Set<UUID>
    @State private var pendingAction: PendingAction?

    let isExpanded: Bool
    let expense: Expense
    let members: [Member]
    let currencyFormatter: CurrencyFormatterService
    let payerName: String
    let toggleExpanded: () -> Void
    let updateExpense: (Expense, String, String, UUID?, Set<UUID>) -> Void
    let removeExpense: (Expense) -> Void

    init(
        isExpanded: Bool,
        expense: Expense,
        members: [Member],
        currencyFormatter: CurrencyFormatterService,
        payerName: String,
        toggleExpanded: @escaping () -> Void,
        updateExpense: @escaping (Expense, String, String, UUID?, Set<UUID>) -> Void,
        removeExpense: @escaping (Expense) -> Void
    ) {
        self.isExpanded = isExpanded
        self.expense = expense
        self.members = members
        self.currencyFormatter = currencyFormatter
        self.payerName = payerName
        self.toggleExpanded = toggleExpanded
        self.updateExpense = updateExpense
        self.removeExpense = removeExpense
        _draftTitle = State(initialValue: expense.title)
        _draftAmount = State(initialValue: NSDecimalNumber(decimal: expense.amount).stringValue)
        _draftPayerID = State(initialValue: expense.payerID)
        _draftParticipantIDs = State(initialValue: expense.participantIDs)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(expense.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(PayhubColor.textPrimary)

                    Spacer()

                    Text(currencyFormatter.string(from: expense.amount))
                        .font(.headline.weight(.bold))
                        .monospacedDigit()
                        .foregroundStyle(PayhubColor.textPrimary)
                }

                Text("Paid by \(payerName)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(PayhubColor.textTertiary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                toggleExpanded()
            }

            if isExpanded {
                Divider()
                    .overlay(PayhubColor.borderSubtle)

                expandedContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
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
        .onChange(of: expense) { updatedExpense in
            if !hasChanges {
                syncDraft(with: updatedExpense)
            }
        }
        .confirmationDialog(
            pendingAction?.title ?? "",
            isPresented: Binding(
                get: { pendingAction != nil },
                set: { isPresented in
                    if !isPresented {
                        pendingAction = nil
                    }
                }
            ),
            titleVisibility: .visible
        ) {
            switch pendingAction {
            case .edit:
                Button("Confirm Edit") {
                    updateExpense(expense, draftTitle, draftAmount, draftPayerID, draftParticipantIDs)
                    syncDraft(with: Expense(
                        id: expense.id,
                        title: draftTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                        amount: parsedAmount ?? expense.amount,
                        payerID: draftPayerID ?? expense.payerID,
                        participantIDs: draftParticipantIDs
                    ))
                    pendingAction = nil
                }
            case .delete:
                Button("Confirm Delete", role: .destructive) {
                    removeExpense(expense)
                    pendingAction = nil
                }
            case .none:
                EmptyView()
            }

            Button("Cancel", role: .cancel) {
                pendingAction = nil
            }
        } message: {
            Text(pendingAction?.message(expenseTitle: expense.title) ?? "")
        }
    }

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            TextField("Expense title", text: $draftTitle)
                .textInputAutocapitalization(.words)
                .font(.body.weight(.medium))

            TextField("Amount", text: $draftAmount)
                .font(.body.weight(.medium))
                .keyboardType(.decimalPad)

            VStack(alignment: .leading, spacing: 10) {
                Text("Paid by")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(PayhubColor.textPrimary)

                ForEach(members) { member in
                    Button {
                        draftPayerID = member.id
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: draftPayerID == member.id ? "largecircle.fill.circle" : "circle")
                                .foregroundStyle(
                                    draftPayerID == member.id
                                        ? PayhubColor.brandPrimary
                                        : PayhubColor.textTertiary
                                )

                            Text(member.name)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(PayhubColor.textPrimary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Participants")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(PayhubColor.textPrimary)

                ForEach(members) { member in
                    Button {
                        toggleParticipant(member.id)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: draftParticipantIDs.contains(member.id) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(
                                    draftParticipantIDs.contains(member.id)
                                        ? PayhubColor.brandPrimary
                                        : PayhubColor.textTertiary
                                )

                            Text(member.name)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(PayhubColor.textPrimary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack(spacing: 10) {
                Button("Delete") {
                    pendingAction = .delete
                }
                .buttonStyle(.borderedProminent)
                .tint(PayhubColor.balanceNegative)

                Button("Edit") {
                    pendingAction = .edit
                }
                .buttonStyle(.borderedProminent)
                .tint(PayhubColor.brandPrimary)
                .disabled(!canConfirmEdit)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(PayhubColor.surfaceSecondary, in: RoundedRectangle(cornerRadius: 14))
    }

    private var hasChanges: Bool {
        draftExpense != expense
    }

    private var canConfirmEdit: Bool {
        hasChanges && parsedAmount != nil && draftPayerID != nil && !draftParticipantIDs.isEmpty
            && !draftTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var parsedAmount: Decimal? {
        let normalizedAmount = draftAmount.trimmingCharacters(in: .whitespacesAndNewlines)

        guard
            !normalizedAmount.contains(","),
            let amount = Decimal(string: normalizedAmount, locale: Locale(identifier: "en_US_POSIX")),
            amount > 0
        else {
            return nil
        }

        return amount
    }

    private var draftExpense: Expense {
        Expense(
            id: expense.id,
            title: draftTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: parsedAmount ?? expense.amount,
            payerID: draftPayerID ?? expense.payerID,
            participantIDs: draftParticipantIDs
        )
    }

    private func toggleParticipant(_ memberID: UUID) {
        if draftParticipantIDs.contains(memberID) {
            draftParticipantIDs.remove(memberID)
        } else {
            draftParticipantIDs.insert(memberID)
        }
    }

    private func syncDraft(with expense: Expense) {
        draftTitle = expense.title
        draftAmount = NSDecimalNumber(decimal: expense.amount).stringValue
        draftPayerID = expense.payerID
        draftParticipantIDs = expense.participantIDs
    }
}

private enum PendingAction {
    case edit
    case delete

    var title: String {
        switch self {
        case .edit:
            return "Confirm expense update"
        case .delete:
            return "Confirm expense deletion"
        }
    }

    func message(expenseTitle: String) -> String {
        switch self {
        case .edit:
            return "Apply the changes you made to \(expenseTitle)?"
        case .delete:
            return "Delete \(expenseTitle)? This action cannot be undone."
        }
    }
}
