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
    @State var pleasureSelection: PleasureScale = .uncertainty
    
    @State var hasName: Bool = false
    @State var hasDescription: Bool = false
    
    
    var body: some View {
        VStack {
            BuildNotableMomentView(title: $title, description: $description, date: $date, pleasureSelection: $pleasureSelection)
                .onChange(of: title) { old, new in
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
                .onChange(of: description) { old, new in
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
            print("AddNotableMomentView: hasName and hasDescription: \(hasName), \(hasDescription). OR: \(hasName || hasDescription). NOT OR \(!hasName || !hasDescription)")
                let newMoment: UnsecureNotableMoment = UnsecureNotableMoment(title: title, description: description, date: date, pleasureSelection: pleasureSelection)
                Task {
                    try await dataService.uploadMoment(notableMoment: newMoment)
                }
                dismiss()
            } label: {
                Text("create & exit")
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
            .disabled(!hasName || !hasDescription)
            
        }
        .navigationTitle("add a moment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddNotableMomentView()
        .environmentObject(DataService.shared)
}
