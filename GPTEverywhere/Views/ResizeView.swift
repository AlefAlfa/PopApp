//
//  ResizeView.swift
//  PopApp
//
//  Created by Lev on 03.03.24.
//

import SwiftUI
import AppKit

struct ResizeView: View {
    @Binding var width: Float
    @Binding var height: Float
    var screenHeight = Float(NSScreen.main?.frame.height ?? 800)
    var screenWidth = Float(NSScreen.main?.frame.width ?? 1600)
    
    private var hHandle: some Gesture {
        DragGesture()
            .onChanged { gesture in
                changeWidth(translation: gesture.translation)
            }
    }
    
    private var vHandle: some Gesture {
        DragGesture()
            .onChanged { gesture in
                changeHeight(translation: gesture.translation)
            }
    }
    
    private var allHandle: some Gesture {
        DragGesture()
            .onChanged { gesture in
                changeWidthAndHeight(translation: gesture.translation)
            }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Rectangle()
                    .foregroundColor(.black.opacity(0.00000001))
                    .frame(width: 20, height: CGFloat(height))
                    .gesture(hHandle)
                
                Spacer()
            }
            
            
            VStack {
                Spacer()
                Rectangle()
                    .foregroundColor(.black.opacity(0.00000001))
                    .frame(width: CGFloat(width), height: 20)
                    .gesture(vHandle)
            }
            
            VStack {
                Spacer()
                HStack {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.00000001))
                        .frame(width: 40, height: 40)
                        .gesture(allHandle)
                    Spacer()
                }
            }
        }
    }
    
    private func changeWidth(translation:  CGSize) {
        let horizontalChange = translation.width
        let newWidth = self.width - Float(horizontalChange)
        if newWidth > 0 && newWidth < screenWidth - 25 {
            self.width = newWidth
        }
        fix()
    }
    
    private func changeHeight(translation: CGSize) {
        let verticalChange = translation.height
        let newHeight = height + Float(verticalChange)
        if newHeight > 0 && newHeight < screenHeight - 50 {
            height = newHeight
        }
        fix()
    }
    
    private func changeWidthAndHeight(translation: CGSize) {
        changeWidth(translation: translation)
        changeHeight(translation: translation)
        fix()
    }
    
    private func fix() {
        if height > (screenHeight - 50) || width > (screenWidth - 25) {
            height = screenHeight - 50
            width = screenWidth - 25
        }
    }
}


#Preview {
    ResizeView(width: .constant(200), height: .constant(300))
}
