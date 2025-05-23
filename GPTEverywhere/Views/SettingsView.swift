//
//  SettingsView.swift
//  GPTEverywhere
//
//  Created by Lev on 09.02.24.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    let popup = PopupManager.shared
    var body: some View {
        TabView {
            WebsitesSettingsView()
                .tabItem {
                    Label {
                        Text("Tabs")
                    } icon: {
                        Image(systemName: "globe")
                    }
                    
                }
                .frame(width: 300, height: 250)

            
            MenuBarSettingsView()
                .tabItem {
                    Label {
                        Text("Popup")
                    } icon: {
                        Image(systemName: "note.text")
                    }
                }
                .frame(width: 300, height: 170)

        }
        .openSettingsAccess()
        .onAppear {
            popup.refreshNeeded = true
            for window in NSApplication.shared.windows {
                if window.title != "Item-0" {
                    window.level = .floating
                }
            }
            popup.refreshPopup()
        }
        
    }
}

#Preview {
    SettingsView()
        .frame(width: 400)
}
