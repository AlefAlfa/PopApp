//
//  Tab.swift
//  PopApp
//
//  Created by Lev on 19.03.24.
//

import Foundation

struct Tab: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let urlString: String
    
    init(urlString: String) {
        self.id = UUID().uuidString
        self.urlString = urlString
    }
}
