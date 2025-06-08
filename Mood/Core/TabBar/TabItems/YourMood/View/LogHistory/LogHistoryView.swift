//
//  LogHistoryView.swift
//  Mood
//
//  Created by Nate Leake on 1/24/25.
//
import Foundation
import SwiftUI

class ShortDate{
    private var formatter = DateFormatter()
    
    // Get the current year and the year of the date to format
    let calendar = Calendar.current
    
    func string(from: Date, includeTime: Bool = false) -> String {
        let currentYear = calendar.component(.year, from: Date())
        let dateYear = calendar.component(.year, from: from)
        var format: String = ""
        
        // Set the date format based on whether the year should be included
        if currentYear == dateYear {
            format = "MMM d" // Without year
        } else {
            format = "MMM d, yyyy" // Include year
        }
        
        if includeTime {
            format = format + ", h:mm a"
        }
        
        formatter.dateFormat = format
        
        return formatter.string(from: from).lowercased()
    }
    
    func date(from: String) -> Date? {
        return formatter.date(from: from)
    }
}

struct LogDayView: View {
    var post: UnsecureMoodPost
    
    var body: some View {
        
        NavigationLink {
            LogDetailView(post: post)
        } label: {
            VStack{
                
                HStack {
                    Text("\(ShortDate().string(from: post.timestamp))")
                        .fontWeight(.bold)
                        .foregroundStyle(.appBlack.opacity(0.75))
                    Spacer()
                }
                
                HStack {
                    OverflowLayout {
                        ForEach(post.contextLogContainers, id:\.contextId) { data in
                            if let context = UnsecureContext.getContext(from: data.contextId) {
                                ContextTile(context: context, frameSize: CGFloat(50))
                            } else {
                                Text("nil")
                                    .onAppear{
                                        print("nil context: \(data.contextName), \(data.contextId)")
                                    }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .navLinkModifier()
        }
        
    }
}

struct LogHistoryView: View {
    @EnvironmentObject var dataService: DataService
    
    var body: some View {
        
        ScrollView{
            if let moodPosts = dataService.recentMoodPosts {
                ForEach(moodPosts, id: \.id){ post in
                    
                    LogDayView(post: post)
                        .padding(.bottom, 10)
                    
                }
            }
            TabBarSpaceReservation()
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("log history")
    }
    
}


#Preview {
    @Previewable @StateObject var dataService = DataService.shared
    
    NavigationStack {
        LogHistoryView()
            .environmentObject(dataService)
    }
    .onAppear{
        dataService.loadedContexts = UnsecureContext.defaultContexts
        dataService.recentMoodPosts = UnsecureMoodPost.MOCK_DATA
    }
    
}
