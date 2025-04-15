//
//  ObjectivesBuilderView.swift
//  Mood
//
//  Created by Nate Leake on 4/5/25.
//

import SwiftUI

struct ObjectivesBuilderView: View {
    @Binding var givenTitle: String
    @Binding var givenDescription: String
    @Binding var givenColor: Color
    @Binding var isCompleted: Bool
    @Binding var isNamed: Bool
    @Binding var hasDescrption: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            ObjectiveTileView(label: givenTitle == "" ? "give it a title" : givenTitle, color: givenColor, isCompleted: isCompleted)
            
            TextField("title", text: $givenTitle)
                .padding(12)
                .background(.appPurple.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 24)
                .foregroundStyle(.appBlack)
            
                .textInputAutocapitalization(.never)
                .onChange(of: givenTitle) { old, new in
                    if new.count > 0 && old.count == 0 {
                        withAnimation(.easeInOut) {
                            isNamed = true
                        }
                    } else if new.count == 0 && old.count > 0 {
                        withAnimation(.easeInOut) {
                            isNamed = false
                        }
                    }
                }
            
            TextField("description", text: $givenDescription, axis: .vertical)
                .padding(12)
                .background(.appPurple.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 24)
                .foregroundStyle(.appBlack)
                .lineLimit(5...10)
                .textInputAutocapitalization(.never)
                .onChange(of: givenDescription) { old, new in
                    if new.count > 0 && old.count == 0 {
                        withAnimation(.easeInOut) {
                            hasDescrption = true
                        }
                    } else if new.count == 0 && old.count > 0 {
                        withAnimation(.easeInOut) {
                            hasDescrption = false
                        }
                    }
                }
            
            ColorPicker(
                "pick a color", selection: $givenColor, supportsOpacity: false
            )
            .padding(.horizontal, 24)
            .padding(.bottom)
            
            Spacer()
        }
        
    }
}

#Preview {
    @Previewable @State var givenTitle: String = ""
    @Previewable @State var givenDescription: String = ""
    @Previewable @State var givenColor: Color = .appGreen
    @Previewable @State var isCompleted: Bool = false
    @Previewable @State var isNamed: Bool = false
    @Previewable @State var hasDescrption: Bool = false
    ObjectivesBuilderView(givenTitle: $givenTitle, givenDescription: $givenDescription, givenColor: $givenColor, isCompleted: $isCompleted, isNamed: $isNamed, hasDescrption: $hasDescrption)
}
