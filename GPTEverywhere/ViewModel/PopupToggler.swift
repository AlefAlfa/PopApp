//
//  PopupToggler.swift
//  GPTEverywhere
//
//  Created by Lev on 16.02.24.
//

import Foundation
import KeyboardShortcuts
import SwiftUI

@MainActor
class PopupToggler: ObservableObject {
    @Published var websiteManager = WebsiteManager.shared
    
    
    init() {
        KeyboardShortcuts.onKeyUp(for: .openMenuBarView) { [self] in
            AppDelegate.shared?.togglePopup()
        }
        KeyboardShortcuts.onKeyUp(for: .openTab_0) { [self] in
            websiteManager.setTab(0)
        }
        KeyboardShortcuts.onKeyUp(for: .openTab_1) { [self] in
            websiteManager.setTab(1)
        }
        KeyboardShortcuts.onKeyUp(for: .openTab_2) { [self] in
            websiteManager.setTab(2)
        }
        KeyboardShortcuts.onKeyUp(for: .openTab_3) { [self] in
            websiteManager.setTab(3)
        }
        KeyboardShortcuts.onKeyUp(for: .openPreviousTab) { [self] in
            if websiteManager.activeTab != websiteManager.previousTab {
                websiteManager.setTab(websiteManager.previousTab)
            }
        }
    }
}

