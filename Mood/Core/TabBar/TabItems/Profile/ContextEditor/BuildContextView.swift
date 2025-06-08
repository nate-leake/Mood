//
//  BuildContextView.swift
//  Mood
//
//  Created by Nate Leake on 5/17/25.
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
            Text(name.count != 0 ? name : "give it a name")
                .padding(.bottom)
                .multilineTextAlignment(.leading)
        }
        .foregroundStyle(color.isLight() ? .black : .white)
        .frame(width: frameSize, height: frameSize)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct BuildContextView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var name: String
    @Binding var color: Color
    @Binding var icon: String
    @Binding var isHidden: Bool

    @State var showingPicker = false
    @State var isNamed = false
    @State var errorMsg: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            ContextPreviewTile(name: $name, color: $color, iconName: $icon)
            Spacer()
            
            HStack {
                TextField("name", text: $name)
                    .padding(12)
                    .background(.appPurple.opacity(0.25))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.leading, 24)
                    .foregroundStyle(.appBlack)
                
                    .textInputAutocapitalization(.never)
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
                    showingPicker = true
                } label: {
                    Text("choose an icon")
                }
                .padding(12)
                .background(.appPurple)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.trailing, 24)
                .foregroundStyle(.white)
                
            }
            .font(.subheadline)
            .padding(.vertical)
            
            ColorPicker(
                "pick a color", selection: $color, supportsOpacity: false
            )
            .padding(.horizontal, 24)
            .padding(.bottom)
            
            Toggle("hidden", isOn: $isHidden)
                .padding(.horizontal, 24)
                .tint(.appPurple)
                .padding(.bottom, 30)
        }
        .sheet(isPresented: $showingPicker) {
            SymbolPicker(symbol: $icon)
        }
        .withTabBarVisibilityController()
    }
}

#Preview {
    @Previewable @State var name: String = "hands!"
    @Previewable @State var color: Color = .appGreen
    @Previewable @State var icon: String = "hand.raised.fill"
    @Previewable @State var isHidden: Bool = false
    BuildContextView(name: $name, color: $color, icon: $icon, isHidden: $isHidden)
}
