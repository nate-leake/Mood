//
//  MoodLoggedView.swift
//  Mood
//
//  Created by Nate Leake on 10/10/23.
//

import SwiftUI

struct MoodLoggedView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var play0 = false
    @State private var play1 = false
    @State private var play2 = false
    
    @State private var slideUp = false
    @State private var appear = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 10){
                if slideUp {
                    Spacer()
                }
                
                Text("mood logged")
                    .font(.title)
                
                HStack{
                    Image(systemName: "globe.americas.fill")
                        .foregroundStyle(.appGreen)
                        .symbolEffect(.bounce.up, value: play0)
                    Image(systemName: "globe.europe.africa.fill")
                        .foregroundStyle(.appGreen)
                        .symbolEffect(.bounce.up, value: play1)
                    Image(systemName: "globe.asia.australia.fill")
                        .foregroundStyle(.appGreen)
                        .symbolEffect(.bounce.up, value: play2)
                }
                .font(.title)
                
                if slideUp {
                    Spacer()
                    Spacer()
                }
            }
            
            ZStack{
                if appear {
                    Text("thank you for sharing")
                }
            }
            
        }
        .transition(.slide)
        .onAppear{
            
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer0) in
                self.play0.toggle()
            }
            
            _ = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { (timer1) in
                self.play1.toggle()
            }
            
            _ = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { (timer2) in
                self.play2.toggle()
            }
            
            _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (animationSlideUpTimer) in
                withAnimation(.easeInOut(duration: 2)) {
                    self.slideUp = true
                }
            }
            
            _ = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { (animationFadeInTimer) in
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.appear = true
                }
            }
            
            _ = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { (closeTimer) in
                self.dismiss()
            }
        }
    }
}

#Preview {
    MoodLoggedView()
}
