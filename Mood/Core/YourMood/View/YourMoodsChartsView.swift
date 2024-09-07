//
//  YourMoodsChartsView.swift
//  Mood
//
//  Created by Nate Leake on 9/5/24.
//

import SwiftUI

struct YourMoodsChartsView: View {
    @State private var moodPosts: [MoodPost]?
    @State private var loadingSuccess: Bool = false
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                
                if loadingSuccess{
                    LineChartWithSelection(moodPosts: moodPosts ?? [], viewingDataType: .mood, height: 250)
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                } else {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.appYellow)
                            .font(.title)
                            .padding(.top)
                        Text("something went wrong loading your data")
                            .font(.headline)
                            .padding(.vertical)
                        Text("please try again later")
                            .font(.caption)
                    }
                }
 
            }
            .task {
                do {
                    moodPosts = try await DailyDataService.shared.fetchRecentMoodPosts(quantity: 7)
                    loadingSuccess = true
                } catch {
                    loadingSuccess = false
                }
            }
        }
    }
}

#Preview {
    YourMoodsChartsView()
}
