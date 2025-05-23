//
//  AppDelegate.swift
//  GPTEverywhere
//
//  Created by Lev on 16.02.24.
//

import Foundation
import AppKit
import SwiftUI
import KeyboardShortcuts

protocol PopupDelegate: AnyObject {
    func didUpdateWidth(to width: Float)
    func didUpdateHeight(to height: Float)
    func refreshPopup()
}

class AppDelegate: NSObject, NSApplicationDelegate, PopupDelegate {
    @AppStorage("firstTimeOpeningApp") var firstTimeOpeningApp = true
    static var shared: AppDelegate?
    var popupManager = PopupManager.shared
    
    var isPopupOpen = false
    var hasSpaceChanged = false
    var appearance = NSAppearance(named: .darkAqua)
    
    private var statusItem: NSStatusItem!
    private var popup: NSPopover!
    
    override init() {
        popup = NSPopover()
    }
    
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {
        
        if let window = NSApplication.shared.windows.first {
            if firstTimeOpeningApp {
                firstTimeOpeningApp = false
                window.center()
            } else {
                window.close()
            }
        }
        
        setUpSpaceChangeObserver()

        AppDelegate.shared = self
        popupManager.delegate = self
        
        let menu = NSMenu()
        
        let toggle = toggleMenuItem()
        let quit = quitMenuItem()
        
        menu.addItem(toggle)
        menu.addItem(.separator())
        menu.addItem(quit)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        statusItem.menu = menu
        
        if let statusButton = statusItem.button {
            let symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 16, weight: .light)
            statusButton.image = NSImage(systemSymbolName: "note.text", accessibilityDescription: nil)?.withSymbolConfiguration(symbolConfiguration)
            statusButton.action = #selector(togglePopup)
            statusButton.image?.size = NSSize(width: 16, height: 16)
        }
        
        popup.contentSize = NSSize(width: Double(popupManager.width), height: Double(popupManager.height))
        popup.behavior = .semitransient
        popup.contentViewController = NSHostingController(rootView: ContentView())
        popup.animates = false
        popup.appearance = appearance
    }
    
    @objc func togglePopup() {
        if popup.isShown {
            if hasSpaceChanged {
                
                closePopup()
                openPopup()
                
                closePopup()
                openPopup()
                
                hasSpaceChanged = false
            } else {
                closePopup()
            }
        } else {
            openPopup()
            hasSpaceChanged = false
        }
    }
    
    @objc func openPopup() {
        if let button = statusItem.button {
            popup.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            isPopupOpen = true
            KeyboardShortcuts.enable(.openPreviousTab)
        }
    }
    
    @objc func closePopup() {
        if let _ = statusItem.button {
            popup.performClose(nil)
            isPopupOpen = false
            KeyboardShortcuts.disable(.openPreviousTab)
        }
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }
    
    @objc func spaceChange() {
        hasSpaceChanged = true
    }
    
    func didUpdateWidth(to width: Float) {
        popup.contentSize.width = CGFloat(width)
    }
    
    func didUpdateHeight(to height: Float) {
        popup.contentSize.height = CGFloat(height)
    }
    
    func didUpdateBehavior(to behavior: NSPopover.Behavior) {
        popup.behavior = behavior
    }
    
    func refreshPopup() {
        if isPopupOpen {
            closePopup()
            openPopup()
        }
    }
    
    func toggleMenuItem() -> NSMenuItem {
        let toggle = NSMenuItem()
        toggle.title = "Toggle Popup"
        toggle.setShortcut(for: .openMenuBarView)
        toggle.action = #selector(togglePopup)
        return toggle
    }
    
    func quitMenuItem() -> NSMenuItem {
        let quit = NSMenuItem()
        quit.title = "Quit"
        quit.keyEquivalent = "q"
        quit.action = #selector(quitApp)
        return quit
    }
    
    func setUpSpaceChangeObserver() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.spaceChange), name: NSWorkspace.activeSpaceDidChangeNotification, object: nil)
    }
    
//    func applicationWillTerminate(_ notification: Notification) {
//        UserDefaults.standard.removeObject(forKey: "tabs")
//        UserDefaults.standard.removeObject(forKey: "width")
//        UserDefaults.standard.removeObject(forKey: "firstTimeOpeningApp")
//    }
}



