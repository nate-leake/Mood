//
//  ObjectiveAdderView.swift
//  Mood
//
//  Created by Nate Leake on 4/13/25.
//

import SwiftUI

struct ObjectiveAdderView: View {
    @EnvironmentObject var dataService: DataService
    @Environment(\.dismiss) var dismiss
    @State var givenTitle: String = ""
    @State var givenDescription: String = ""
    @State var givenColor: Color = .appGreen
    @State var isCompleted: Bool = false
    @State var isNamed: Bool = false
    @State var hasDescrption: Bool = false
    
    var body: some View {
        VStack {
            
            ObjectivesBuilderView(givenTitle: $givenTitle, givenDescription: $givenDescription, givenColor: $givenColor, isCompleted: $isCompleted, isNamed: $isNamed, hasDescrption: $hasDescrption)
            
            Button {
                let newObjective = UnsecureObjective(title: givenTitle, description: givenDescription, color: givenColor)
                Task {
                    try await dataService.uploadObjective(objective: newObjective)
                }
                dismiss()
            } label: {
                Text("create & exit")
            }
            .frame(maxWidth: .infinity)
            .font(.subheadline)
            .padding(12)
            .background(
                isNamed ? .appPurple : .appPurple.opacity(0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            .foregroundStyle(.white)
        }
        .navigationTitle("create an objective")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ObjectiveAdderView()
}
