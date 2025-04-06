//
//  ObjectivesBuilder.swift
//  Mood
//
//  Created by Nate Leake on 4/5/25.
//

import SwiftUI

struct ObjectivesBuilderView: View {
    @EnvironmentObject var dataService: DataService
    @State var givenTitle: String = ""
    @State var givenDescription: String = ""
    @State var givenColor: Color = .appGreen
    @State var isNamed: Bool = false
    @State var hasDescrption: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            ObjectiveTileView(label: givenTitle == "" ? "give it a title" : givenTitle, color: givenColor)
            
            TextField("title", text: $givenTitle)
                .padding(12)
                .background(.appPurple.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading, 24)
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
                .padding(.leading, 24)
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
    ObjectivesBuilderView()
        .environmentObject(DataService())
}
