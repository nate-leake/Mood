//
//  MoodLoggedView.swift
//  Mood
//
//  Created by Nate Leake on 10/10/23.
//

import SwiftUI

struct MoodLoggedView: View {
    @EnvironmentObject var viewModel: UploadMoodViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var play0 = false
    @State private var play1 = false
    @State private var play2 = false
    
    @State private var slideUp = false
    @State private var appear = false
    
    @State var globeColors: [Color] = [.appBlack, .appBlack, .appBlack]
    
    @State var uploaded:Bool = false
    
    func setGlobeColors(){
        var emotionWeights: [String: Int] = [:]
        
        for contextContainer in viewModel.contextLogContainers {
            for moodContainer in contextContainer.moodContainers {
                if emotionWeights[moodContainer.moodName] == nil{
                    emotionWeights[moodContainer.moodName] = moodContainer.weight.rawValue
                } else {
                    emotionWeights[moodContainer.moodName]! += moodContainer.weight.rawValue
                }
            }
        }
        let sortedTotals = emotionWeights.sorted{$0.1 > $1.1}
        
        for (index, element) in sortedTotals.enumerated() {
            if index <= 2 {
                globeColors[index] = Color(element.key)
            }
        }
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
                .onAppear{
                    setGlobeColors()
                }
                
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
        .navigationBarBackButtonHidden(true)
        .onAppear{
            
            Task {
                uploaded = try await viewModel.uploadMoodPost()
                if uploaded {
                    print("upload successful!")
                } else {
                    print("Something went wrong uploading mood post!")
                }
            }
            
            // These timers are carefully coordinated with the ContextTileView dismissal screen
            // If these values change, the ContexTileView dismissal delay should be re evaluated
            
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
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = UploadMoodViewModel()
    
    return MoodLoggedView()
        .environmentObject(UploadMoodViewModel())
}
