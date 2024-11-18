//
//  ContextCreatorView.swift
//  Mood
//
//  Created by Nate Leake on 10/20/24.
//

import SwiftUI
import SymbolPicker

enum ContextBuildingMode: Int {
    case editing
    case creating
}

struct ContextPreviewTile: View {
    @Binding var name: String
    @Binding var color: Color
    @Binding var iconName: String
    
    var frameSize: CGFloat = 150
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: iconName)
                .font(.system(size: 50))
                .opacity(0.5)
                .padding(.top)
            Spacer()
            Text(name.count != 0 ? name:"give it a name")
                .padding(.bottom)
                .multilineTextAlignment(.leading)
        }
        .foregroundStyle(color.isLight() ? .black : .white)
        .frame(width: frameSize, height: frameSize)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ContextBuilderView: View {
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var color: Color = .appPurple
    @State var icon: String = "brain.fill"
    @State var isHidden: Bool = false
    
    @State var showingPicker = false
    @State var isNamed = false
    @State var errorMsg:String = ""
    
    @State var buildingMode: ContextBuildingMode
    
    @State var editingContext: UnsecureContext?
    @State var isSaved = false
    
    init(editingContext: UnsecureContext? = nil) {
        if let context = editingContext {
            self.editingContext = context
            self.name = context.name
            self.color = context.color
            self.icon = context.iconName
            self.isHidden = context.isHidden
            
            self.isNamed = true
            buildingMode = .editing
        } else {
            buildingMode = .creating
        }
    }
    
    var body: some View {
        ZStack{
            
            if buildingMode == .editing {
                VStack{
                    HStack {
                        Spacer()
                        Button{
                            Task {
                                if let context = editingContext {
                                    print("delete")
                                    try await DataService.shared.deleteContext(context: context)
                                } else {
                                    print("could not assign editingContext to context")
                                }
                            }
                            
                        } label: {
                            HStack{
                                Image(systemName: "trash")
                                Text("delete")
                            }
                            .padding(5)
                            .font(.headline)
                        }
                        .tint(.white)
                        .background(.appRed)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding()
                    }
                    Spacer()
                }
            }
            
            VStack{
                
                Spacer()
                if errorMsg.count > 0 {
                    Text(errorMsg)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(7)
                        .background(.appRed)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                }
                
                ContextPreviewTile(name: $name, color: $color, iconName: $icon)
                    .padding(.vertical, 3)
                if buildingMode == .editing {
                    Text("\(editingContext?.associatedPostIDs.count ?? 0) posts associated with this context")
                        .foregroundStyle(.appBlack.opacity(0.7))
                        .font(.callout)
//                        .padding(.top, 3)
                }
                
                Spacer()
                
                HStack{
                    TextField("name", text: $name)
                        .padding(12)
                        .background(.appPurple.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.leading, 24)
                        .foregroundStyle(.appBlack)
                    
                        .textInputAutocapitalization(.never)
                        .onChange(of: name) { old, new in
                            if new.count > 0 && old.count == 0{
                                withAnimation(.easeInOut){
                                    isNamed = true
                                }
                            } else if new.count == 0 && old.count > 0 {
                                withAnimation(.easeInOut){
                                    isNamed = false
                                }
                            }
                        }
                    
                    Button {
                        showingPicker = true
                    } label: {
                        Text(buildingMode == .creating ? "choose an icon" : "change icon")
                    }
                    .padding(12)
                    .background(.appPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.trailing, 24)
                    .foregroundStyle(.white)
                    
                }
                .font(.subheadline)
                .padding(.vertical)
                
                ColorPicker("pick a color", selection: $color, supportsOpacity: false)
                    .padding(.horizontal, 24)
                    .padding(.bottom)
                
                
                Toggle("hidden", isOn: $isHidden)
                    .padding(.horizontal, 24)
                    .tint(.appPurple)
                    .padding(.bottom, 30)
                
                
                Button {
                    if name.count > 0 {
                        Task {
                            do {
                                if buildingMode == .creating{
                                    let newContext = UnsecureContext(name: name, iconName: icon, colorHex: color.toHex() ?? "#9BA0FA")
                                    let res = try await DataService.shared.uploadContext(context: newContext)
                                    print(res)
                                    switch res {
                                    case .success(let success):
                                        if success {
                                            withAnimation(.easeInOut){
                                                errorMsg = ""
                                                isSaved = true
                                            }
                                            dismiss()
                                        }
                                    case .failure(let error):
                                        withAnimation(.easeInOut){
                                            errorMsg = error.localizedDescription
                                            isSaved = false
                                        }
                                    }
                                } else {
                                    let newContext = UnsecureContext(
                                        id: editingContext!.id,
                                        name: self.name,
                                        iconName: self.icon,
                                        color: self.color,
                                        isHidden: self.isHidden,
                                        associatedPostIDs: editingContext!.associatedPostIDs
                                    )
                                    
                                    try await DataService.shared.updateContext(to: newContext)
                                    withAnimation(.easeInOut){
                                        errorMsg = ""
                                        isSaved = true
                                    }
                                    dismiss()
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(buildingMode == .creating ? "create & exit" : "save & exit")
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
                .background(isNamed ? (isSaved ? .appGreen : .appPurple) : .appPurple.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 24)
                .foregroundStyle(.white)
                
            }
        }
        .sheet(isPresented: $showingPicker){
            SymbolPicker(symbol: $icon)
        }
        .navigationTitle(buildingMode == .creating ? "create a context" : "editing \"\(editingContext?.name ?? "")\"")
        .navigationBarTitleDisplayMode(.inline)
            
    }
}

#Preview {
    ContextBuilderView(editingContext: UnsecureContext.defaultContexts[0])
}
