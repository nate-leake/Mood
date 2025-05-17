//
//  AddContextView.swift
//  Mood
//
//  Created by Nate Leake on 5/17/25.
//

import SwiftUI

struct AddContextView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = ""
    @State var color: Color = .appPurple
    @State var icon: String = "brain.fill"
    @State var isHidden: Bool = false
    
    @State var isNamed = false
    @State var isSaved = false
    @State var errorMsg: String = ""
    
    var body: some View {
        VStack {
            BuildContextView(name: $name, color: $color, icon: $icon, isHidden: $isHidden)
                .onChange(of: name) { old, new in
                    if new.count > 0 && old.count == 0 {
                        withAnimation(.easeInOut) {
                            isNamed = true
                        }
                    } else if new.count == 0 && old.count > 0 {
                        withAnimation(.easeInOut) {
                            isNamed = false
                        }
                    }
                }
            
            
            Button {
                if name.count > 0 {
                    Task {
                        do {
                            let newContext = UnsecureContext(
                                name: name, iconName: icon,
                                colorHex: color.toHex() ?? "#9BA0FA")
                            
                            let res = try await DataService.shared.uploadContext(context: newContext)
                            
                            print(res)
                            switch res {
                            case .success(let success):
                                if success {
                                    withAnimation(.easeInOut) {
                                        errorMsg = ""
                                        isSaved = true
                                    }
                                    dismiss()
                                }
                            case .failure(let error):
                                withAnimation(.easeInOut) {
                                    errorMsg = error.localizedDescription
                                    isSaved = false
                                }
                            }
                            
                        }
                    }
                }
            } label: {
                HStack {
                    Text("create & exit")
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
                isNamed
                ? (isSaved ? .appGreen : .appPurple)
                : .appPurple.opacity(0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            .foregroundStyle(.white)
        }
        .navigationTitle("create a context")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddContextView()
}
