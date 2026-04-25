//
//  ContentView.swift
//  payhub
//

import Inject
import SwiftUI

struct ContentView: View {
    @ObserveInjection var inject
    @StateObject private var viewModel = GroupSplitViewModel()

    var body: some View {
        PayhubLaunchView {
            RootView()
                .environmentObject(viewModel)
        }
        .enableInjection()
    }
}

// MARK: - Tab

enum AppTab: CaseIterable {
    case home, bills, balances, profile

    var label: String {
        switch self {
        case .home:     return "Home"
        case .bills:    return "Bills"
        case .balances: return "Balances"
        case .profile:  return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home:     return "house.fill"
        case .bills:    return "clock.fill"
        case .balances: return "chart.pie.fill"
        case .profile:  return "person.fill"
        }
    }
}

// MARK: - Root

struct RootView: View {
    @ObserveInjection var inject
    @EnvironmentObject var viewModel: GroupSplitViewModel
    @State private var selectedTab: AppTab = .home
    @State private var isAddingBill    = false
    @State private var isCalculating   = false
    @State private var isShowingMembers = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    GroupSplitView(
                        onAddBill:     { isAddingBill    = true },
                        onCalculate:   { isCalculating   = true },
                        onViewMembers: { isShowingMembers = true }
                    )
                case .bills:
                    BillsView(onAddBill: { isAddingBill = true })
                case .balances:
                    BalancesView()
                case .profile:
                    ProfilePlaceholderView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            BottomNavBar(selected: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $isAddingBill) {
            AddBillView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $isCalculating) {
            SettlementsView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $isShowingMembers) {
            MembersView()
                .environmentObject(viewModel)
        }
        .enableInjection()
    }
}

// MARK: - Bottom Nav

private struct BottomNavBar: View {
    @ObserveInjection var inject
    @Binding var selected: AppTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button { selected = tab } label: {
                    VStack(spacing: 4) {
                        ZStack(alignment: .bottom) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 22))
                                .foregroundStyle(selected == tab ? PayhubColor.dark : PayhubColor.textSecondary)
                                .frame(height: 26)

                            if selected == tab {
                                Circle()
                                    .fill(PayhubColor.balanceNegative)
                                    .frame(width: 4, height: 4)
                                    .offset(y: 6)
                            }
                        }
                        .frame(height: 32)

                        Text(tab.label)
                            .font(.system(size: 10, weight: selected == tab ? .bold : .medium))
                            .foregroundStyle(selected == tab ? PayhubColor.dark : PayhubColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
        }
        .background(PayhubColor.surfacePrimary)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(PayhubColor.borderSubtle)
                .frame(height: 1)
        }
        .padding(.bottom, 20)
        .enableInjection()
    }
}

// MARK: - Profile placeholder

private struct ProfilePlaceholderView: View {
    @ObserveInjection var inject

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.circle")
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(PayhubColor.textSecondary)
            Text("Profile")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(PayhubColor.textPrimary)
            Text("Coming soon")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(PayhubColor.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PayhubColor.appBackground)
        .enableInjection()
    }
}

#Preview {
    ContentView()
}
