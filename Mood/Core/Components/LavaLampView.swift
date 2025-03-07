//
//  LavaLampView.swift
//  Mood
//
//  Created by Nate Leake on 2/23/25.
//

import SwiftUI

struct LavaLampView: View {
    var backgroundColor: Color
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var points : [SIMD2<Float>] = [
        [0, 0], [0.5, 0], [1, 0],
        [0, 0.5], [0.5, 0.5], [1, 0.5],
        [0, 1], [0.5, 1], [1, 1]
        
    ]
    
    @State private var colors: [Color] = [
        .appPurple.darkModeVariant(), .appPurple.lightModeVariant(), .appPurple.darkModeVariant(),
        .appPurple.lightModeVariant(), .appPurple.darkModeVariant(), .appPurple.lightModeVariant(),
        .appPurple.darkModeVariant(), .appPurple.lightModeVariant(), .appPurple.darkModeVariant()
    ]
    
    var body: some View {
        ZStack {
            MeshGradient(width:3, height: 3, points: points, colors: colors)
                .ignoresSafeArea()
                .onReceive(timer) { _ in
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 1.5)){
                            let midLeftY : Float = .random(in: 0.1...0.9)
                            let midMidY : Float = .random(in: 0.2...0.8)
                            let midRightY : Float = .random(in: 0.1...0.9)
                            points[3] = [0, midLeftY]
                            points[4] = [.random(in: 0.2...0.8), midMidY]
                            points[5] = [1, midRightY]
                            
                            if midLeftY < 0.5 {
                                colors[0] = backgroundColor.darkModeVariant()
                                colors[3] = backgroundColor.darkModeVariant()
                                colors[6] = backgroundColor.lightModeVariant()
                            } else {
                                colors[0] = backgroundColor.lightModeVariant()
                                colors[3] = backgroundColor.lightModeVariant()
                                colors[6] = backgroundColor.darkModeVariant()
                            }
                            
                            if midMidY < 0.5 {
                                colors[1] = backgroundColor.darkModeVariant()
                                colors[4] = backgroundColor.darkModeVariant()
                                colors[7] = backgroundColor.lightModeVariant()
                            } else {
                                colors[1] = backgroundColor.lightModeVariant()
                                colors[4] = backgroundColor.lightModeVariant()
                                colors[7] = backgroundColor.darkModeVariant()
                            }
                            
                            if midRightY < 0.5 {
                                colors[2] = backgroundColor.darkModeVariant()
                                colors[5] = backgroundColor.darkModeVariant()
                                colors[8] = backgroundColor.lightModeVariant()
                            } else {
                                colors[2] = backgroundColor.lightModeVariant()
                                colors[5] = backgroundColor.lightModeVariant()
                                colors[8] = backgroundColor.darkModeVariant()
                            }
                            
                            
                        }
                    }
                }
        }
        .onAppear{
            self.colors = [
                backgroundColor.lightModeVariant(), backgroundColor.lightModeVariant(), backgroundColor.lightModeVariant(),
                backgroundColor.lightModeVariant(), backgroundColor.darkModeVariant(), backgroundColor.lightModeVariant(),
                backgroundColor.darkModeVariant(), backgroundColor.darkModeVariant(), backgroundColor.darkModeVariant()
            ]
        }
    }
    
    
}

#Preview {
    LavaLampView(backgroundColor: .sadness)
}
