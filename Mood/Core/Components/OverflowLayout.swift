//
//  Untitled.swift
//  Mood
//
//  Created by Nate Leake on 1/2/25.
//

import SwiftUI

struct OverflowLayout: Layout {
    var spacing = CGFloat(10)
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let containerWidth = proposal.replacingUnspecifiedDimensions().width
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, containerWidth: containerWidth).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = layout(sizes: sizes, containerWidth: bounds.width).offsets
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: offset.x + bounds.minX, y: offset.y + bounds.minY), proposal: .unspecified)
        }
    }
    
    func layout(sizes: [CGSize], containerWidth: CGFloat) -> (offsets: [CGPoint], size: CGSize) {
        var result: [CGPoint] = []
        var currentPosition: CGPoint = .zero
        var lineHeight: CGFloat = 0
        var maxX: CGFloat = 0
        for size in sizes {
            if currentPosition.x + size.width > containerWidth {
                currentPosition.x = 0
                currentPosition.y += lineHeight + spacing
                lineHeight = 0
            }
            
            result.append(currentPosition)
            currentPosition.x += size.width
            maxX = max(maxX, currentPosition.x)
            currentPosition.x += spacing
            lineHeight = max(lineHeight, size.height)
        }
        
        return (result, CGSize(width: maxX, height: currentPosition.y + lineHeight))
    }
}
