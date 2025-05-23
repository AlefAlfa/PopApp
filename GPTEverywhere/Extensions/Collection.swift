//
//  CollectionExtensions.swift
//  PopApp
//
//  Created by Lev on 10.01.25.
//


import AppKit
import SwiftUI
import KeyboardShortcuts

extension Collection {
  func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
    return Array(self.enumerated())
  }
}