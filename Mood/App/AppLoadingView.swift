//
//  AppLoadingView.swift
//  Mood
//
//  Created by Nate Leake on 9/9/24.
//

import SwiftUI

struct AppLoadingView: View {
    @Binding var isShowingTabView: Bool
    @StateObject var dailyDataService: DailyDataService = DailyDataService.shared
    @State var isAnimating: Bool = false
    @State var scale: CGFloat = 1.0
    
    
    // Starts the scaling animation
    private func startAnimation() {
        isAnimating = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if !isAnimating {
                timer.invalidate() // Stop the timer when animation should end
            } else {
                dailyDataService.refreshAppReady()
                withAnimation(.snappy(duration: 0.25)) {
                    scale = 1.25
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Short time at scale 1.5
                    withAnimation(.snappy(duration: 0.25).delay(0)) { // Longer time returning to 1.0
                        scale = 1.0
                    }
                }
            }
        }
    }
    
    // Stops the scaling animation
    private func stopAnimation() {
        isAnimating = false
        scale = 1.0 // Reset to original scale
    }
    
    
    
    var body: some View {
        ZStack{
            Color.splashScreen.ignoresSafeArea()
            
            HStack{
                Image("SplashScreenImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 130)
                    .scaleEffect(scale)
                //                    .animation(isAnimating ? asymmetricalAnimation() : .default, value: scale)
                    .onAppear {
                        startAnimation()
                    }
                    .onChange(of: dailyDataService.appIsReady) { oldValue, newValue in
                        if newValue {
                            stopAnimation()
                            withAnimation(.easeInOut){
                                isShowingTabView = true
                            }
                        }
                    }
                
            }
        }
        
    }
}

#Preview {
    @Previewable @State var isShowingTabView = false
    AppLoadingView(isShowingTabView: $isShowingTabView)
}
