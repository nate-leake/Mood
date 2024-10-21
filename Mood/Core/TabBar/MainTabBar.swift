//
//  MainTabBar.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct MainTabBar: View {
    // selection var forces the default selected tab to match the tag assigned to that tabItem
    @State private var selection = 2
    @EnvironmentObject var dataService: DataService
    let user: User
    
    var body: some View {
        TabView(selection:$selection){
//            GlobalMoodViewWrapper()
//                .environmentObject(dataService)
//                .tabItem {
//                    Image(systemName: "globe.americas")
//                }
//                .tag(1)
            
            YourMoodView()
                .environmentObject(dataService)
                .tabItem {
                    Image(systemName: "brain")
                }
                .tag(2)
            
            ProfileView(user: user)
                .environmentObject(dataService)
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabBar(user: User.MOCK_USERS[0])
        .environmentObject(DataService())
}
