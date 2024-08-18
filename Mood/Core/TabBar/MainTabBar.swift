//
//  MainTabBar.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct MainTabBar: View {
    @State private var selection = 2
    @EnvironmentObject var dailyDataService: DailyDataService
    let user: User
    
    var body: some View {
        TabView(selection:$selection){
            GlobalMoodViewWrapper()
                .environmentObject(dailyDataService)
                .tabItem {
                    Image(systemName: "globe.americas")
                }
                .tag(1)
            
            YourMoodView()
                .environmentObject(dailyDataService)
                .tabItem {
                    Image(systemName: "brain")
                }
                .tag(2)
            
            ProfileView(user: user)
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabBar(user: User.MOCK_USERS[0])
        .environmentObject(DailyDataService())
}
