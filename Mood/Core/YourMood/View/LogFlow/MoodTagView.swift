//
//  TagView.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import SwiftUI

struct MoodTagView: View {
    @Binding var selectedMoods: Mood?
    @State private var selectedTag: Mood?
    var tags: [Mood] = Mood.allMoods
    
    
    @State private var totalHeight
    = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id:\.name) { tag in
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
                        if tag.name == self.tags.last!.name {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag.name == self.tags.last!.name {
                            height = 0 // last item
                        }
                        return result
                    })
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            self.selectedMoods = tag
                            self.selectedTag = tag
                        }
                    }
            }
        }.background(viewHeightReader($totalHeight))
    }
    
    private func item(for mood: Mood) -> some View {
        let isSelected = mood.name == selectedTag?.name
        
        var foregroundColorSelected: Color
        var foregroundColorNotSelected: Color
        
        if mood.name == Mood.allMoods[0].name || mood.name == Mood.allMoods[4].name {
            foregroundColorSelected = .appBlack
            foregroundColorNotSelected = .appBlack
        } else {
            foregroundColorSelected = .white
            foregroundColorNotSelected = .appBlack
        }
        
        return Text(mood.name)
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
    @State var selectedMood: Mood?
    
    return MoodTagView(selectedMoods: $selectedMood)
}
