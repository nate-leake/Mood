//
//  EmotionTagView.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import SwiftUI

struct EmotionTagView: View {
    @Binding var selectedEmotions: [Emotion]
    var mood: Mood
    
    @State private var totalHeight = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
                    .onChange(of: mood, {
                        selectedEmotions.removeAll()
                    })
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.mood.emotions, id:\.name) { tag in
                self.item(for: tag)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag.name == self.mood.emotions.last!.name {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag.name == self.mood.emotions.last!.name {
                            height = 0 // last item
                        }
                        return result
                    })
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)){
                            if self.selectedEmotions.contains(where: {$0.name == tag.name}){
                                self.selectedEmotions.removeAll{$0.name == tag.name}
                            } else {
                                self.selectedEmotions.append(tag)
                            }
                            
                        }
                    }
            }
        }.background(viewHeightReader($totalHeight))
    }
    
    private func item(for emotion: Emotion) -> some View {
        let isSelected = selectedEmotions.contains(where: {$0.name == emotion.name})
        var foregroundColorSelected: Color
        var foregroundColorNotSelected: Color
        
        if mood.name == Mood.allMoods[0].name || mood.name == Mood.allMoods[4].name {
            foregroundColorSelected = .appBlack
            foregroundColorNotSelected = .appBlack
        } else {
            foregroundColorSelected = .white
            foregroundColorNotSelected = .appBlack
        }
        
        return Text(emotion.name)
            .padding(.all, 7)
            .font(.body)
            .background(isSelected ? mood.getColor() : .appBlack.opacity(0.15))
            .foregroundColor(isSelected ? foregroundColorSelected : foregroundColorNotSelected)
            .cornerRadius(50)
            .animation(.easeInOut(duration: 0.25), value: isSelected)
        
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry in
            Color.clear.onAppear {
                binding.wrappedValue = geometry.size.height
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedEmotions: [Emotion] = []
    
    return EmotionTagView(selectedEmotions: $selectedEmotions, mood: Mood.allMoods[0])
}
