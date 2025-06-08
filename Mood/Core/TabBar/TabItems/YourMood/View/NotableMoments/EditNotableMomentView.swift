//
//  EditNotableMomentView.swift
//  Mood
//
//  Created by Nate Leake on 5/2/25.
//

import SwiftUI

struct EditNotableMomentView: View {
    @EnvironmentObject var dataService: DataService
    @Environment(\.dismiss) var dismiss
        
    @State var hasName: Bool = true
    @State var hasDescription: Bool = true
    var editing: UnsecureNotableMoment
    @ObservedObject private var moment: UnsecureNotableMoment
    
    init(editing: UnsecureNotableMoment) {
        self.editing = editing
        self.moment = UnsecureNotableMoment(id: editing.id, title: editing.title, description: editing.description, date: editing.date, pleasureSelection: editing.pleasureSelection)
    }
    
    var body: some View {
        VStack {
        BuildNotableMomentView(title: $moment.title, description: $moment.description, date: $moment.date, pleasureSelection: $moment.pleasureSelection)
                .onChange(of: moment.title) { old, new in
                    if new.count > 0 && old.count == 0 {
                        withAnimation(.easeInOut) {
                            hasName = true
                        }
                    } else if new.count == 0 && old.count > 0 {
                        withAnimation(.easeInOut) {
                            hasName = false
                        }
                    }
                }
                .onChange(of: moment.description) { old, new in
                    if new.count > 0 && old.count == 0 {
                        withAnimation(.easeInOut) {
                            hasDescription = true
                        }
                    } else if new.count == 0 && old.count > 0 {
                        withAnimation(.easeInOut) {
                            hasDescription = false
                        }
                    }
                }
            
            Button {
                Task {
                    try await DataService.shared.updateMoment(to: moment)
                }
                dismiss()
            } label: {
                Text("save & exit")
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .padding(12)
                    .background(
                        hasName && hasDescription ? .appPurple : .appPurple.opacity(0.5)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal, 24)
                    .foregroundStyle(.white)
            }
            .disabled(!hasName && !hasDescription)
            
        }
        .navigationTitle("edit this moment")
        .navigationBarTitleDisplayMode(.inline)
        .withToolbarDeleteButton(deleteMessage: "this action will permenantly erase this notable moment. this action cannot be undone.") {
            Task {
                let _ = try await DataService.shared.deleteMoment(notableMomentID: moment.id)
                dismiss()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var notableMoment: UnsecureNotableMoment = UnsecureNotableMoment(title: "new dog", description: "I got a new dog today!", date: Date.now, pleasureSelection: .pleasure)
    EditNotableMomentView(editing: notableMoment)
}
