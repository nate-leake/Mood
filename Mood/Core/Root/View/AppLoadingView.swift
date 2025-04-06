//
//  AppLoadingView.swift
//  Mood
//
//  Created by Nate Leake on 9/9/24.
//

import SwiftUI

struct AppLoadingView: View {
    @Binding var appState: AppStateCase
    @State var isAnimating: Bool = false
    
    // Starts the scaling animation
    private func startAnimation() {
        isAnimating = true
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if !isAnimating {
                timer.invalidate() // Stop the timer when animation should end
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { // Short time at scale 1.5
                    withAnimation(.snappy(duration: 0.25).delay(0)) { // Longer time returning to 1.0
                        appState = AppState.shared.getAppState()
                        if appState == .ready {
                            stopAnimation()
                        }
                    }
                }
            }
        }
    }
    
    // Stops the scaling animation
    private func stopAnimation() {
        isAnimating = false
    }
    
    
    
    var body: some View {
        ZStack {
            ZStack{
                Color.splashScreen
                
                HStack{
                    Image("MoodSymbol")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 170)
                        .symbolRenderingMode(.multicolor)
                        .symbolEffect(.breathe.plain, options: .speed(1.5))
                        .onAppear {
                            startAnimation()
                        }
                }
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("made by humans")
                    .bold()
                    .foregroundStyle(.appPurple)
            }
        }
        
        
    }
}

#Preview {
    @Previewable @State var appState: AppStateCase = .startup
    AppLoadingView(appState: $appState)
        .environmentObject(DataService())
}
