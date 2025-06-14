//
//  YourMoodsChartsView.swift
//  Mood
//
//  Created by Nate Leake on 9/5/24.
//

import SwiftUI

class MoodPostTracker: ObservableObject {
    @Published var moodPosts: [UnsecureMoodPost] = [UnsecureMoodPost]()
    @Published var loadingSuccess: Bool = false
    @Published var isLoading: Bool = true
    
    @MainActor
    func getRelevantPosts() async {
        isLoading = true
        self.moodPosts = []
        do {
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -90, to: Date())!
            let posts = try await DataService.shared.fetchRecentMoodPosts(limit: 90 * 4, after: cutoffDate)
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

struct YourMoodsChartsView: View {
    @StateObject private var moodPostTracker: MoodPostTracker = MoodPostTracker()
    
    @State private var viewingDaysBack: Int = 14
    
    var body: some View {
        VStack {
            Picker("days back", selection: $viewingDaysBack) {
                Text("90 days").tag(90)
                Text("30 days").tag(30)
                Text("2 weeks").tag(14)
                Text("1 week").tag(7)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 24)
                        
            ScrollView {
                VStack(alignment: .leading){
                    
                    if moodPostTracker.loadingSuccess{
                        MoodLineChartBreakdownView(viewingDaysBack: viewingDaysBack)
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
            .onAppear {
                Task {
                    await moodPostTracker.getRelevantPosts()
                }
            }
        }
    }
}

#Preview {
    YourMoodsChartsView()
}
