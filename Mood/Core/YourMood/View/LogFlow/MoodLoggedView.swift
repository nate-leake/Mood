//
//  MoodLoggedView.swift
//  Mood
//
//  Created by Nate Leake on 10/10/23.
//

import SwiftUI

struct MoodLoggedView: View {
    @EnvironmentObject var viewModel: UploadMoodViewModel
    @Binding var isPresented: Bool
    
    @State private var play0 = false
    @State private var play1 = false
    @State private var play2 = false
    
    @State private var slideUp = false
    @State private var appear = false
    
    @State var globeColors: [Color] = [.appGreen, .appGreen, .appGreen]
    
    @State var uploaded:Bool = false
    
    func getHighestIntesityMoods() -> [Color]{
        var top3:[Color] = []
        var emotionWeights: [String: Int] = [:]
        
        for pair in viewModel.dailyData.pairs {
            if let mood = Emotion(name: pair.emotions[0]).getParentMood(){
                if emotionWeights[mood.name] == nil{
                    emotionWeights[mood.name] = pair.weight.rawValue
                } else {
                    emotionWeights[mood.name]! += pair.weight.rawValue
                }
            }
        }
        
        let sortedTotals = emotionWeights.sorted{$0.1 > $1.1}
        print(sortedTotals)
        
        for kv in sortedTotals {
            if top3.count < 3 {
                top3.append(Color(kv.key))
            } else {
                break
            }
        }
        
        if top3.count == 1 {
            top3.append(top3[0])
            top3.append(top3[0])
        } else if top3.count == 2 {
            top3.append(top3[1])
            top3[1] = top3[0]
        }
        
        print(top3)
        return top3
    }
    
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
                        .foregroundStyle(self.globeColors[0])
                        .symbolEffect(.bounce.up, value: play0)
                    Image(systemName: "globe.europe.africa.fill")
                        .foregroundStyle(self.globeColors[1])
                        .symbolEffect(.bounce.up, value: play1)
                    Image(systemName: "globe.asia.australia.fill")
                        .foregroundStyle(self.globeColors[2])
                        .symbolEffect(.bounce.up, value: play2)
                }
                .font(.title)
                .onAppear{self.globeColors = getHighestIntesityMoods()}
                
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
            
            Task {
                uploaded = try await DailyDataService.shared.uploadMood(dailyData:viewModel.dailyData)
                if uploaded {
                    DailyDataService.shared.userHasLoggedToday = true
                } else {
                    print("Something went wrong uploading mood post!")
                }
            }
            
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
            
            _ = Timer.scheduledTimer(withTimeInterval: 4.5, repeats: false) { (closeTimer) in
                self.isPresented = false
            }
        }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    
    return MoodLoggedView(isPresented: $isPresented)
}
