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
    var spaceCompensation: Bool
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, isVisible: Bool = true, withSpaceCompensation: Bool = true, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
        self.isVisible = isVisible
        self.spaceCompensation = withSpaceCompensation
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

struct TabBarSpaceReservation: View {
    
    var body: some View {
        
        Rectangle()
            .fill(.clear)
            .opacity(0.0)
            .ignoresSafeArea(edges: .bottom)
            .frame(height: 60)
            .transition(.scale.combined(with: .opacity).combined(with: .blurReplace).combined(with: .move(edge: .bottom)) )
            .zIndex(1)
        
    }
}

struct TabBarSpacingModifier: ViewModifier {
    let reservingSpace: Bool
    @ObservedObject private var tabBarManager: TabBarManager = TabBarManager.shared
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            
            TabBarSpaceReservation()
        }
    }
}

extension View {
    func reservingTabBarSpace(reservingSpace: Bool = true) -> some View {
        modifier(TabBarSpacingModifier(reservingSpace: reservingSpace))
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
