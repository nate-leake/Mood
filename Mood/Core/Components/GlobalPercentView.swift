//
//  GlobalPercentView.swift
//  Mood
//
//  Created by Nate Leake on 9/21/23.
//

import SwiftUI

struct GlobalPercentView: View {
    var context: String
    var percent: Int
    var mood: Mood
    var emotion: Emotion
    
    private var gradient: LinearGradient
    
    init(context: String, percent: Int, mood: Mood, emotion: Emotion) {
        self.context = context
        self.percent = percent
        self.mood = mood
        self.emotion = emotion
        
        let stops = [
            Gradient.Stop(color: mood.getColor(), location: CGFloat(percent)/100),
            Gradient.Stop(color: mood.getColor().opacity(0.5), location: CGFloat(percent)/100)
        ]
        
        self.gradient = LinearGradient(stops: stops, startPoint: .leading, endPoint: .trailing)
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(context)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            ZStack{
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(gradient)
                    .frame(height: 70)
                    .padding(.horizontal, 20)
                
                VStack{
                    Text("\(percent)%")
                        .foregroundStyle(.appBlack.opacity(0.7))
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(emotion.name)")
                        .foregroundStyle(.appBlack.opacity(0.7))
                        .font(.subheadline)
                }
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    GlobalPercentView(context: "family", percent: 62, mood: Mood.allMoods[0], emotion: Mood.allMoods[0].emotions[0])
}
