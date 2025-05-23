//
//  StringExtensions.swift
//  PopApp
//
//  Created by Lev on 10.01.25.
//


import AppKit
import SwiftUI
import KeyboardShortcuts

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(location: 0, length: self.utf16.count)
        
        // First, use NSDataDetector to check for a URL.
        if let match = detector.firstMatch(in: self, options: [], range: range) {
            // It is a link if the match covers the whole string.
            return match.range.length == self.utf16.count
        } else {
            // If NSDataDetector doesn't recognize it, perform additional check for .ai domains.
            // This regex pattern checks for a basic structure of a URL ending with .ai
            let pattern = #"^(https?:\/\/)?([\w\-]+\.)+ai(\/\S*)?$"#
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let matches = regex.numberOfMatches(in: self, options: [], range: range)
                return matches > 0
            }
        }
        return false
    }
    
    func extractComponents() -> (String, String, String)? {
        let modifiedString = self.contains("://") ? self : "https://" + self
        
        guard let url = URL(string: modifiedString),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host,
              let scheme = components.scheme else {
            return nil
        }
        let path = components.path
        return (scheme, host, path)
    }
}
