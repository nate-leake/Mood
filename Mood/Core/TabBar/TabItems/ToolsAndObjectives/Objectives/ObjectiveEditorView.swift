//
//  ObjectiveEditorView.swift
//  Mood
//
//  Created by Nate Leake on 4/13/25.
//

import SwiftUI

struct ObjectiveEditorView: View {
    @EnvironmentObject var dataService: DataService
    @Environment(\.dismiss) var dismiss
    var editing: UnsecureObjective
    @State private var isNamed: Bool = true
    @State private var hasDescrption: Bool = true
    @State private var isShowingDeleteConfirmation = false
    @ObservedObject private var objective: UnsecureObjective
    
    init(editing: UnsecureObjective) {
        self.editing = editing
        self.objective = UnsecureObjective(title: editing.title, description: editing.description, color: editing.color)
        objective.id = editing.id
        objective.isCompleted = editing.isCompleted
    }
    
    var body: some View {
        
        VStack {
            
            ObjectivesBuilderView(givenTitle: $objective.title, givenDescription: $objective.description, givenColor: $objective.color, isCompleted: $objective.isCompleted, isNamed: $isNamed, hasDescrption: $hasDescrption)
            
            Button {
                withAnimation {
                    objective.isCompleted.toggle()
                }
            } label: {
                Text(objective.isCompleted ? "mark incomplete" : "mark complete")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .padding(12)
                    .background(.appGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 10)
                    .foregroundStyle(.white)
            }
            
            
            Button {
                Task {
                    try await dataService.updateObjective(to: objective)
                }
                dismiss()
            } label: {
                Text("save & exit")
                    .bold()
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
            .disabled(!isNamed)
            
        }
        .navigationTitle("editing \"\(editing.title)\"")
        .navigationBarTitleDisplayMode(.inline)
        .withToolbarDeleteButton(deleteMessage: "this action will permenantly erase this objective. this action cannot be undone."){
            Task {
                print("delete")
                let _ = try await DataService.shared.deleteObjective(objectiveID: objective.id)
                dismiss()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var obj = UnsecureObjective(title: "testing", description: "this is a test objective", color: .pink)
    ObjectiveEditorView(editing: obj)
}
