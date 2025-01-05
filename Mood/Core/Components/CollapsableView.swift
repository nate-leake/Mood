//
//  CollapsableView.swift
//  Mood
//
//  Created by Nate Leake on 12/29/24.
//

import SwiftUI

struct SampleView: View {
    var body: some View {
        Text("hello!!")
    }
}

struct CollapsableView<Content: View>: View {
    var openTitle: String
    var closedTitle: String
    @Binding var isDisclosed: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack {
            HStack{
                Text(isDisclosed ? openTitle : closedTitle)
                    .padding(.leading, 10)
                    .opacity(0.7)
                    .fontWeight(isDisclosed ? .bold : .regular)
                Spacer()
                Button{
                    withAnimation {
                        isDisclosed.toggle()
                    }
                } label: {
                    HStack{
                        Spacer()
                        Image(systemName: "chevron.down")
                            .rotationEffect(Angle(degrees: isDisclosed ? 90 : 0))
                    }
                }
            }
            
            content
                .frame(height: isDisclosed ? nil : 0, alignment: .top)
                .clipped()
            
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    @Previewable @State var isOpen = false
    
    VStack {
        Button {
            isOpen.toggle()
        } label: {
            Text("open / close")
        }
        
        CollapsableView(openTitle: "mood", closedTitle: "happiness", isDisclosed: $isOpen){SampleView()}
    }
}
