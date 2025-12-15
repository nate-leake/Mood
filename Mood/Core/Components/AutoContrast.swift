//
//  AutoContrast.swift
//  Mood
//
//  Created by Nate Leake on 8/9/25.
//

import Foundation
import SwiftUI

private struct BackgroundWithContrastingForegroundModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let color: Color
    
    func body(content: Content) -> some View {
        
        return content
            .background(color)
            .foregroundStyle(color.optimalForegroundColor())
    }
}

extension View {
    func backgroundWithContrastingForeground(_ color: Color) -> some View {
        modifier(BackgroundWithContrastingForegroundModifier(color: color))
    }
}
