//
//  GPTEverywhereApp.swift
//  GPTEverywhere
//
//  Created by Lev on 08.02.24.
//

import SwiftUI
import KeyboardShortcuts
import AppKit
import WebKit

@main
struct GPTEverywhereApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var popupToggler = PopupToggler()
    
    var body: some Scene {
        WindowGroup("Tutorial", id: "Tutorial") {
            WebView("sites.google.com/view/thepopapp/home", webView: WKWebView(frame: .zero))
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
        }
        Settings {
            SettingsView()
        }
    }   
}



