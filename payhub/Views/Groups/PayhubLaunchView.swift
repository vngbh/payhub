//
//  PayhubLaunchView.swift
//  payhub
//

import SwiftUI

struct PayhubLaunchView<Content: View>: View {
    @State private var showLogo = false
    @State private var showContent = false
    @State private var overlayOpacity = 1.0

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            PayhubColor.appBackground.ignoresSafeArea()

            if showContent {
                content
            }

            if overlayOpacity > 0 {
                launchOverlay
                    .opacity(overlayOpacity)
            }
        }
        .onAppear(perform: startLaunchSequence)
    }

    private var launchOverlay: some View {
        ZStack {
            LinearGradient(
                colors: [
                    PayhubColor.heroWash,
                    PayhubColor.brandSoft.opacity(0.72),
                    PayhubColor.heroHighlight.opacity(0.46)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Image("PayhubLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 138, height: 138)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: PayhubColor.brandPrimary.opacity(0.22), radius: 18, x: 0, y: 12)

                VStack(spacing: 6) {
                    Text("payhub")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(PayhubColor.textPrimary)

                    Text("Split cleanly. Settle calmly.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(PayhubColor.brandPrimary)
                }
            }
            .offset(y: -34)
            .opacity(showLogo ? 1 : 0)
            .scaleEffect(showLogo ? 1 : 0.94)
            .animation(.easeInOut(duration: 0.8), value: showLogo)
        }
    }

    private func startLaunchSequence() {
        withAnimation(.easeOut(duration: 0.8)) {
            showLogo = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            showContent = true

            withAnimation(.easeInOut(duration: 0.7)) {
                overlayOpacity = 0
            }
        }
    }
}

#Preview {
    PayhubLaunchView {
        GroupSplitView()
    }
}
