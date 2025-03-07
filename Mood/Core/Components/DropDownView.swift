//
//  DropDownView.swift
//  Mood
//
//  Created by Nate Leake on 9/5/24.
//

import SwiftUI

struct DropDownView: View {
    let title: String
    let prompt: String
    let options: [String]
    
    @State private var isExpanded = false
    
    @Binding var selection: String?
    
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.footnote)
                .foregroundStyle(.gray)
                .opacity(0.8)
            
            ZStack(alignment: .top) {
                // Expandable Area
                VStack(spacing:0) {
                    // Main selection area
                    HStack {
                        Text(selection ?? prompt)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .rotationEffect(.degrees(isExpanded ? -180 : 0))
                        
                    }
                    .background(scheme == .dark ? .black : .white)
                    .frame(height: 40)
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            isExpanded.toggle()
                        }
                    }
                    
                    if isExpanded {
                        VStack {
                            ForEach(options, id: \.self) { option in
                                HStack {
                                    Text(option)
                                        .foregroundStyle(selection == option ? Color.primary : .gray)
                                    
                                    Spacer()
                                    
                                    if selection == option{
                                        Image(systemName: "checkmark")
                                            .font(.subheadline)
                                    }
                                    
                                }
                                .frame(height: 40)
                                .padding(.horizontal)
                                .onTapGesture {
                                    selection = option
                                    withAnimation(.snappy){
                                        isExpanded.toggle()
                                    }
                                }
                            }
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
                .background(scheme == .dark ? .black : .white)
                .clipShape( RoundedRectangle(cornerRadius: 10))
                .shadow(color: .primary.opacity(0.2), radius: 4)
            }
            
        }
    }
}

#Preview {
    DropDownView(title: "context", prompt: "select", options: ["family", "weather"], selection: .constant("weather"))
}
