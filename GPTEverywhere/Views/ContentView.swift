//
//  ContentView.swift
//  GPTEverywhere
//
//  Created by Lev on 08.02.24.
//

import SwiftUI
import SettingsAccess
import StoreKit

struct ContentView: View {
    @Environment(\.requestReview) private var requestReview
    @AppStorage("timesOpened") var timesOpened = 0
    @StateObject var popup = PopupManager.shared
    @StateObject var websiteManager = WebsiteManager.shared
    
    var body: some View {
        TabView(selection: $websiteManager.activeTab) {
            ForEach(websiteManager.tabs.enumeratedArray(), id: \.element) { index, tab in
                if websiteManager.isLoading {
                    ProgressView()
                } else {
                    WebView(tab.urlString, webView: websiteManager.websites[index]).tag(index)
                }
            }
        }
        .padding(.top, 5)
        .background(Color(NSColor.controlBackgroundColor))
        .overlay(alignment: .top) { NavigationBarView(tab: $websiteManager.activeTab) }
        .overlay(alignment: .center) { ResizeView(width: $popup.width, height: $popup.height) }
        .task {
            await requestReviewAfter200Uses()
            timesOpened += 1
        }
        .openSettingsAccess()
    }
    
    private func requestReviewAfter200Uses() async {
        if timesOpened % 200 == 0 {
            do {
                try await Task.sleep(for: .seconds(2))
            } catch {
                print(error)
            }
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
