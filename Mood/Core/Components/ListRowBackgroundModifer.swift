//
//  ListRowBackgroundModifer.swift
//  Mood
//
//  Created by Nate Leake on 9/28/23.
//

import Foundation
import SwiftUI

struct ListRowBackgroundModifer: ViewModifier {
    private var backgroundColor: Color
    
    init(foregroundColor: Color = Color(.appPurple).opacity(0.15)) {
        self.backgroundColor = foregroundColor
    }
    
    func body(content: Content) -> some View {
        content
            .listRowBackground(backgroundColor)
            
    }
}
