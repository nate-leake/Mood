//
//  MainTabBar.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI

enum TabItem {
    case yourMood, toolsAndObjectives, profile
}

class TabBarManager: ObservableObject {
    @Published var tabBarVisibility: Visibility = .visible
    @State var tabSelection: TabItem = .yourMood
    
    static var shared = TabBarManager()
    
    func hideTabBar() {
        withAnimation() {
            self.tabBarVisibility = .hidden
        }
    }
    
    func unhideTabBar() {
        withAnimation() {
            self.tabBarVisibility = .visible
        }
    }
    
    func setTabSelection(to selection: TabItem) {
        withAnimation() {
            self.tabSelection = selection
        }
    }
}

struct MainTabBar: View {
    // selection var forces the default selected tab to match the tag assigned to that tabItem
    @EnvironmentObject var dataService: DataService
    @ObservedObject var tabViewManager: TabBarManager = TabBarManager.shared
    let user: User
    
    var body: some View {
        TabView(selection: $tabViewManager.tabSelection) {
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
                .tag(1)
                .toolbar(tabViewManager.tabBarVisibility, for: .tabBar)
            
            ToolsAndObjectivesView()
                .environmentObject(dataService)
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver.fill")
                }
                .tag(2)
                .toolbar(tabViewManager.tabBarVisibility, for: .tabBar)
            
            ProfileView(user: user)
                .environmentObject(dataService)
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(3)
                .toolbar(tabViewManager.tabBarVisibility, for: .tabBar)
        }
    }
}

#Preview {
    MainTabBar(user: User.MOCK_USERS[0])
        .environmentObject(DataService())
}
