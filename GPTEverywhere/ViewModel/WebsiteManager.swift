//
//  WebsiteManager.swift
//  PopupGPT
//
//  Created by Lev on 25.02.24.
//

import Foundation
import SwiftUI
import WebKit

@MainActor
class WebsiteManager: ObservableObject {
    @Published var textField: String = ""
    @Published var tabs: [Tab] = []
    @Published var websites: [WKWebView] = []
    @Published var previousTab = 0
    @Published var isLoading = false
    @Published var activeTab = 0 {
        willSet(newActiveTab) {
            previousTab = activeTab
        }
    }
    
    private let userDefaults = UserDefaults.standard
    static var shared = WebsiteManager()
    
    private init() {
        loadTabs()
    }
    
    enum URLMessage {
        case toMany
        case notValid
        
        var message: String {
            switch self {
            case .toMany:
                return "You can have a maximum of 4 tabs"
            case .notValid:
                return "Please enter a valid url"
            }
        }
    }
    
    func deleteTab(id: String) {
        if let index = tabs.firstIndex(where: { $0.id == id }) {
            tabs.remove(at: index)
            websites.remove(at: index)
            saveTabs()
        }
    }
    
    func setTab(_ tab: Int) {
        if tab < tabs.count {
            if activeTab == tab {
                AppDelegate.shared?.togglePopup()
            } else if let isOpen = AppDelegate.shared?.isPopupOpen, let spaceChanged = AppDelegate.shared?.hasSpaceChanged {
                if !isOpen || spaceChanged {
                    AppDelegate.shared?.togglePopup()
                }
            }
            activeTab = tab
        }
        
    }
    
    func addUrl(urlString: String?) async -> String? {
        
        guard tabs.count < 4 else {
            return URLMessage.toMany.message
        }
        
        guard let (scheme, host, path) = textField.extractComponents() else {
            return URLMessage.notValid.message
        }
        
        if let urlString {
            addWebsite(urlString: urlString)
            return ""
        }
        
        if let url: URL = URL(string: "\(scheme)://\(host)\(path)") {
            do {
                let (_, response) = try await URLSession.shared.data(from: url)
                guard let _ = response as? HTTPURLResponse else {
                    let message = URLMessage.notValid.message
                    return message
                }
                if path.count < 2 {
                    addWebsite(urlString: "\(host)")
                } else {
                    addWebsite(urlString: "\(host)\(path)")
                }
                
                saveTabs()
                textField = ""
                
            } catch {
                let message = URLMessage.notValid.message
                return message
            }
        }
        return nil
    }
    
    private func addWebsite(urlString: String) {
        tabs.append(Tab(urlString: urlString))
        websites.append(createWKWebView())
    }
    
    private func loadTabs() {
        if let savedTabsData = userDefaults.object(forKey: "tabs") as? Data {
            let decoder = JSONDecoder()
            if let loadedTabs = try? decoder.decode([Tab].self, from: savedTabsData) {
                self.tabs = loadedTabs
            }
        } else {
            // Initial URLs if no tabs are saved
            let initialUrls = ["chat.openai.com", "perplexity.ai", "gemini.google.com"]
            self.tabs = initialUrls.map { Tab(urlString: $0) }
            saveTabs() // Save these initial tabs
        }
        tabs.forEach { _ in
            websites.append(createWKWebView())
        }
    }
    
    func saveTabs() {
        let encoder = JSONEncoder()
        if let encodedTabs = try? encoder.encode(tabs) {
            userDefaults.set(encodedTabs, forKey: "tabs")
        }
    }
    
    func createWKWebView() -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        return webView
    }
}
