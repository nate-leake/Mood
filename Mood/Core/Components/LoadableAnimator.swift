//
//  LoadableButton.swift
//  Mood
//
//  Created by Nate Leake on 10/18/24.
//

import SwiftUI

struct LoadableAnimator: ViewModifier {
    @Binding var isLoading: Bool
    @State var rotation: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading{
                    AngularGradient(stops: [
                        .init(color: .appRed, location: 0),
                        .init(color: .appPurple, location: 0),
                        .init(color: .appPurple, location: 0.2),
                        .init(color: .appBlue, location: 0.2),
                        .init(color: .appBlue, location: 0.4),
                        .init(color: .appGreen, location: 0.4),
                        .init(color: .appGreen, location: 0.6),
                        .init(color: .appYellow, location: 0.6),
                        .init(color: .appYellow, location: 0.8),
                        .init(color: .appRed, location: 0.8)
                    ], center: .center)
                    .frame(width: 370, height: 370)
                    .rotationEffect(.degrees(rotation))
                    .mask {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 3)
                            .frame(width: 354, height: 38)
                    }
                }
            }
            .onChange(of: isLoading) { oldValue, newValue in
                if oldValue == false && newValue {
                    withAnimation(.linear(duration:4).repeatForever(autoreverses: false)){
                        rotation = 360
                    }
                }
            }
            
    }
}


extension View {
    func loadable(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoadableAnimator(isLoading: isLoading))
    }
}
