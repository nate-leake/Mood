//
//  GlobalMoodViewWrapper.swift
//  Mood
//
//  Created by Nate Leake on 10/23/23.
//

import SwiftUI

struct GlobalMoodViewWrapper: View {
    @EnvironmentObject var dailyDataService: DailyDataService
    
    var body: some View {
        if dailyDataService.userHasLoggedToday{
            GlobalMoodView()
        } else {
            GlobalMoodLockedView()
        }
    }
}

#Preview {
    GlobalMoodViewWrapper()
}
