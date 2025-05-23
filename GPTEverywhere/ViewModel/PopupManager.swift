//
//  Settings.swift
//  GPTEverywhere
//
//  Created by Lev on 10.02.24.
//

import Foundation
import AppKit
import KeyboardShortcuts

class PopupManager: ObservableObject {
    private var userDefaults = UserDefaults.standard
    static var shared: PopupManager = PopupManager()
    weak var delegate: PopupDelegate?
    var refreshNeeded = false

    @Published var width: Float {
        didSet { setWidth(width) }
    }
    
    @Published var height: Float {
        didSet { setHeight(height) }
    }

    
    private init() {
        self.height = userDefaults.float(forKey: "height")
        self.width = userDefaults.float(forKey: "width")
        
        if width == 0.0 {
            width = 600
        }
        if height == 0.0 {
            height = 700
        }
    }
    
    func setWidth(_ width: Float) {
        userDefaults.set(width, forKey: "width")
        delegate?.didUpdateWidth(to: width)
        if refreshNeeded {
            refreshPopup()
            refreshNeeded = false
        }
    }
    
    func setHeight(_ height: Float) {
        userDefaults.set(height, forKey: "height")
        delegate?.didUpdateHeight(to: height)
        if refreshNeeded {
            refreshPopup()
            refreshNeeded = false
        }
    }
    
    func refreshPopup() {
        self.delegate?.refreshPopup()
    }
}
