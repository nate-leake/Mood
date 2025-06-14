//
//  YourMoodsChartsView.swift
//  Mood
//
//  Created by Nate Leake on 9/5/24.
//

import SwiftUI

struct YourMoodsChartsView: View {
    @State private var moodPosts: [UnsecureMoodPost]?
    @State private var loadingSuccess: Bool = false
    @State private var isLoading: Bool = true
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                
                if loadingSuccess{
                    MoodLineChartBreakdownView(moodPosts: moodPosts ?? [], height: 250)
                        .padding(.horizontal)
                        .padding(.top, 15)
                } else if isLoading {
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
            .task {
                
                do {
                    moodPosts = try await DataService.shared.fetchRecentMoodPosts(quantity: 14)
                    withAnimation(.easeInOut){loadingSuccess = true}
                } catch {
                    loadingSuccess = false
                }
                
                withAnimation(.easeInOut){isLoading = false}
                
            }
            TabBarSpaceReservation()
        }
    }
}

#Preview {
    YourMoodsChartsView()
}
