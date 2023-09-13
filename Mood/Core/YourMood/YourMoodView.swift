//
//  YourMoodView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI

struct YourMoodView: View {
    var AU = AnalyticsGenerator()
    private let adaptiveRows = [
        GridItem(.adaptive(minimum: 140))
    ]
    private let numberRows = [
        GridItem(.flexible())
    ]
    
    let randCols: [Color] = [.sadness, .happiness, .anger, .fearful, .neutrality]
    
    
    var body: some View {
        NavigationStack {
            HStack{
                LazyHGrid(rows: adaptiveRows) {
                    TileView(header: "Biggest impacts in 30 days", headerColor: .appPurple, borderColor: .appPurple,
                    content: AnyView(
                        HStack{
                            ForEach(AU.biggestImpact(), id: \.self){
                                Text("\($0)".capitalized)
                                    .foregroundStyle(randCols.randomElement()!)
                                    .font(.headline)
                            }
                        }
                     )
                    )
                    
                    TileView(header: "Biggest emotions in 30 days", headerColor: .appGreen, borderColor: .appGreen,
                             content: AnyView(
                                HStack{
                                    ForEach(AU.biggestEmotions(), id: \.self){
                                        Text("\($0)".capitalized)
                                            .foregroundStyle(randCols.randomElement()!)
                                            .font(.headline)
                                    }
                                }
                             )
                    )
                }
                
                .padding(.horizontal, 20)
                
            }
            .navigationTitle("Your moods")
            .navigationBarTitleDisplayMode(.inline)
            
            Spacer()
        }
    }
}

#Preview {
    YourMoodView()
}
