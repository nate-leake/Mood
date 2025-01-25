//
//  CollapsableView.swift
//  Mood
//
//  Created by Nate Leake on 12/29/24.
//

import SwiftUI

struct ThumbnailView: View, Identifiable {
    var id = UUID()
    @ViewBuilder var content: any View
    
    var body: some View {
        ZStack {
            AnyView(content)
        }
    }
}


struct ExpandedView: View {
    var id = UUID()
    @ViewBuilder var content: any View
    
    var body: some View {
        ZStack {
            AnyView(content)
        }
    }
}


struct CollapsableView: View {
    @Namespace private var namespace
    @Binding var isDisclosed: Bool
    var thumbnail: ThumbnailView
    var expanded: ExpandedView
    
    var body: some View {
        VStack {
            thumbnailView()
            if isDisclosed {
                expandedView()
            }
        }
        .clipped()
        .onTapGesture {
            
            withAnimation (.spring(response: 0.8)){
                isDisclosed.toggle()
                print("clicked on view. idDisclosed: \(isDisclosed)")
            }
            
        }
    }
    
    @ViewBuilder
    private func thumbnailView() -> some View {
        HStack {
            thumbnail
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundStyle(.appPurple)
                .rotationEffect(Angle(degrees: isDisclosed ? 90 : 0))
        }
        .matchedGeometryEffect(id: "thumbnail", in: namespace)
    }
    
    @ViewBuilder
    private func expandedView() -> some View {
        expanded
            .matchedGeometryEffect(id: "expanded", in: namespace)
    }
}

#Preview {
    @Previewable @State var isShowing = false
    CollapsableView(isDisclosed: $isShowing,
                    thumbnail: ThumbnailView{ Text("thumblain") },
                    expanded: ExpandedView { Text("Its expanded!") }
    )
}
