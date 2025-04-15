//
//  ToolsAndObjectivesView.swift
//  Mood
//
//  Created by Nate Leake on 3/30/25.
//

import SwiftUI

struct ToolsAndObjectivesView: View {
    @EnvironmentObject var dataService: DataService
    let mainGridLayout = [
        GridItem(.adaptive(minimum:150), spacing: 0),
        GridItem(.adaptive(minimum:150), spacing: 0)
    ]
    
    let spacedHGridLayout = [
        GridItem(.adaptive(minimum: 50), spacing: 0),
        GridItem(.adaptive(minimum: 50), spacing: 0),
        GridItem(.adaptive(minimum: 50), spacing: 0)
    ]
    
    var body: some View {
        NavigationStack {
            
            LazyVGrid(columns: mainGridLayout) {
                
                LazyHGrid(rows: spacedHGridLayout){
                    
                    NavigationLink {
                        ToolsView()
                    } label: {
                        HStack() {
                            Spacer()
                            
                            Image(systemName: "link")
                                .font(.footnote)
                                .bold()
                                .frame(width: 30, height: 30)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text("external resouces")
                                .foregroundStyle(.white)
                                .bold()
                                .font(.caption)
                                .padding(7)
                            
                            Spacer()
                        }
                        .frame(width: 150, height: 50)
                        .background(.appPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Text("")
                        .frame(width: 150, height: 50)
                    
                    Text("")
                        .frame(width: 150, height: 50)
//                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                }
                .frame(width: 150, height: 150)
                
                
                NavigationLink {
                    ObjectivesView()
                } label: {
                    VStack(alignment: .center) {
                        Text("objectives")
                            .foregroundStyle(.black)
                            .bold()
                            .padding(7)
                        Spacer()
                            
                        HStack {
                            WavyCircle(waves: 6, amplitude: 10)
//                                .stroke(Color.appBlue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .fill(Color.appBlue)
                                .frame(width: 35, height: 35)
                            
                            WavyCircle(waves: 6, amplitude: 10)
//                                .stroke(Color.appRed, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .fill(Color.appRed)
                                .frame(width: 35, height: 35)
                        }
                        HStack {
                            WavyCircle(waves: 6, amplitude: 10)
//                                .stroke(Color.appGreen, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .fill(Color.appGreen)
                                .frame(width: 35, height: 35)
                            WavyCircle(waves: 6, amplitude: 10)
//                                .stroke(Color.appPurple, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .fill(Color.appPurple)
                                .frame(width: 35, height: 35)
                            WavyCircle(waves: 6, amplitude: 10)
//                                .stroke(Color.appBlue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .fill(Color.appBlue)
                                .frame(width: 35, height: 35)
                            
                        }
                        Spacer()
                    }
                    .frame(width: 150, height: 150)
                    .background(.appYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.top, 35)
            Spacer()
        }
        
    }
}

#Preview {
    ToolsAndObjectivesView()
}
