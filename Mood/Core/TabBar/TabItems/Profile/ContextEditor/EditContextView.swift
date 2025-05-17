//
//  EditContextView.swift
//  Mood
//
//  Created by Nate Leake on 5/17/25.
//

import SwiftUI

struct EditContextView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var hasName: Bool = true
    var editing: UnsecureContext
    @ObservedObject private var context: UnsecureContext
    
    @State var isSaved = false
    @State var errorMsg: String = ""
    
    init(editing: UnsecureContext) {
        self.editing = editing
        self.context = UnsecureContext(
            id: editing.id,
            name: editing.name,
            iconName: editing.iconName,
            color: editing.color,
            isHidden: editing.isHidden,
            associatedPostIDs: editing.associatedPostIDs
        )
    }
    
    var body: some View {
        VStack {
            BuildContextView(name: $context.name, color: $context.color, icon: $context.iconName, isHidden: $context.isHidden)
                .onChange(of: context.name) { old, new in
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
            
            Button {
                if context.name.count > 0 {
                    Task {
                        do {
                                let newContext = UnsecureContext(
                                    id: context.id,
                                    name: context.name,
                                    iconName: context.iconName,
                                    color: context.color,
                                    isHidden: context.isHidden,
                                    associatedPostIDs: context.associatedPostIDs
                                )

                                _ = try await DataService.shared.updateContext(
                                    to: newContext)
                                withAnimation(.easeInOut) {
                                    errorMsg = ""
                                    isSaved = true
                                }
                                dismiss()
                            }
                        
                    }
                }
            } label: {
                HStack {
                    Text("save & exit")
                    .fontWeight(.bold)
                    if isSaved {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .font(.subheadline)
            .padding(12)
            .background(
                hasName
                    ? (isSaved ? .appGreen : .appPurple)
                    : .appPurple.opacity(0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            .foregroundStyle(.white)
        }
        .navigationTitle("edit this context")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                ToolbarDeleteButton(
                    deleteMessage: "this action will permenantly erase this context from all entries. if you wish to keep this data but no longer see the context, please hide the context instead. this action cannot be undone."
                    ) {
                    Task {
                        let _ = try await DataService.shared.deleteContext(context: context)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var context: UnsecureContext = UnsecureContext.defaultContexts[0]
    EditContextView(editing: context)
}
