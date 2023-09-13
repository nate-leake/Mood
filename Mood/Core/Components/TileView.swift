//
//  TileView.swift
//  Mood
//
//  Created by Nate Leake on 9/13/23.
//

import SwiftUI

struct TileView: View {
    var header: String
    var headerColor: Color
    var borderColor: Color
    
    @ViewBuilder
    var content: AnyView
    
    init(header: String, headerColor: Color, borderColor: Color, content: AnyView) {
        self.header = header
        self.headerColor = headerColor
        self.borderColor = borderColor
        self.content = content
    }
    
    var body: some View {
        
        VStack{
            Text(header)
                .foregroundStyle(headerColor)
                .padding(.bottom, 5)
                .font(.title3)
                .bold()
            Spacer()
            content
            Spacer()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 100)
        .padding(.vertical)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.clear)
                .stroke(borderColor, lineWidth: 2)
        )
    }
}

#Preview {
    
    TileView(header: "Biggest impacts in 30 days", headerColor: Color(.appPurple) , borderColor: Color(.appPurple),
             content: AnyView(
                HStack{
                    ForEach(AnalyticsGenerator().biggestEmotions(), id: \.self){
                        Text("\($0)".capitalized)
                            .foregroundStyle([.sadness, .happiness, .anger, .fearful, .neutrality].randomElement()!)
                            .font(.headline)
                    }
                }
             )
    )
    
}
