//
//  GlobalMoodViewWrapper.swift
//  Mood
//
//  Created by Nate Leake on 10/23/23.
//

import SwiftUI

struct GlobalMoodViewWrapper: View {
    @EnvironmentObject var dataService: DataService
    
    var body: some View {
        if dataService.userHasLoggedToday{
            GlobalMoodView()
        } else {
            GlobalMoodLockedView(logWindowOpen: dataService.logWindowOpen)
        }
    }
}

#Preview {
    GlobalMoodViewWrapper()
}
