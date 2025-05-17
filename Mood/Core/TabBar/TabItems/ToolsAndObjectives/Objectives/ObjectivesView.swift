//
//  ObjectivesView.swift
//  Mood
//
//  Created by Nate Leake on 4/4/25.
//

import SwiftUI

struct ObjectivesView: View {
    @Namespace private var objectivesNamespace
    @ObservedObject var dataService: DataService = DataService.shared
    let layout = [
        GridItem(.adaptive(minimum:150), spacing: 0),
        GridItem(.adaptive(minimum:150), spacing: 0)
    ]
    
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                if dataService.loadedObjectives.isEmpty {
                    NavigationLink {
                        ObjectiveAdderView()
                    } label: {
                        ObjectiveTileView(label: "create an objective", color: .appYellow, isCompleted: false)
                    }
                } else {
                    ForEach(dataService.loadedObjectives, id:\.id) { objective in
                        if !objective.isCompleted {
                            NavigationLink {
                                ObjectiveEditorView(editing: objective)
                                    .navigationTransition(.zoom(sourceID: objective.id, in: objectivesNamespace))
                            } label: {
                                ObjectiveTileView(label: objective.title, color: objective.color, isCompleted: objective.isCompleted).padding(.bottom)
                            }
                            .matchedTransitionSource(id: objective.id, in: objectivesNamespace)
                        }
                    }
                    
                    
                }
            }
            
            if !dataService.loadedObjectives.allSatisfy({ !$0.isCompleted }) {
                Divider()
            }
            
            LazyVGrid(columns: layout) {
                ForEach(dataService.loadedObjectives, id:\.id) { objective in
                    if objective.isCompleted {
                        NavigationLink {
                            ObjectiveEditorView(editing: objective)
                                .navigationTransition(.zoom(sourceID: objective.id, in: objectivesNamespace))
                        } label: {
                            ObjectiveTileView(label: objective.title, color: objective.color, isCompleted: objective.isCompleted).padding(.bottom)
                        }
                        .matchedTransitionSource(id: objective.id, in: objectivesNamespace)
                    }
                }
            }
            .padding(.top)
            Rectangle()
                .fill(.clear)
                .frame(height: 60)
        }
        .navigationTitle("objectives")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink {
                    ObjectiveAdderView()
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
