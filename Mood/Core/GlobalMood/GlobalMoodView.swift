//
//  GlobalMoodView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI

struct GlobalMoodView: View {
    var body: some View {
        NavigationStack {
            ScrollView{
                Text("this is how people feel today")
                Spacer()
                
                VStack{
                    
                    GlobalPercentView(context: "family", color: .happiness, percent: 92)
                    GlobalPercentView(context: "health", color: .anger, percent: 85)
                    GlobalPercentView(context: "identity", color: .neutrality, percent: 64)
                    GlobalPercentView(context: "money", color: .fearful, percent: 51)
                    GlobalPercentView(context: "politics", color: .sadness, percent: 31)
                    GlobalPercentView(context: "weather", color: .neutrality, percent: 29)
                    GlobalPercentView(context: "work", color: .happiness, percent: 14)
                    
                }
                Spacer()
                
                    
            }
            
            .navigationTitle("Global mood")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GlobalMoodView()
}
