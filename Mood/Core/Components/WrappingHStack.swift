//
//  WrappingHStack.swift
//  Mood
//
//  Created by Nate Leake on 9/8/24.
//

import SwiftUI

struct WrappingMoodKey: View {
    var items: [(mood: String, intensity: Int)]
    var maxDisplayed: Int
    
    init(items: [(mood: String, intensity: Int)], maxDisplayed: Int = -1) {
        self.items = items
        if maxDisplayed <= 0 {
            self.maxDisplayed = items.count
        } else {
            self.maxDisplayed = maxDisplayed
        }
        
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        return ZStack(alignment: .topLeading) {
            ForEach(items.prefix(maxDisplayed).indices, id: \.self) { item in
                self.hstack(for: items[item])
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == items.count - 1 {
                            width = 0 // Last item resets width
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == items.count - 1 {
                            height = 0 // Last item resets height
                        }
                        return result
                    })
            }
        }
    }
    
    private func hstack(for item: (mood: String, intensity: Int)) -> some View {
        HStack{
            Circle()
                .fill(Mood(name: item.mood, emotions: []).getColor())
                .frame(width: 5)
            Text(item.mood)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

#Preview {
    WrappingMoodKey(items: [("happiness",1), ("sadness", 2), ("neutrality", 2)])
        .background(.pink)
}
