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
    
    init(foregroundColor: Color = Color.black) {
        self.foregroundColor = foregroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            .foregroundStyle(foregroundColor)
            
    }
}
