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
    
    @State private var appear = false
    
    @State var uploaded:Bool = false
        
    func getGreatestEmotionColor() -> Color{
        var emotionWeights: [String: Int] = ["anger":0]
        
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
        
        return Color(sortedTotals[0].key)
    }
    
    var body: some View {
        ZStack {
            LavaLampView(backgroundColor: getGreatestEmotionColor())
            
            ZStack {
                if !uploaded {
                    Text("uploading")
                        .transition(.move(edge: .bottom).combined(with: .blurReplace))
                    
                } else {
                    Text("mood logged")
                        .transition(.move(edge: .top).combined(with: .blurReplace))
                }
            }
            .font(.title)
            .foregroundStyle(getGreatestEmotionColor().darkModeVariant().mix(with: getGreatestEmotionColor().lightModeVariant(), by: 0.5).isLight() ? .black : .white)
            .opacity(0.7)
            .bold()
            
            Divider()
                .frame(width: 150)
                .background(getGreatestEmotionColor().darkModeVariant().mix(with: getGreatestEmotionColor().lightModeVariant(), by: 0.5).isLight() ? .black : .white)
                .offset(y: 20)
            
            Text("thank you for sharing")
                .foregroundStyle(getGreatestEmotionColor().darkModeVariant().mix(with: getGreatestEmotionColor().lightModeVariant(), by: 0.5).isLight() ? .black : .white)
                .opacity(appear ? 0.7 : 0)
                .offset(y: appear ? 35 : 20)
                .blur(radius: appear ? 0 : 5)
                .bold()
            
        }
        .transition(.slide)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            var uploadStatus : Bool = false
            Task {
                uploadStatus = try await viewModel.uploadMoodPost()
                if uploadStatus {
                    print("upload successful!")
                } else {
                    print("Something went wrong uploading mood post!")
                }
            }
            
            
            // These timers are carefully coordinated with the ContextTileView dismissal screen
            // If these values change, the ContexTileView dismissal delay should be re evaluated
            
            _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (successBufferTimer) in
                if uploadStatus != uploaded {
                    withAnimation(.bouncy(duration: 2)) {
                        self.uploaded = uploadStatus
                    }
                    _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (animationFadeInTimer) in
                        withAnimation(.bouncy(duration: 2)) {
                            self.appear = true
                        }
                    }
                    
                    _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (closeTimer) in
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = UploadMoodViewModel()
    
    return MoodLoggedView()
        .environmentObject(UploadMoodViewModel())
}
