//
//  SegmentedTimePickerView.swift
//  Mood
//
//  Created by Nate Leake on 7/6/25.
//

import SwiftUI

struct SegmentedTimePickerView: View {
    @Binding var viewingDaysBack: Int?
    @AppStorage("chartsViewingDaysBackSelection") private var chartsViewingDaysBack: Int = 14

    init(viewingDaysBack: Binding<Int?> = .constant(nil)) {
        self._viewingDaysBack = viewingDaysBack
    }

    var body: some View {
        let selection = Binding<Int>(
            get: {
                viewingDaysBack ?? chartsViewingDaysBack
            },
            set: { newValue in
                if viewingDaysBack != nil {
                    viewingDaysBack = newValue
                } else {
                    chartsViewingDaysBack = newValue
                }
            }
        )

        Picker("Days back", selection: selection) {
            Text("90 days").tag(90)
            Text("30 days").tag(30)
            Text("2 weeks").tag(14)
            Text("1 week").tag(7)
        }
        .pickerStyle(.segmented)
    }
}

//struct SegmentedTimePickerView: View {
//    @Binding var viewingDaysBackBinding: Int?
//    @AppStorage("chartsViewingDaysBackSelection") var chartsViewingDaysBack: Int = 14
//        
//    init(viewingDaysBackBinding binding: Int? = nil) {
//        self.chartsViewingDaysBack = UserDefaults.standard.integer(forKey: "chartsViewingDaysBackSelection")
//        self.viewingDaysBackBinding = binding
//        
//    }
//    
//    var body: some View {
//        if viewingDaysBackBinding != nil {
//            Picker("days back", selection: $viewingDaysBackBinding) {
//                Text("90 days").tag(90)
//                Text("30 days").tag(30)
//                Text("2 weeks").tag(14)
//                Text("1 week").tag(7)
//            }
//            .pickerStyle(.segmented)
//        } else {
//            Picker("days back", selection: $chartsViewingDaysBack) {
//                Text("90 days").tag(90)
//                Text("30 days").tag(30)
//                Text("2 weeks").tag(14)
//                Text("1 week").tag(7)
//            }
//            .pickerStyle(.segmented)
//        }
//    }
//}

#Preview {
    SegmentedTimePickerView()
}
