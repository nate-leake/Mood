//
//  TabBarItemsPreferenceKey.swift
//  tabbar
//
//  Created by Nate Leake on 5/16/25.
//

import Foundation
import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct TabBarItemViewModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    @ObservedObject private var tabBarManager: TabBarManager = TabBarManager.shared
    
    func body(content: Content) -> some View {
            content
                .opacity(selection == tab ? 1.0 : 0.0)
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}
