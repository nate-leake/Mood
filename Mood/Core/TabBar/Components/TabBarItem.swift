//
//  TabBarItem.swift
//  Mood
//
//  Created by Nate Leake on 5/16/25.
//

import Foundation
import SwiftUI

//struct TabBarItem: Hashable {
//    let iconName: String
//    let title: String
//    let color: Color
//}

enum TabBarItem: Hashable {
    case mood, tools, profile
    
    var iconName: String {
        switch self {
        case .mood: return "brain.fill"
        case .tools: return "wrench.and.screwdriver.fill"
        case .profile: return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .mood: return "mood"
        case .tools: return "tools & objectives"
        case .profile: return "profile"
        }
    }
    
    var color: Color {
        switch self {
        case .mood: return .appPurple
        case .tools: return .appPurple
        case .profile: return .appPurple
        }
    }
}
