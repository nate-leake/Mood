//
//  ToolsView.swift
//  Mood
//
//  Created by Nate Leake on 4/4/25.
//

import SwiftUI

struct ToolsView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Spacer()
            
            Button {
                openURL(URL(string: "https://www.thetrevorproject.org/get-help/")!)
            } label: {
                HStack {
                    AsyncImage(
                        url: URL(string: "https://d2o3top45uowdm.cloudfront.net/media/CC51D9DC-3B21-4E67-8D4184E07F170D75/3D145023-2354-4BE6-B02765ED4FE3E4E6/webimage-50BCD26B-5CD8-41AA-8DE4001B82EBECDC.png")!,
                        transaction: Transaction(animation: .easeInOut)
                    ) { phase in
                        switch phase {
                        case .empty:
                            EmptyView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 30, maxHeight: 30)
                        case .failure:
                            EmptyView()
                        @unknown default:
                            // Since the AsyncImagePhase enum isn't frozen,
                            // we need to add this currently unused fallback
                            // to handle any new cases that might be added
                            // in the future:
                            EmptyView()
                        }
                    }
                    
                    
                    Text("The Trevor Project")
                }
            }
            .font(.headline)
            .fontWeight(.bold)
            .frame(width: 360, height: 44)
            .foregroundStyle(.white)
            .background(Color(hex: "#ff5a3d"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            
            Button {
                openURL(URL(string: "https://988lifeline.org/")!)
            } label: {
                HStack {
                    Text("988 Suicide & Crisis Lifeline")
                }
            }
            .font(.headline)
            .fontWeight(.bold)
            .frame(width: 360, height: 44)
            .foregroundStyle(.white)
            .background(Color(hex: "#0278a0"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Spacer()
            Text("these recources are not partners of or affiliated with mood")
                .font(.subheadline)
                .foregroundStyle(.appBlack.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .navigationTitle("external resources")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ToolsView()
}
