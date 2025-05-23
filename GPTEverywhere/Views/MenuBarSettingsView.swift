//
//  MenuBarSettingsView.swift
//  GPTEverywhere
//
//  Created by Lev on 10.02.24.
//

import SwiftUI
import KeyboardShortcuts
import LaunchAtLogin

struct MenuBarSettingsView: View {
    var screenHeight = Float((NSScreen.main?.frame.height)!)
    @ObservedObject var popup = PopupManager.shared
    @Environment(\.openWindow) var openWindow
    var body: some View {
        
        VStack(spacing: 25) {
            
            Form {
                KeyboardShortcuts.Recorder("Toggle Popup:", name: .openMenuBarView)
                KeyboardShortcuts.Recorder("Previous Tab:", name: .openPreviousTab)
            }
            
            Form {
                LaunchAtLogin.Toggle()
            }
            
            Button("Open Tutorial") {
                openWindow(id: "Tutorial")
            }
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MenuBarSettingsView()
}
