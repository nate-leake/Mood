//
//  TabBarContainer.swift
//  Mood
//
//  Created by Nate Leake on 5/16/25.
//

import SwiftUI

struct TabBar<Content: View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    var isVisible: Bool
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, isVisible: Bool = true, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
        self.isVisible = isVisible
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea(edges: .bottom)
                .zIndex(0)
            if isVisible {
                InternalTabBar(selection: $selection, tabs: tabs)
                    .transition(.scale.combined(with: .opacity).combined(with: .blurReplace).combined(with: .move(edge: .bottom)) )
                    .zIndex(1)
            }
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

#Preview {
    let tabs: [TabBarItem] = [
        .mood, .tools, .profile
    ]
    
    TabBar(selection: .constant(tabs.first!), isVisible: false) {
        Color.red
    }
}
