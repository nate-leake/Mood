//
//  LogDailyMoodViewModel.swift
//  Mood
//
//  Created by Nate Leake on 10/10/23.
//

import Foundation

class LogDailyMoodViewModel: ObservableObject {
    @Published var dailyData: DailyData = DailyData(date: Date(), pairs: [])
}
