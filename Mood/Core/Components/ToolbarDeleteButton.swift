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
                    .tint(.appRed)
            }
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

#Preview {
    var dm = "this will delete if you continue"
    
    ToolbarDeleteButton(deleteMessage: dm) {
        print("DELETE ITEM!")
    }
}
