//
//  ToolsAndObjectivesView.swift
//  Mood
//
//  Created by Nate Leake on 3/30/25.
//

import SwiftUI

struct ToolsAndObjectivesView: View {
    @ObservedObject var dataService: DataService = DataService.shared

    var body: some View {
        NavigationStack {
            
            VStack {

                NavigationLink {
                    ObjectivesView()
                } label: {
                    VStack(alignment: .center) {
                        HStack {
                            Text("objectives")
                                .foregroundStyle(.black)
                                .bold()
                                .padding(12)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .background(.appYellow)
                        
                        OverflowLayout {
                            if dataService.loadedObjectives.count == 0 || dataService.loadedObjectives.allSatisfy( {$0.isCompleted} ) {
                                ObjectiveTileView(frameSize: 100, label: "add one today", color: .appBlue, isCompleted: false)
                                
                            } else {
                                ForEach(dataService.loadedObjectives.prefix(6)) { objective in
                                    if !objective.isCompleted {
                                        ObjectiveTileView(frameSize: 100, label: objective.title, color: objective.color, isCompleted: false)
                                    }
                                }
                            }
                            
//                            ObjectiveTileView(frameSize: 100, label: "go fishing more", color: .pink, isCompleted: false)
//                            ObjectiveTileView(frameSize: 100, label: "finish module 1 in HM", color: .appRed, isCompleted: false)
//                            ObjectiveTileView(frameSize: 100, label: "extra things!!", color: .blue, isCompleted: false)
                        }
//                        .padding(.horizontal, 10)
                        .padding(.bottom, 12)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 150)
                    .background(.appYellow.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 24)
                    
                }
                
                NavigationLink {
                    ToolsView()
                } label: {
                    HStack() {
                        Spacer()
                        
                        Image(systemName: "link")
                            .font(.footnote)
                            .bold()
                            .frame(width: 30, height: 30)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text("external resources")
                            .foregroundStyle(.white)
                            .bold()
                            .padding(7)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.appPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 24)
                }
                
                Spacer()
            }
            .padding(.top, 35)
        }
        
    }
}

#Preview {
    ToolsAndObjectivesView()
        .onAppear{
//            DataService.shared.loadedObjectives = UnsecureObjective.MOCK_DATA
        }
}
