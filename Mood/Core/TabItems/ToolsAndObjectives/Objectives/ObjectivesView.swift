//
//  ObjectivesView.swift
//  Mood
//
//  Created by Nate Leake on 4/4/25.
//

import SwiftUI

struct ObjectivesView: View {
    @EnvironmentObject var dataService: DataService
    let layout = [
        GridItem(.adaptive(minimum:150), spacing: 0),
        GridItem(.adaptive(minimum:150), spacing: 0)
    ]
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(dataService.loadedObjectives) { objective in
                    ObjectiveTileView(frameSize: 150, label: objective.title, color: objective.color).padding(.bottom)
                }
            }
        }
        .navigationTitle("objectives")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink {
                    ObjectivesBuilderView()
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    ObjectivesView()
        .environmentObject(DataService())
}
