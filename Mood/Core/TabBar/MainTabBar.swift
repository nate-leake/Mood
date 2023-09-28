//
//  MainTabBar.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

struct MainTabBar: View {
    let user: User
    var body: some View {
        TabView{
            GlobalMoodView()
                .tabItem {
                    Image(systemName: "globe.americas")
                }
            
            YourMoodView()
                .tabItem {
                    Image(systemName: "brain")
                }
            
            ProfileView(user: user)
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

#Preview {
    MainTabBar(user: User.MOCK_USERS[0])
}
