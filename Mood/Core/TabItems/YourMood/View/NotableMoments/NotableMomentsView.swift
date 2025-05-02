//
//  NotableMomentsView.swift
//  Mood
//
//  Created by Nate Leake on 4/26/25.
//

import SwiftUI

struct NotableMomentsView: View {
    var body: some View {
        VStack {
            ScrollView {
                NotableMomentTileView(title: "definition", description: "A defining moment in your life is an occasion where your life’s path has undeniably changed.", date: Date.now, color: .uncertainty)
                    .padding(.bottom, 10)
                NotableMomentTileView(title: "more defining", description: "It could be something that changes within yourself. Maybe you experience an injury or illness that changes your perspective in life.", date: Date.now, color: .pleasure)
                    .padding(.bottom, 10)
                NotableMomentTileView(title: "even more of it", description: "It could be an external factor like a career or relationship change.", date: Date.now, color: .pleasure)
                    .padding(.bottom, 10)
                NotableMomentTileView(title: "things could be different", description: "But a defining moment is one of those times that you know you’ll look back on and say “If it weren’t for that, things would be different.”", date: Date.now, color: .displeasure)
                    .padding(.bottom, 10)
                NotableMomentTileView(title: "info", description: "As you go on your own path, you undoubtedly will have similar defining moments.  In fact, I’m sure you already have. Sometimes it just takes a while to realize how important these moments are.", date: Date.now, color: .uncertainty)
                    .padding(.bottom, 10)
                NotableMomentTileView(title: "Examples", description: "Examples include Getting married or divorced, Starting a new job or leaving an old one, Beginning a new business partnership, Taking a big trip, Paying off debt, Finishing school, Retiring, Losing a Loved One, Having a baby", date: Date.now, color: .displeasure)
                    .padding(.bottom, 10)
            }
        }
        .navigationTitle("notable moments")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink {
                    AddNotableMomentView()
                } label: {
                    Image(systemName: "note.text.badge.plus")
                        .imageScale(.large)
                        .foregroundStyle(.appGreen)
                }
            }
        }
    }
}

#Preview {
    NotableMomentsView()
}
