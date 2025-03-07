//
//  BinidngExtension.swift
//  Mood
//
//  Created by Nate Leake on 3/2/25.
//

import Foundation
import SwiftUI

extension Binding {
    // Helper initializer for creating a Binding with a default value when the optional is nil
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}
