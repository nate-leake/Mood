//
//  AddNotableMomentView.swift
//  Mood
//
//  Created by Nate Leake on 4/26/25.
//

import SwiftUI

struct AddNotableMomentView: View {
    @EnvironmentObject var dataService: DataService
    @Environment(\.dismiss) var dismiss
    @State var title: String = ""
    @State var description: String = ""
    @State var date: Date = Date.now
    @State var hasName: Bool = false
    @State var hasDescription: Bool = false
    @State var pleasureSelection: PleasureScale = .uncertainty
    
    var body: some View {
        VStack {
            BuildNotableMomentView(title: $title, description: $description, date: $date, pleasureSelection: $pleasureSelection, hasName: $hasName, hasDescription: $hasDescription)
            
            Button {
                print("should add notable moment in DS now")
                dismiss()
            } label: {
                Text("create & exit")
            }
            .frame(maxWidth: .infinity)
            .font(.subheadline)
            .padding(12)
            .background(
                hasName ? .appPurple : .appPurple.opacity(0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            .foregroundStyle(.white)
        }
        .navigationTitle("add a moment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddNotableMomentView()
        .environmentObject(DataService.shared)
}
