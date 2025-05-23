//
//  WebsitesSettingsView.swift
//  PopupGPT
//
//  Created by Lev on 22.02.24.
//

import SwiftUI
import KeyboardShortcuts
import Foundation

@MainActor
struct WebsitesSettingsView: View {
    @StateObject var websiteManager = WebsiteManager.shared
    @State var message: String? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("Tabs:")
                        .bold()
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.top, 7)
                .padding(.bottom, 7)

                
                List($websiteManager.tabs, id: \.self, editActions: .move) { $tab in
                    HStack {
                        Text(tab.urlString)
                            .lineLimit(1)
                        Spacer()
                        Button {
                            websiteManager.deleteTab(id: tab.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                        .padding(.leading)
                        .buttonStyle(.plain)
                        
                    }
                    .padding(.top, websiteManager.tabs.firstIndex(of: tab) == 0 ? -7: 3)
                    .padding(.bottom, 3)
                    
                }
                .scrollDisabled(true)
                .clipShape(.rect(cornerRadius: 5))
                .frame(height: CGFloat(32 * Double(websiteManager.tabs.count)))
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            Spacer()
            
            
            VStack(spacing: 5){
                if let message = message {
                    Text(message)
                        .multilineTextAlignment(.leading)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .offset(x: -20)
                        .task {
                            withAnimation(.linear.delay(5)) {
                                self.message = nil
                            }
                        }
                    
                }
                
                HStack {
                    VStack(spacing: 0) {
                        TextField("www.example.com", text: $websiteManager.textField)
                            .padding(6)
                            .textFieldStyle(.plain)
                            .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color(NSColor.controlBackgroundColor))
                            )
                            .onSubmit {
                                Task {
                                    await addWebsite()
                                }
                            }
                    }
                    
                    Button("add") {
                        Task {
                            await addWebsite()
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(6)
                    .padding(.horizontal, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(websiteManager.textField.isValidURL ? Color.blue : Color(NSColor.controlBackgroundColor))
                        )
                    .foregroundStyle(websiteManager.textField.isValidURL ? Color.white : Color(NSColor.controlTextColor))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
    
    func addWebsite() async {
        await message = websiteManager.addUrl(urlString: nil)
    }
    
    func setCursor(hover: Bool) {
        if hover {
            NSCursor.pointingHand.set()
        } else {
            NSCursor.arrow.set()
        }
    }
}


#Preview {
    WebsitesSettingsView()
        .frame(width: 400)
}


