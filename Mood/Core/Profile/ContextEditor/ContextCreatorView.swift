//
//  ContextCreatorView.swift
//  Mood
//
//  Created by Nate Leake on 10/20/24.
//

import SwiftUI
import SymbolPicker

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

struct ContextCreatorView: View {
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var color: Color = .appPurple
    @State var icon: String = "brain.fill"
    
    @State var showingPicker = false
    @State var isNamed = false
    @State var errorMsg:String = ""
    
    var body: some View {
        VStack{
            Spacer()
            ContextPreviewTile(name: $name, color: $color, iconName: $icon)
                .padding(.vertical)
            
            TextField("name", text: $name)
                .modifier(TextFieldModifier(backgroundColor: .appPurple.opacity(0.25)))
                .padding(.vertical)
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
            
            ColorPicker("pick a color", selection: $color, supportsOpacity: false)
                .padding(.horizontal, 24)
                .padding(.bottom)
            
            Button {
                showingPicker = true
            } label: {
                Text("choose an icon")
            }
            .modifier(TextFieldModifier(foregroundColor: .white, backgroundColor: .appPurple))
            .padding(.bottom)
            
            Spacer()
            
            Button {
                if name.count > 0 {
                    Task {
                        do {
                            let res = try await DataService.shared.uploadContext(context: Context(name: name, iconName: icon, colorHex: color.toHex() ?? "#9BA0FA"))
                            
                            print(res)
                            switch res {
                            case .success(let success):
                                if success {
                                    dismiss()
                                }
                            case .failure(let error):
                                errorMsg = error.localizedDescription
                            }
                        }
                    }
                }
            } label: {
                Text("save")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
            }
            .modifier(TextFieldModifier(foregroundColor: .white, backgroundColor: isNamed ? .appPurple : .appPurple.opacity(0.5)))

        }
        .sheet(isPresented: $showingPicker){
            SymbolPicker(symbol: $icon)
        }
        .navigationTitle("create a context")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContextCreatorView()
}
