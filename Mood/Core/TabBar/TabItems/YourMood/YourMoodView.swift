//
//  YourMoodView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI
import Charts

struct NavLinkModifier: ViewModifier {
    private var backgroundColor: Color
    private var withChevron: Bool
    
    init(backgroundColor: Color = Color(.appPurple).opacity(0.15), withChevron: Bool = true) {
        self.backgroundColor = backgroundColor
        self.withChevron = withChevron
    }
    
    func body(content: Content) -> some View {
        HStack {
            content
                
            Spacer()
            
            if withChevron {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
                    .font(.body)
                    .opacity(0.8)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.appPurple.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 20)
            
    }
}

extension View {
    func navLinkModifier(backgroundColor: Color = Color(.appPurple).opacity(0.15), withChevron: Bool = true) -> some View {
        modifier(NavLinkModifier(backgroundColor: backgroundColor, withChevron: withChevron))
    }
}


struct LogHistoryNavLink: View {
    
    var body: some View {
        NavigationLink{
            LogHistoryView()
        } label: {
            HStack(alignment: .top) {
                VStack(alignment: .leading){
                    Text("log history")
                        .fontWeight(.bold)
                        .foregroundStyle(.appBlack.opacity(0.5))
                }
                Spacer()
                ZStack {
                    VStack(spacing: 10){
                        HStack(spacing: 10){
                            Image(systemName: "calendar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.appBlue)
                            Image(systemName: "heart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.appRed)
                        }
                        HStack(spacing: 10){
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.appGreen)
                            Image(systemName: "square.text.square.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.appYellow)
                        }
                    }
                    
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(.appBlack)
                        .opacity(0.5)
                    
                }
            }
            .navLinkModifier()
        }
    }
}

struct YourChartsNavLink: View {
    @ObservedObject private var dataService = DataService.shared
    @State private var isLoading: Bool = true
    @State private var loadingSuccess:Bool = false
    @State private var recentMoods: [(mood: String, intensity: Int)]?
    @State private var totalMoodScore: Int = 0
    
    var body: some View {
        NavigationLink{
            YourMoodsChartsView()
        } label: {
            
            HStack(alignment: .top) {
                if loadingSuccess {
                    
                    VStack(alignment: .leading) {
                        Text("recent moods")
                            .fontWeight(.bold)
                            .foregroundStyle(.appBlack.opacity(0.5))
                        
                        if recentMoods?.count ?? 0 > 0 {
                            if let recentMoodData = recentMoods{
                                HStack{
                                    OverflowLayout {
                                        ForEach(0...recentMoodData.count-1, id:\.self) { index in
                                            HStack{
                                                Circle()
                                                    .fill(Mood(name: recentMoodData[index].mood, emotions: []).getColor())
                                                    .frame(width: 5)
                                                Text(recentMoodData[index].mood)
                                                    .font(.caption)
                                                    .foregroundStyle(.appBlack)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.top, 7)
                            }
                        } else {
                            Text("charts will be availble after you log your mood at least once")
                                .padding(.vertical)
                                .foregroundStyle(.appBlack)
                                .multilineTextAlignment(.leading)
                        }
                        
                    }
                    Spacer()
                    if recentMoods?.count ?? 0 > 0 {
                        Chart {
                            if let recentMoodData = recentMoods {
                                ForEach(recentMoodData.prefix(4), id: \.mood) { data in
                                    SectorMark(angle: .value("mood", (data.intensity*100 / totalMoodScore)), innerRadius: .ratio(0.618), angularInset: 1.5)
                                        .foregroundStyle(Mood(name: data.mood, emotions: []).getColor())
                                        .cornerRadius(5)
                                }
                            }
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70)
                    }
                    
                }
                else {
                    VStack(alignment: .leading){
                        Text("recent moods")
                            .fontWeight(.bold)
                            .foregroundStyle(.appBlack.opacity(0.5))
                        //                                    Spacer()
                    }
                    Spacer()
                    Chart {
                        
                        SectorMark(angle: .value("mood", 1),
                                   innerRadius: .ratio(0.618),
                                   angularInset: 1.5)
                        .foregroundStyle(.appPurple)
                        .cornerRadius(5)
                        
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 70)
                }
            }
            .navLinkModifier()
        }
        .onChange(of: dataService.recentMoodPosts, initial: true){
            Task {
                do {
                    totalMoodScore = 0
                    loadingSuccess = false
                    isLoading = true
                    
                    if let moodPosts = dataService.recentMoodPosts {
                        let ag = AnalyticsGenerator()
                        let tmp = ag.aggregateMoodIntensityByDate(moodPosts: moodPosts)
                        recentMoods = ag.aggregateMoodIntensityTotals(moodData: tmp)
                        
                        for mood in recentMoods?.prefix(4) ?? [] {
                            totalMoodScore += mood.intensity
                        }
                        
                        if totalMoodScore == 0 {
                            totalMoodScore = 1
                        }
                        
                        withAnimation(.easeInOut){loadingSuccess = true}
                    } else {
                        
                        withAnimation(.easeInOut){loadingSuccess = false}
                    }
                }
                withAnimation(.easeInOut){isLoading = false}
            }
        }
        
    }
}

struct NotableMomentsNavLink: View {
    var body: some View {
        NavigationLink{
            NotableMomentsView()
        } label: {
            HStack(alignment: .top) {
                VStack(alignment: .leading){
                    
                    Text("notable moments")
                        .fontWeight(.bold)
                        .foregroundStyle(.appBlack.opacity(0.5))
                    
                    
                    Text("keep track of significant moments")
                        .padding(.top, 7)
                        .foregroundStyle(.appBlack)
                }
                
            }
            .navLinkModifier()
        }
    }
}

struct YourMoodView: View {
    @EnvironmentObject var dataService : DataService
    
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    VStack {
                        HStack {
                            Text("log your mood")
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.75))
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .background(.appBlue)
                        
                        LogDailyMoodSuggestionView()
                            .padding()
                    }
                    .background(.appPurple.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 20)
                    
                    
                    YourChartsNavLink()
                    
                    NotableMomentsNavLink()
                    
                    if dataService.userHasLoggedToday{
                        TodaysFeelingsView()
                            .environmentObject(dataService)
                            .navLinkModifier(withChevron: false)
                    }
                    
                    LogHistoryNavLink()
                    
                    TabBarSpaceReservation()
                }
            }
        }
        
                    
                
//                Section {
//                    NavigationLink {
//                        Text("More charts go here too!!")
//                    } label: {
//                        HStack {
//                            VStack{
//                                Text("recent emotions")
//                                    .fontWeight(.bold)
//                                    .foregroundStyle(.appBlack.opacity(0.5))
//                                Spacer()
//                            }
//                            Spacer()
//                            Chart {
//                                BarMark(x: .value("logs", 20), y: .value("mood", "peaceful"))
//                                    .foregroundStyle(.happiness)
//                                    .cornerRadius(4)
//                                    .annotation(position: .leading, alignment: .trailing, spacing: 5, content: {
//                                        Text("peaceful").font(.caption)
//                                    })
//                                
//                                BarMark(x: .value("logs", 14), y: .value("mood", "confident"))
//                                    .foregroundStyle(.happiness)
//                                    .cornerRadius(4)
//                                    .annotation(position: .leading, alignment: .trailing, spacing: 5, content: {
//                                        Text("confident").font(.caption)
//                                    })
//                                
//                                BarMark(x: .value("logs", 12), y: .value("mood", "calm"))
//                                    .foregroundStyle(.neutrality)
//                                    .cornerRadius(4)
//                                    .annotation(position: .leading, alignment: .trailing, spacing: 5, content: {
//                                        Text("calm").font(.caption)
//                                    })
//                                
//                                BarMark(x: .value("logs", 9), y: .value("mood", "annoyed"))
//                                    .foregroundStyle(.anger)
//                                    .cornerRadius(4)
//                                    .annotation(position: .leading, alignment: .trailing, spacing: 5, content: {
//                                        Text("annoyed").font(.caption)
//                                    })
//                            }
//                            //                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 130, height: 70)
//                            .chartYAxis(.hidden)
//                            .chartXAxis(.hidden)
//                        }
//                    }
//                }
//                .modifier(ListRowBackgroundModifer())
                
        
        
    }
}

#Preview {
    YourMoodView()
        .environmentObject(DataService())
}
