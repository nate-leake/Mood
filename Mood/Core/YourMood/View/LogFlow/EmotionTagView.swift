//
//  EmotionTagView.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import SwiftUI

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct EmotionTagView: View {
    @Binding var selectedEmotions: [Emotion]
    var mood: Mood
    
    @State private var totalHeight = CGFloat.zero
    let foregroundColorNotSelected: Color = .appBlack
    
    var body: some View {
        HStack{
            OverflowLayout() {
                ForEach(mood.emotions, id: \.name) { tag in
                    Text("\(tag.name)")
                        .padding(.all, 7)
                        .font(.body)
                        .background(getIsSelected(tag: tag) ? mood.getColor() : .appBlack.opacity(0.15))
                        .foregroundColor(getIsSelected(tag: tag) ? (mood.getColor().isLight() ? .black : .white) : foregroundColorNotSelected)
                        .cornerRadius(50)
                        .animation(.easeInOut(duration: 0.25), value: getIsSelected(tag: tag))
                        .onTapGesture {
                            if getIsSelected(tag: tag) {
                                withAnimation(.easeInOut(duration: 0.25)){
                                    selectedEmotions.removeAll(where: {$0.name == tag.name})
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.25)){
                                    selectedEmotions.append(tag)
                                }
                            }
                        }
                }
            }
            Spacer()
        }
    }
    
    private func getIsSelected(tag : Emotion) -> Bool {
        return selectedEmotions.contains(where: {$0.name == tag.name})
    }
    
}

#Preview {
    @Previewable @State var selectedEmotions: [Emotion] = []
    
    return EmotionTagView(selectedEmotions: $selectedEmotions, mood: Mood.allMoods[0])
}
