//
//  ToolbarDeleteButton.swift
//  Mood
//
//  Created by Nate Leake on 5/6/25.
//

import SwiftUI

struct ToolbarDeleteButton: View {
    @State private var isShowingDeleteConfirmation = false
    @State private var hapticDeleteTrigger: Bool = false
    let deleteMessage: String
    let deleteAction: () -> Void
    
    var body: some View {
        Button {
            hapticDeleteTrigger.toggle()
            isShowingDeleteConfirmation = true
        } label: {
            HStack {
                Image(systemName: "trash")
                    .font(.headline)
            }
            .foregroundStyle(.appRed)
        }
        .alert(deleteMessage, isPresented: $isShowingDeleteConfirmation) {
            Button("cancel", role: .cancel) {}
            
            Button("delete", role: .destructive) {
                deleteAction()
            }
            
        }
        .sensoryFeedback(.warning, trigger: hapticDeleteTrigger)
    }
}

struct WithToolbarDeleteButton: ViewModifier {
    let deleteMessage: String
    let deleteAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    ToolbarDeleteButton(deleteMessage: deleteMessage) {
                        deleteAction()
                    }
                }
            }
    }
}


extension View{
    func withToolbarDeleteButton(deleteMessage: String, deleteAction: @escaping () -> Void) -> some View {
        self.modifier(WithToolbarDeleteButton(deleteMessage: deleteMessage, deleteAction: deleteAction))
    }
}

#Preview {
    ToolbarDeleteButton(deleteMessage: "this will delete if you continue") {
        print("DELETE ITEM!")
    }
}

#Preview("Delete in nav bar") {
    NavigationStack {
        VStack {
            Text("delete something!")
        }
        .navigationTitle("deleting preview")
        .navigationBarTitleDisplayMode(.inline)
        .withToolbarDeleteButton(deleteMessage: "this action will permenantly erase this context from all entries. if you wish to keep this data but no longer see the context, please hide the context instead. this action cannot be undone.") {
            Task {
                
            }
        }
    }
}
