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
    @Published var tabBarVisibile: Bool = true
    
    static var shared = TabBarManager()
    
    func hideTabBar() {
        withAnimation(.easeInOut(duration: 0.4)) {
            self.tabBarVisibile = false
        }
    }
    
    func unhideTabBar() {
        withAnimation(.easeInOut(duration: 0.4)) {
            self.tabBarVisibile = true
        }
    }
}

struct MainTabBar: View {
    // selection var forces the default selected tab to match the tag assigned to that tabItem
    @ObservedObject var dataService: DataService = DataService.shared
    @State var selected: TabBarItem = .mood
    @ObservedObject var tabViewManager: TabBarManager = TabBarManager.shared
    let user: User
    
    var body: some View {
        TabBar(selection: $selected, isVisible: tabViewManager.tabBarVisibile) {
//            GlobalMoodViewWrapper()
//                .environmentObject(dataService)
//                .tabItem {
//                    Image(systemName: "globe.americas")
//                }
//                .tag(1)
            
            YourMoodView()
                .environmentObject(dataService)
                .tabBarItem(tab: .mood, selection: $selected)
            
            ToolsAndObjectivesView()
                .environmentObject(dataService)
                .tabBarItem(tab: .tools, selection: $selected)
            
            ProfileView(user: user)
                .environmentObject(dataService)
                .tabBarItem(tab: .profile, selection: $selected)
            
        }
        
    }
}

#Preview {
    @Previewable @StateObject var dataService: DataService = DataService.shared
    MainTabBar(user: User.MOCK_USERS[0])
        .environmentObject(dataService)
        .onAppear {
            dataService.loadedContexts = UnsecureContext.defaultContexts
            dataService.loadedObjectives = UnsecureObjective.MOCK_DATA
            dataService.loadedMoments = UnsecureNotableMoment.MOCK_DATA
        }
}
