//
//  BuildNotableMomentView.swift
//  Mood
//
//  Created by Nate Leake on 4/28/25.
//

import SwiftUI

enum PleasureScale: String, Codable {
    case displeasure, uncertainty, pleasure
}

enum Field: Hashable {
    case title
    case description
}

struct BuildNotableMomentView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var date: Date
    @Binding var pleasureSelection: PleasureScale
    
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack (spacing: 20) {
            NotableMomentTileView(title: title == "" ? "title" : title, description: description == "" ? "description" : description, date: date, color: Color(pleasureSelection.rawValue.capitalized))
            
            TextField("title", text: $title)
                .focused($focusField, equals: .title)
                .padding(12)
                .background(.appPurple.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 24)
                .foregroundStyle(.appBlack)
                .textInputAutocapitalization(.never)
            
            TextField("description", text: $description, axis: .vertical)
                .focused($focusField, equals: .description)
                .padding(12)
                .background(.appPurple.opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 24)
                .foregroundStyle(.appBlack)
                .lineLimit(5...10)
                .textInputAutocapitalization(.never)
            
            VStack (alignment: .leading) {
                Text("what did you feel?")
                    .padding(.top, 12)
                    .padding(.leading, 12)
                
                HStack(/*spacing: 10*/) {
                    Spacer()
                    
                    VStack {
                        WavyCircle(waves: 5, amplitude: 10)
                            .frame(width: 40, height: 40)
                        Text("pleasure")
                            .bold()
                            .font(.callout)
                            .opacity(0.8)
                            .padding(.bottom, -4)
                        
                    }
                    .foregroundStyle(.pleasure.optimalForegroundColor())
                    .padding(10)
                    .frame(minWidth: 100, maxWidth: 150)
                    .background(.pleasure)
                    .foregroundStyle(.appGreen.optimalForegroundColor())
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .opacity(pleasureSelection == .pleasure ? 1 : 0.75)
                    .onTapGesture {
                        withAnimation {
                            pleasureSelection = .pleasure
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        WavyCircle(waves: 7, amplitude: 20)
                            .frame(width: 40, height: 40)
                        Text("unsure")
                            .bold()
                            .font(.callout)
                            .opacity(0.8)
                            .padding(.bottom, -4)
                    }
                    .foregroundStyle(.uncertainty.optimalForegroundColor())
                    .padding(10)
                    .frame(minWidth: 75, maxWidth: 100)
                    .background(.uncertainty)
                    .foregroundStyle(.appBlue.optimalForegroundColor())
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .opacity(pleasureSelection == .uncertainty ? 1 : 0.75)
                    .onTapGesture {
                        withAnimation {
                            pleasureSelection = .uncertainty
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        WavyCircle(waves: 10, amplitude: 30)
                            .frame(width: 40, height: 40)
                        Text("displeasure")
                            .bold()
                            .font(.callout)
                            .opacity(0.8)
                            .padding(.bottom, -4)
                    }
                    .foregroundStyle(.displeasure.optimalForegroundColor())
                    .padding(10)
                    .frame(minWidth: 110, maxWidth: 150)
                    .background(.displeasure)
                    .foregroundStyle(.appRed.optimalForegroundColor())
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .opacity(pleasureSelection == .displeasure ? 1 : 0.75)
                    .onTapGesture {
                        withAnimation {
                            pleasureSelection = .displeasure
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity)
            }
            .background(.appPurple.opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            .toolbar {
                  ToolbarItemGroup(placement: .keyboard) {
                     Spacer()
                     Button(focusField == .title ? "Next" : "Done") {
                         if focusField == .title {
                           focusField = .description
                        } else {
                           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                           focusField = nil
                        }
                     }
                  }
               }
            
            VStack (alignment: .leading) {
                Text("when did it happen?")
                
                HStack {
                    Spacer()
                    DatePicker(selection: $date, in:...Date.now/*, displayedComponents: .date*/){ EmptyView() }
                        .tint(.appPurple)
                    //                        .background(.red)
                        .frame(width: 200)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(12)
            .background(.appPurple.opacity(0.25))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
            
            Spacer()
        }
        
        .onAppear {
            TabBarManager.shared.hideTabBar()
        }
        .onDisappear {
            TabBarManager.shared.unhideTabBar()
        }
        
    }
}

#Preview {
    @Previewable @State var title: String = ""
    @Previewable @State var description: String = ""
    @Previewable @State var date: Date = Date.now
    @Previewable @State var pleasureSelection: PleasureScale = .uncertainty
    
    BuildNotableMomentView(title: $title, description: $description, date: $date, pleasureSelection: $pleasureSelection)
}
