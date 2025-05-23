//
//  NSPopover.swift
//  PopApp
//
//  Created by Lev on 10.01.25.
//


import AppKit
import SwiftUI
import KeyboardShortcuts

extension NSPopover.Behavior {
    var intValue: Int {
        get {
            switch self {
            case .applicationDefined: return 0
            case .transient: return 1
            case .semitransient: return 2
            @unknown default: return -1 // Handle potential future cases
            }
        }
        set {
            switch newValue {
            case 0: self = .applicationDefined
            case 1: self = .transient
            case 2: self = .semitransient
            default: self = .applicationDefined // Or handle this case as needed
            }
        }
    }
    
    init?(intValue: Int) {
        switch intValue {
        case 0: self = .applicationDefined
        case 1: self = .transient
        case 2: self = .semitransient
        default: return nil
        }
    }
}