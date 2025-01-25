//
//  LoadableButton.swift
//  Mood
//
//  Created by Nate Leake on 10/18/24.
//

import SwiftUI

struct LoadableAnimator<S: Shape>: ViewModifier {
    @Binding var isLoading: Bool
    @State var rotation: CGFloat = 0
    let shape: S
    let frameSize: CGSize
    let lineWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading{
                    Circle()
                        .fill(
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
                        )
                        .frame(width: frameSize.width + frameSize.height, height: frameSize.width + frameSize.height)
                        .rotationEffect(.degrees(rotation))
                        .mask {
                            shape
                                .stroke(lineWidth: lineWidth)
                                .frame(width: frameSize.width - lineWidth + 1, height: frameSize.height - lineWidth + 1)
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
    func loadable<S: Shape>(
        isLoading: Binding<Bool>,
        shape: S,
        frameSize: CGSize,
        lineWidth: CGFloat = 3
    ) -> some View {
        self.modifier(LoadableAnimator(isLoading: isLoading, shape: shape, frameSize: frameSize, lineWidth: lineWidth))
    }
}

#Preview {
    @Previewable @State var loading = false
    VStack {
        HStack {
            Spacer()
            Button {
                withAnimation(.easeInOut) {
                    loading = true
                    print(loading)
                }
            } label: {
                Text("play")
                    .frame(width: 75, height: 50)
                    .background(.appGreen)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut) {
                    loading = false
                    print(loading)
                }
            } label: {
                Text("pause")
                    .frame(width: 75, height: 50)
                    .background(.appRed)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            Spacer()
        }
        
        Spacer()
        
        Text(loading ? "loading..." : "start animation to view")
            .font(.headline)
            .fontWeight(.bold)
            .frame(width: 360, height: 44)
            .foregroundStyle(.white)
            .background(.appPurple)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .loadable(isLoading: $loading, shape: RoundedRectangle(cornerRadius: 8), frameSize: CGSize(width: 360, height: 44))
        
        Spacer()
    }
}
