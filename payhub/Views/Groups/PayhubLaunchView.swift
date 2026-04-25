//
//  PayhubLaunchView.swift
//  payhub
//

import Inject
import SwiftUI

struct PayhubLaunchView<Content: View>: View {
    @ObserveInjection var inject
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
        .enableInjection()
    }

    private var launchOverlay: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 21/255, green: 101/255, blue: 216/255),
                    Color(red: 10/255, green: 36/255, blue: 99/255)
                ],
                startPoint: UnitPoint(x: 0.1, y: 0),
                endPoint: UnitPoint(x: 0.9, y: 1)
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.15))
                        .frame(width: 72, height: 72)
                    Image(systemName: "wallet.bifold.fill")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.white)
                }

                VStack(spacing: 8) {
                    Text("payhub")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundStyle(.white)

                    Text("Split cleanly. Settle calmly.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.72))
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
        Text("App")
    }
}
