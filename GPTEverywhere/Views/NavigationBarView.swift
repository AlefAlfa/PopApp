//
//  NavigationBarView.swift
//  GPTEverywhere
//
//  Created by Lev on 13.02.24.
//

import SwiftUI
import SettingsAccess

struct NavigationBarView: View {
    @StateObject var popup = PopupManager.shared
    @Environment(\.openSettings) private var openSettings
    @Binding var tab: Int
    @StateObject var websiteManager = WebsiteManager.shared
    let reloadDelay = 1.0
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                HStack(spacing: 5) {
                    Button {
                        websiteManager.websites[websiteManager.activeTab].goBack()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .buttonStyle(.plain)
                    .onHover { hover in
                        setCursor(hover: hover)
                    }
                    
                    Button {
                        websiteManager.websites[websiteManager.activeTab].goForward()
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .buttonStyle(.plain)
                    .onHover { hover in
                        setCursor(hover: hover)
                    }
                    
                    Button {
                        Task {
                            await reloadPage()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .buttonStyle(.plain)
                    .onHover { hover in
                        setCursor(hover: hover)
                    }
                }
                
                Spacer()
                
                Image(systemName: "gearshape")
                    .onTapGesture {
                        openSettingsInForground()
                    }
                    .onHover { hover in
                        setCursor(hover: hover)
                    }
                
                    .font(.system(size: 18, weight: .medium))
                    .padding(.horizontal, 2)
                
                
                
                Image(systemName: "xmark.circle")
                    .font(.system(size: 18, weight: .medium))
                    .onTapGesture {
                        AppDelegate.shared?.togglePopup()
                    }
                    .onHover { hover in
                        setCursor(hover: hover)
                    }
            }
            .padding(.top, 7)
            .padding(.bottom, 1)
            .padding(.horizontal, 7)
            .offset(y: -2)
            .background(Color(NSColor.controlBackgroundColor))
            
            
            
            VStack {
                Picker(selection: $tab) {
                    ForEach(websiteManager.tabs.indices, id: \.self) { index in
                        Text("⌥\(index + 1)")
                    }
                } label: {
                    
                }
                .pickerStyle(.segmented)
                .opacity(websiteManager.tabs.count < 2 ? 0 : 1)
            }
            .frame(width: (NSScreen.main?.frame.width ?? 1) / 6.0)
        }
    }
    
    func setCursor(hover: Bool) {
        if hover {
            NSCursor.pointingHand.set()
        } else {
            NSCursor.arrow.set()
        }
    }
    
    func openSettingsInForground() {
        try? openSettings()
        popup.refreshNeeded = true
    }
    
    func reloadPage() async {
        let activeTab = websiteManager.activeTab
        
        if websiteManager.tabs.isEmpty {
            return
        }
        
        let tmpUrl = websiteManager.tabs[activeTab].urlString
        
        websiteManager.deleteTab(id: websiteManager.tabs[activeTab].id)
        let _ = await websiteManager.addUrl(urlString: tmpUrl)
        
        websiteManager.isLoading.toggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + reloadDelay) {
            websiteManager.tabs.removeLast()
            websiteManager.tabs.insert(Tab(urlString: tmpUrl), at: activeTab)
            websiteManager.isLoading.toggle()
            websiteManager.saveTabs()
        }
        
        
        
    }
}

#Preview {
    NavigationBarView(tab: .constant(0))
}
