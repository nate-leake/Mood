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
                    
                    GlobalPercentView(context: "family", 
                                      percent: Int.random(in: 1..<100),
                                      mood: Mood.allMoods[0],
                                      emotion: Mood.allMoods[0].emotions[0])
                    GlobalPercentView(context: "health",
                                      percent: Int.random(in: 1..<100),
                                      mood: Mood.allMoods[1],
                                      emotion: Mood.allMoods[1].emotions[0])
                    GlobalPercentView(context: "identity",
                                      percent: Int.random(in: 1..<100),
                                      mood: Mood.allMoods[2],
                                      emotion: Mood.allMoods[2].emotions[0])
                    GlobalPercentView(context: "money",
                                      percent: Int.random(in: 1..<100),
                                      mood: Mood.allMoods[3],
                                      emotion: Mood.allMoods[3].emotions[0])
                    GlobalPercentView(context: "politics",
                                      percent: Int.random(in: 1..<100),
                                      mood: Mood.allMoods[4],
                                      emotion: Mood.allMoods[4].emotions[0])
                    GlobalPercentView(context: "weather",
                                      percent: Int.random(in: 1..<100),
                                      mood: Mood.allMoods[1],
                                      emotion: Mood.allMoods[1].emotions[5])
                    GlobalPercentView(context: "work",
                                      percent: Int.random(in: 1..<100),
                                      mood: Mood.allMoods[0],
                                      emotion: Mood.allMoods[0].emotions[4])
                    
                }
                Spacer()
                
                    
            }
            
            .navigationTitle("global mood")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GlobalMoodView()
}
