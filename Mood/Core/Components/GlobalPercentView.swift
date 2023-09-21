//
//  GlobalPercentView.swift
//  Mood
//
//  Created by Nate Leake on 9/21/23.
//

import SwiftUI

struct GlobalPercentView: View {
    var context: String
    var color: Color
    var percent: Int
    
    
    
    private var gradient: LinearGradient
    
    init(context: String, color: Color, percent: Int) {
        self.context = context
        self.color = color
        self.percent = percent
        
        let stops = [
            Gradient.Stop(color: color, location: CGFloat(percent)/100),
            Gradient.Stop(color: color.opacity(0.5), location: CGFloat(percent)/100)
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
                
                Text("\(percent)%")
                    .foregroundStyle(.black.opacity(0.7))
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    GlobalPercentView(context: "family", color: .anger, percent: 50)
}
