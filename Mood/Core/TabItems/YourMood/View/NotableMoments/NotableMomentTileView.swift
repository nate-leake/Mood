//
//  NotableMomentTileView.swift
//  Mood
//
//  Created by Nate Leake on 4/28/25.
//

import SwiftUI

struct NotableMomentTileView: View {
    var title: String
    var description: String
    var date: Date
    var color: Color = .appYellow
    var withEditor: Bool = true
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                
                Spacer()
                
                Text(ShortDate().string(from: date, includeTime: true))
                    .font(.callout)
                    .opacity(0.8)
            }
            .bold()
            
            .padding(.horizontal, 7)
            .padding(.vertical, 6)
            .background(color)
            .foregroundStyle(color.optimalForegroundColor())
                        
            Text(description)
                .padding(.horizontal, 7)
                .padding(.vertical, 6)
                .lineLimit(4)
        }
        
        .background(color.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 24)
        
        
//            VStack {
//                HStack {
//                    Spacer()
//                    if withEditor {
//                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
//                            .font(.title2)
//                            .background(RoundedRectangle(cornerRadius: 4).fill(.appGreen).padding(-4))
//                            .foregroundStyle(.appWhite)
//                            .padding(.trailing, 25)
//                            .padding(.top, -35)
//                            .transition(.scale.animation(.spring(bounce: 0.4)).combined(with: .opacity))
//                    }
//
//                }
//                Spacer()
//            }
        
        
        
    }
}

#Preview {
    @Previewable var desc: String = "I got a new dog today and it made me feel really happy!! Now I know what its like to have a friendly pal! My parents told me I'll have to help take care of it. That means I'll have a reason to go on more walks and see the sun every day!"
    NotableMomentTileView(title: "this notable moment", description: desc, date: Date.now)
}
