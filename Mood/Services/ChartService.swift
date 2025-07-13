//
//  ChartService.swift
//  Mood
//
//  Created by Nate Leake on 7/6/25.
//

import Foundation
import SwiftUI

class ChartMoodPostTracker: ObservableObject {
    @Published var moodPosts: [UnsecureMoodPost] = [UnsecureMoodPost]()
    @Published var loadingSuccess: Bool = false
    @Published var isLoading: Bool = true
    
    public static var shared = ChartMoodPostTracker()
    
    init(){
        Task {
            await self.getRelevantPosts()
        }
    }
    
    @MainActor
    func getRelevantPosts() async {
        isLoading = true
        self.moodPosts = []
        do {
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -90, to: Date())!
            let posts = try await DataService.shared.fetchRecentMoodPosts(after: cutoffDate)
            print("getting posts from after date \(cutoffDate)")
            withAnimation { self.moodPosts = posts }
            withAnimation { self.loadingSuccess = true }
            print("mood posts loaded: \(self.moodPosts.count)")
        } catch {
            loadingSuccess = false
        }
        withAnimation { isLoading = false }
    }
}

class ChartService: ObservableObject {
    @Published var dataService: DataService = DataService.shared
    @Published var chartMoodPostTracker: ChartMoodPostTracker = ChartMoodPostTracker.shared
    
    public static var shared = ChartService()
    
    func moodPostsAfterPickerSelection(viewingDaysBack: Int) -> [UnsecureMoodPost] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -viewingDaysBack, to: Date())!
        
        var postsInDateRange: [UnsecureMoodPost] = []
        
        for post in chartMoodPostTracker.moodPosts {
            if post.timestamp >= cutoffDate {
                postsInDateRange.append(post)
            }
        }
        
        return postsInDateRange
    }
    
    func generatePieChartData(moodData: [MoodData]) -> [PieChartData]{
        var chartData: [PieChartData] = []

        let aggregatedData = AnalyticsGenerator.shared.aggregateMoodIntensityTotals(moodData: moodData)
        
        for data in aggregatedData {
            
            let newPieData = PieChartData(
                value: data.intensity,
                category: data.mood,
                color: Color(data.mood)
            )
            
            chartData.append(newPieData)
        }
        
        return chartData
    }
    
    func generateLineChartData(moodData: [MoodData]) -> [LineChartData] {
        var chartData: [LineChartData] = []
        
        for data in moodData {
            let newChartData = LineChartData(date: data.date, value: data.intensity, category: data.moodType, color: Color(data.moodType))
            chartData.append(newChartData)
        }
        
        return chartData
    }
}


