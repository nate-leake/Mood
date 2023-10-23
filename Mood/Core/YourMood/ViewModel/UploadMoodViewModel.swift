//
//  UploadMoodViewModel.swift
//  Mood
//
//  Created by Nate Leake on 10/9/23.
//

import Foundation
import SwiftUI
import Firebase

class UploadMoodViewModel: ObservableObject {
    @Published var dailyData: DailyData = DailyData(date: Date(), pairs: [])
}
