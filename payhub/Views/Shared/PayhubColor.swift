//
//  PayhubColor.swift
//  payhub
//

import SwiftUI

enum PayhubColor {
    // Surfaces & Backgrounds
    static let appBackground     = Color(red: 244 / 255, green: 246 / 255, blue: 251 / 255) // #F4F6FB
    static let surfacePrimary    = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let surfaceSecondary  = Color(red: 244 / 255, green: 246 / 255, blue: 251 / 255) // #F4F6FB
    static let borderSubtle      = Color(red: 235 / 255, green: 235 / 255, blue: 240 / 255) // #EBEBF0

    // Brand — Blue accent system
    static let bluePrimary       = Color(red: 26 / 255, green: 107 / 255, blue: 240 / 255)  // #1A6BF0
    static let blueDeep          = Color(red: 10 / 255, green: 46 / 255,  blue: 138 / 255)  // #0A2E8A
    static let dark              = Color(red: 28 / 255, green: 28 / 255,  blue: 46 / 255)   // #1C1C2E — CTA bg, active tab, pill

    // Legacy brand (teal) — used for logo gradient & shadows
    static let brandPrimary      = Color(red: 38 / 255, green: 117 / 255, blue: 104 / 255)  // #267568
    static let brandBright       = Color(red: 68 / 255, green: 164 / 255, blue: 140 / 255)  // #44A48C
    static let brandSoft         = Color(red: 167 / 255, green: 233 / 255, blue: 211 / 255) // #A7E9D3
    static let focusAccent       = Color(red: 30 / 255, green: 174 / 255, blue: 219 / 255)  // #1EAEDB

    // Text
    static let iconSurface       = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let textPrimary       = Color(red: 28 / 255, green: 28 / 255,  blue: 46 / 255)   // #1C1C2E
    static let textSecondary     = Color(red: 142 / 255, green: 142 / 255, blue: 154 / 255) // #8E8E9A
    static let textTertiary      = Color(red: 132 / 255, green: 142 / 255, blue: 156 / 255) // #848E9C
    static let textOnAccent      = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)

    // Semantic — Finance
    static let balancePositive   = Color(red: 0 / 255,   green: 201 / 255, blue: 123 / 255) // #00C97B
    static let balanceNegative   = Color(red: 255 / 255, green: 59 / 255,  blue: 92 / 255)  // #FF3B5C
}
