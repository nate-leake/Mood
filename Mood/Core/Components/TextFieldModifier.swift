//
//  TextFieldModifier.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import Foundation
import SwiftUI

struct TextFieldModifier: ViewModifier {
    private var foregroundColor: Color
    private var backgroundColor: Color
    
    init(foregroundColor: Color = .appBlack, backgroundColor: Color = .appWhite) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            .foregroundStyle(foregroundColor)
            
    }
}
