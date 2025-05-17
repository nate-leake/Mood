//
//  TabBarVisibilityController.swift
//  Mood
//
//  Created by Nate Leake on 5/14/25.
//

import SwiftUI

struct TabBarVisibilityController: ViewModifier {
    var hideOnAppear: Bool
    var unhideOnDissapear: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if hideOnAppear {
                    TabBarManager.shared.hideTabBar()
                }
            }
            .onDisappear {
                if unhideOnDissapear {
                    TabBarManager.shared.unhideTabBar()
                }
            }
            .animation(.easeInOut, value: TabBarManager.shared.tabBarVisibile)
    }
}

extension View {
    /// Easily allows the TabBar to be hidden using the TabBarManager functions.
    /// - Parameters:
    ///   - hideOnAppear: Indicates weather the TabBar should be hidden when this view appears
    ///   - unhideOnDissapear: Indicates weather the TabBar should be visible when this view dissapears
    /// - Returns: The modified view with a TabBarVisibilityController
    func withTabBarVisibilityController(hideOnAppear: Bool = true, unhideOnDissapear: Bool = true) -> some View {
        self.modifier(TabBarVisibilityController(hideOnAppear: hideOnAppear, unhideOnDissapear: unhideOnDissapear))
    }
}
