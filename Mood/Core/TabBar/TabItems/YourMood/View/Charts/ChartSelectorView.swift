//
//  ChartSelectorView.swift
//  Mood
//
//  Created by Nate Leake on 7/5/25.
//

import SwiftUI

struct ChartSelectorView: View {
    @EnvironmentObject var dataService: DataService
    @StateObject var chartService: ChartService = ChartService.shared
    
    var body: some View {
        ScrollView {
            NavigationLink{
                YourMoodsChartsView()
            } label: {
                Text("recent moods")
                    .foregroundStyle(.appBlack)
                    .navLinkModifier()
            }
            .padding(.bottom, 15)
            
            VStack {
                ForEach(dataService.loadedContexts) { context in
                    if !context.isHidden {
                        NavigationLink {
                            ContextChartView(context: context)
                                .environmentObject(dataService)
                                .environmentObject(chartService)
                        } label: {
                            HStack {
                                ContextTile(context: context, frameSize: 50)
                                Text(context.name)
                                    .foregroundStyle(.appBlack)
                            }
                            .navLinkModifier()
                        }
                    }
                }
            }
            .padding(.bottom, 15)
            
            VStack {
                ForEach(dataService.loadedContexts) { context in
                    if context.isHidden {
                        NavigationLink {
                            ContextChartView(context: context)
                                .environmentObject(dataService)
                                .environmentObject(chartService)
                        } label: {
                            HStack {
                                ContextTile(context: context, frameSize: 50)
                                Text(context.name)
                                    .foregroundStyle(.appBlack)
                            }
                            .navLinkModifier()
                        }
                    }
                }
            }
            
            TabBarSpaceReservation()
            
        }
    }
}

#Preview {
    @Previewable @StateObject var dataService = DataService.shared
    NavigationStack {
        ChartSelectorView()
            .environmentObject(dataService)
            .onAppear {
                dataService.previewSetup()
            }
    }
}
