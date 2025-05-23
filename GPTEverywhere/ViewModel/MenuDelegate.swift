//
//  MenuDelegate.swift
//  GPTEverywhere
//
//  Created by Lev on 16.02.24.
//

import Foundation
import KeyboardShortcuts
import AppKit

class MenuDelegate: NSObject, NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        KeyboardShortcuts.disable([.openMenuBarView])
    }
    
    func menuDidClose(_ menu: NSMenu) {
        KeyboardShortcuts.enable([.openMenuBarView])
    }
}
