//
//  Constants.swift
//  GPTEverywhere
//
//  Created by Lev on 10.02.24.
//


import AppKit
import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    
    static let openMenuBarView = Self("openMenuBarView", default: .init(.s, modifiers: [.option]))
    static let openTab_0 = Self("openTab_0", default: .init(.one, modifiers: [.option]))
    static let openTab_1 = Self("openTab_1", default: .init(.two, modifiers: [.option]))
    static let openTab_2 = Self("openTab_2", default: .init(.three, modifiers: [.option]))
    static let openTab_3 = Self("openTab_3", default: .init(.four, modifiers: [.option]))
    static let openPreviousTab = Self("openPreviousTab", default: .init(.a, modifiers: [.option]))
    
}


