//
//  SecureInputView.swift
//  Mood
//
//  Created by Nate Leake on 10/2/23.
//

import Foundation
import SwiftUI

struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var prompt: Text
    private var title: String
    
    init(_ title: String, text: Binding<String>, prompt: Text) {
        self.title = title
        self._text = text
        self.prompt = prompt
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(title, text: $text, prompt: prompt)
                } else {
                    TextField(title, text: $text, prompt: prompt)
                }
            }
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding(.trailing, 32)

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
        
    }
}

#Preview {
    @State var text: String = ""
    
    return SecureInputView("", text: $text, prompt: Text("password").foregroundStyle(.gray))
}
