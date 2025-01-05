//
//  TagView.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import SwiftUI

struct MoodTagView: View {
    @Binding var selectedMood: Mood?
    @Binding var assignedMoods: [Mood]
    var tags: [Mood] = Mood.allMoods
    let foregroundColorNotSelected: Color = .appBlack
    
    var body: some View {
        HStack {
            OverflowLayout() {
                ForEach(tags, id:\.name) { tag in
                    if tag.name == selectedMood?.name || !assignedMoods.contains(where: {$0.name == tag.name}){
                        Text("\(tag.name)")
                            .padding(.all, 7)
                            .font(.body)
                            .background(selectedMood == tag ? tag.getColor() : .appBlack.opacity(0.15))
                            .foregroundColor(selectedMood == tag ? (tag.getColor().isLight() ? .black : .white) : foregroundColorNotSelected)
                            .animation(.easeInOut(duration: 0.25), value: selectedMood == tag)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 50)
                            )
                            .onTapGesture{
                                withAnimation(.easeInOut(duration: 0.25)){
                                    if let mood = selectedMood {
                                        if let index = assignedMoods.firstIndex(where: {$0.name == mood.name}) {
                                            assignedMoods.remove(at: index)
                                        }
                                    }
                                    selectedMood = tag
                                    assignedMoods.append(tag)
                                }
                            }
                    }
                }
            }
            Spacer()
        }
    }
}


#Preview {
    @Previewable @State var selectedMood: Mood? = Mood.allMoods[0]
    @Previewable @State var assignedMoods: [Mood] = [Mood.allMoods[0], Mood.allMoods[1]]
    
    return MoodTagView(selectedMood: $selectedMood, assignedMoods: $assignedMoods)
}
