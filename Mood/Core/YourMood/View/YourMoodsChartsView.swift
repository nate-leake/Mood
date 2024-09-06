//
//  YourMoodsChartsView.swift
//  Mood
//
//  Created by Nate Leake on 9/5/24.
//

import SwiftUI

struct YourMoodsChartsView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                
                LineChartWithSelection(moodPosts: MoodPost.MOCK_DATA, viewingDataType: .mood, height: 250)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
 
            }
        }
    }
}

#Preview {
    YourMoodsChartsView()
}
