//
//  CustomTabBar.swift
//  Mood
//
//  Created by Nate Leake on 5/16/25.
//

import SwiftUI

struct InternalTabBar: View {
    @Namespace private var namespace
    
    @Binding var selection: TabBarItem
    let tabs: [TabBarItem]
    @State var localSelection: TabBarItem
    
    init(selection: Binding<TabBarItem>, tabs: [TabBarItem]) {
        self._selection = selection
        self.tabs = tabs
        self.localSelection = selection.wrappedValue
    }
    
    var body: some View {
        tabBar
            .onChange(of: selection) { old, new in
                withAnimation(.easeInOut(duration: 0.2)) {
                    localSelection = new
                }
            }
            
    }
}

extension InternalTabBar {
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.title2)
                .padding(.bottom, 2)
            
//            Text(tab.title)
//                .font(.system(size: 10, weight: .semibold, design: .rounded))
//                .frame(maxWidth: 60)
//                .multilineTextAlignment(.center)
            
        }
        .foregroundStyle( localSelection == tab ?  tab.color : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(tab.color.opacity(0.25))
                        .matchedGeometryEffect(id: "background_rect", in: namespace)
                        .frame(maxWidth: 50)
                }
            }
        )
    }
    
    private var tabBar: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .background(.clear) // this expands the view to the max size without changing its appearance. it makes it clickable in as large a space as possible
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        
        .padding(6)
        .background(.regularMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 30)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.thinMaterial, lineWidth: 2)
        )
        .padding(.horizontal)
    }
    
    private func switchToTab(tab: TabBarItem) {
        withAnimation(.easeInOut(duration: 0.15)){
            selection = tab
        }
    }
}


#Preview {
    let tabs: [TabBarItem] = [
        .mood, .tools, .profile
    ]
    
    Color.orange.ignoresSafeArea()
    
    Spacer()
    InternalTabBar(selection: .constant(tabs.first!), tabs: tabs)
}
