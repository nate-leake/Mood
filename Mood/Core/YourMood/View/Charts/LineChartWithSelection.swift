//
//  RecentMoodsChart.swift
//  Mood
//
//  Created by Nate Leake on 9/4/24.
//

import SwiftUI
import Charts

enum ViewingDataType: String {
    case context = "context"
    case mood = "mood"
}

extension Binding {
    // Helper initializer for creating a Binding with a default value when the optional is nil
    init(_ source: Binding<Value?>, default defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}

struct LineChartWithSelection: View {
    @State var moodPosts: [MoodPost]
    let viewingDataType: ViewingDataType
//    @State var operationalData
    
    @State var currentSelection: String?
    let prompt: String = "select"
    
    @State var options: [String] = []
    
    func prepareData(moodPosts: [MoodPost]){
        
    }
    
    
    var body: some View {
        ZStack {
            Chart {
                ForEach(moodPosts) { post in
                    ForEach(post.data, id: \.self) { pair in
                        
                        // Check the viewingDataType here
                        if viewingDataType == .context {
                            // Unwrap currentSelection before comparison
                            if let unwrappedString = currentSelection {
                                if pair.context == unwrappedString {
                                    LineMark(
                                        x: .value("date", post.timestamp, unit: .day),
                                        y: .value("intensity", pair.weight.rawValue)
                                    )
                                    .foregroundStyle(.appPurple)
                                }
                            }
                        }
                        
                        
                        else if viewingDataType == .mood {
                            // THIS NEEDS TO BE UPDATED TO DISPLAY AGGRAGATE DATA. 
                            // Unwrap currentSelection before comparison
                            if let unwrappedString = currentSelection {
                                if Emotion(name: pair.emotions[0]).getParentMood()?.name == unwrappedString {
                                    LineMark(
                                        x: .value("date", post.timestamp, unit: .day),
                                        y: .value("intensity", pair.weight.rawValue)
                                    )
                                    .foregroundStyle(.appPurple)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 70)
            
            VStack {
                DropDownView(
                    title: viewingDataType.rawValue,
                    prompt: prompt,
                    options: options,
                    selection: $currentSelection
                )
                .padding(.horizontal)
                .zIndex(1)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear(
                perform: {
                    if viewingDataType == .context {
                        options = ["family", "finances", "health", "identity", "politics", "weather", "work"]
                    } else if viewingDataType == .mood {
                        options = Mood.allMoodNames
                    }
                }
            )
        }
    }
}

#Preview {
    LineChartWithSelection(
        moodPosts: MoodPost.MOCK_DATA,
        viewingDataType: .mood
    )
}
