//
//  YourMoodsChartsView.swift
//  Mood
//
//  Created by Nate Leake on 9/5/24.
//

import SwiftUI

struct YourMoodsChartsView: View {
    @StateObject private var chartService: ChartService = ChartService.shared
    @StateObject private var moodPostTracker: ChartMoodPostTracker = ChartMoodPostTracker.shared
    
    @State private var viewingDaysBack: Int = 14
    
    var body: some View {
        VStack {
            SegmentedTimePickerView()
            .padding(.horizontal, 24)
                        
            ScrollView {
                VStack(alignment: .leading){
                    
                    if moodPostTracker.loadingSuccess{
                        MoodLineChartBreakdownView()
                            .environmentObject(moodPostTracker)
                            .padding(.horizontal)
                            .padding(.top, 15)
                    } else if moodPostTracker.isLoading {
                        VStack {
                            
                        }
                    } else {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.appYellow)
                                .font(.title)
                                .padding(.top)
                            Text("something went wrong while loading your data")
                                .font(.headline)
                                .padding(.vertical)
                            Text("please try again later")
                                .font(.caption)
                        }
                    }
                    
                }
                .transition(.opacity.combined(with: .blurReplace))
                
                TabBarSpaceReservation()
            }
        }
    }
}

#Preview {
    YourMoodsChartsView()
}
